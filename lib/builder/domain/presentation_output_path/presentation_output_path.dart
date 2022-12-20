import 'package:build/build.dart';

/// A factory that creates an output path for [PresentationClass]es

class PresentationOutputPathFactory {
  final Builder builder;

  PresentationOutputPathFactory(this.builder);

  String createOutputClassName(String inputClassName) =>
      '${inputClassName}Presentation';
  //TODO add $ before class name to indicate that the class is generated

  AssetId createOutputAssetId(Uri importUri) {
    //AssetId assetIdInput = ImportAssetId(importUri);
    AssetId assetIdInput = AssetId.resolve(importUri);
    var assetIdOutputs = expectedOutputs(builder, assetIdInput);
    if (assetIdOutputs.length > 1) {
      throw ('The build_extension may only have one output path defined (in build.yaml)');
    }
    if (assetIdOutputs.isEmpty) {
      throw ('The build_extension has no output path defined (in build.yaml)');
    }
    return assetIdOutputs.first;
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
  Uri createImportOutputUri(Uri importUriInput) {
    var outputAssetId = createOutputAssetId(importUriInput);
    var outputUri = outputAssetId.uri;
    return outputUri;
  }
}
