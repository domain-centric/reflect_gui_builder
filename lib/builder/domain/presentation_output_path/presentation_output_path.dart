import 'package:build/build.dart';
import 'package:fluent_regex/fluent_regex.dart';

/// A factory that creates an output path for [PresentationClass]es

class PresentationOutputPathFactory {
  final Builder builder;
  late _ParsedBuildOutput _parsedExtension;

  PresentationOutputPathFactory(this.builder) {
    ///TODO get inputPath and outputPath from build options (or use these default values)
    String inputPath = '^lib/{{}}.dart';
    String outputPath = 'lib/{{}}_presentation.dart';
    _parsedExtension = _ParsedBuildOutput.parse(builder, inputPath, outputPath);
  }

  /// Collects the expected AssetIds created by [builder] when given [input] based
  /// on the extension configuration.
  AssetId _expectedOutput(Builder builder, AssetId input) {
    var output = _parsedExtension.matchingOutputFor(input);
    if (output == null) {
      throw ArgumentError('The builder `$builder` has no valid output. '
          'Define a valid inputPath and outputPath in the build options in the '
          'build.yaml file.');
    }

    if (output == input) {
      throw ArgumentError(
        'The builder `$builder` declares an output "$output" which is '
        'identical to its input, which is not allowed.',
      );
    }
    return output;
  }

  static final presentationSuffix =
      FluentRegex().ignoreCase().literal('presentation').endOfLine();

  /// The outputClassName:
  /// * Starts with a dollar sign to indicate that it is an generated class
  ///   (an also to more likely have a unique name)
  /// * End with the Presentation suffix to indicate it is a class
  ///   in the presentation layer
  String createOutputClassName(String inputClassName) =>
      '\$${presentationSuffix.removeFirst(inputClassName)}Presentation';

  AssetId createOutputAssetId(Uri importUri) {
    //AssetId assetIdInput = ImportAssetId(importUri);
    AssetId assetIdInput = AssetId.resolve(importUri);
    return _expectedOutput(builder, assetIdInput);
  }

  /// [importUri] is converted to one or [outputLibraryUris],
  /// using the buildExtension parameter in the build.yaml file.
  ///
  /// You can use [capture groups](https://github.com/dart-lang/build/blob/master/docs/writing_a_builder.md#capture-groups)
  /// to define where the out put files needs to be stored
  ///
  /// Example1:
  ///
  /// build_extensions:
  ///    ^lib/{{}}.dart:
  ///      - lib/{{}}_presentation.dart
  ///
  /// converts: package:my_app/..../person/person_domain.dart
  /// to:       package:my_app/..../person/person_domain_presentation.dart
  ///
  /// Example2:
  ///
  /// build_extensions:
  ///    ^lib/{{}}.dart:
  ///      - lib/presentation/{{}}.dart
  ///
  /// converts: package:my_app/..../domain/person/person.dart
  /// to:       package:my_app/presentation/..../domain/person/person_presentation.dart
  ///
  /// Note that the build_to parameter defines if the files will be written in
  /// the cache or source folder.
  Uri createOutputUri(Uri importUriInput) {
    var outputAssetId = createOutputAssetId(importUriInput);
    var outputUri = outputAssetId.uri;
    return outputUri;
  }
}

/// **************************************************************************
/// The following is borrowed and adapted 
/// from package:build\expected_outputs.dart
/// So we can get the expected output path using build options
/// **************************************************************************

// Regexp for capture groups.
final RegExp _captureGroupRegexp = RegExp('{{(\\w*)}}');

extension on AssetId {
  /// Replaces the last [suffixLength] characters with [newSuffix].
  AssetId replaceSuffix(int suffixLength, String newSuffix) {
    return AssetId(
        package, path.substring(0, path.length - suffixLength) + newSuffix);
  }
}

abstract class _ParsedBuildOutput {
  _ParsedBuildOutput();

  factory _ParsedBuildOutput.parse(
      Builder builder, String input, String output) {
    final matches = _captureGroupRegexp.allMatches(input).toList();
    if (matches.isNotEmpty) {
      return _CapturingBuildOutputs.parse(builder, input, output, matches);
    }

    // Make sure that no outputs use capture groups, if they aren't used in
    // inputs.

    if (_captureGroupRegexp.hasMatch(output)) {
      throw ArgumentError(
        'The builder `$builder` declares an output "$output" using a '
        'capture group. As its input "$input" does not use a capture '
        'group, this is forbidden.',
      );
    }

    if (input.startsWith('^')) {
      return _FullMatchBuildOutputs(input.substring(1), output);
    } else {
      return _SuffixBuildOutputs(input, output);
    }
  }

  bool hasAnyOutputFor(AssetId input);
  AssetId? matchingOutputFor(AssetId input);
}

/// A simple build input/output set that matches an entire path and doesn't use
/// capture groups.
class _FullMatchBuildOutputs extends _ParsedBuildOutput {
  final String inputExtension;
  final String outputExtension;

  _FullMatchBuildOutputs(this.inputExtension, this.outputExtension);

  @override
  bool hasAnyOutputFor(AssetId input) => input.path == inputExtension;

  @override
  AssetId? matchingOutputFor(AssetId input) {
    if (!hasAnyOutputFor(input)) return null;

    // If we expect an output, the asset's path ends with the input extension.
    // Expected outputs just replace the matched suffix in the path.
    return AssetId(input.package, outputExtension);
  }
}

/// A simple build input/output set which matches file suffixes and doesn't use
/// capture groups.
class _SuffixBuildOutputs extends _ParsedBuildOutput {
  final String inputExtension;
  final String outputExtension;

  _SuffixBuildOutputs(this.inputExtension, this.outputExtension);

  @override
  bool hasAnyOutputFor(AssetId input) => input.path.endsWith(inputExtension);

  @override
  AssetId? matchingOutputFor(AssetId input) {
    if (!hasAnyOutputFor(input)) return null;

    // If we expect an output, the asset's path ends with the input extension.
    // Expected outputs just replace the matched suffix in the path.
    return input.replaceSuffix(inputExtension.length, outputExtension);
  }
}

/// A build input with a capture group `{{}}` that's referenced in the outputs.
class _CapturingBuildOutputs extends _ParsedBuildOutput {
  final RegExp _pathMatcher;

  /// The names of all capture groups used in the inputs.
  ///
  /// The [_pathMatcher] will always match the same amount of groups in the
  /// same order.
  final List<String> _groupNames;
  final String _output;

  _CapturingBuildOutputs(this._pathMatcher, this._groupNames, this._output);

  factory _CapturingBuildOutputs.parse(
      Builder builder, String input, String output, List<RegExpMatch> matches) {
    final regexBuffer = StringBuffer();
    var positionInInput = 0;
    if (input.startsWith('^')) {
      regexBuffer.write('^');
      positionInInput = 1;
    }

    // Builders can have multiple capture groups, which are disambiguated by
    // their name. Names can be empty as well: `{{}}` is a valid capture group.
    final names = <String>[];

    for (final match in matches) {
      final name = match.group(1)!;
      if (names.contains(name)) {
        throw ArgumentError(
          'The builder `$builder` declares an input "$input" which contains '
          'multiple capture groups with the same name (`{{$name}}`). This is '
          'not allowed.',
        );
      }
      names.add(name);

      // Write the input regex from the last position up until the start of
      // this capture group.
      assert(positionInInput <= match.start);
      regexBuffer
        ..write(RegExp.escape(input.substring(positionInInput, match.start)))
        // Introduce the capture group.
        ..write('(.+)');
      positionInInput = match.end;
    }

    // Write the input part after the last capture group.
    regexBuffer
      ..write(RegExp.escape(input.substring(positionInInput)))
      // This is a build extension, so we're always matching suffixes.
      ..write(r'$');

    // When using a capture group in the build input, it must also be used in
    // every output to ensure outputs have unique names.
    // Also, an output must not refer to capture groups that aren't included in
    // the input.
    final remainingNames = names.toSet();

    // Ensure that the output extension does not refer to unknown groups, and
    // that no group appears in the output multiple times.
    for (final outputMatch in _captureGroupRegexp.allMatches(output)) {
      final outputName = outputMatch.group(1)!;
      if (!remainingNames.remove(outputName)) {
        throw ArgumentError(
          'The builder `$builder` declares an output "$output", which uses '
          'the capture group "$outputName". This group does not exist or has '
          'been referenced multiple times which is not allowed!',
        );
      }
    }

    // Finally, ensure that each capture group from the input appears in this
    // output.
    if (remainingNames.isNotEmpty) {
      throw ArgumentError(
        'The builder `$builder` declares an input "$input" using a capture '
        'group. It is required that all of its outputs also refer to that '
        'capture group exactly once. However, "$output" does not refer to '
        '${remainingNames.join(', ')}!',
      );
    }

    return _CapturingBuildOutputs(
        RegExp(regexBuffer.toString()), names, output);
  }

  @override
  bool hasAnyOutputFor(AssetId input) => _pathMatcher.hasMatch(input.path);

  @override
  AssetId? matchingOutputFor(AssetId input) {
    // There may be multiple matches when a capture group appears at the
    // beginning or end of an input string. We always want a group to match as
    // much as possible, so we use the first match.
    final match = _pathMatcher.firstMatch(input.path);
    if (match == null) {
      // The build input doesn't match the input asset, so the builder shouldn't
      // run and no outputs are expected.
      return null;
    }

    final lengthOfMatch = match.end - match.start;

    final resolvedOutput = _output.replaceAllMapped(
      _captureGroupRegexp,
      (outputMatch) {
        final name = outputMatch.group(1)!;
        final index = _groupNames.indexOf(name);
        assert(
          !index.isNegative,
          'Output refers to a group not declared in the input extension. '
          'Validation was supposed to catch that.',
        );

        // Regex group indices start at 1.
        return match.group(index + 1)!;
      },
    );
    return input.replaceSuffix(lengthOfMatch, resolvedOutput);
  }
}
