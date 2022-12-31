import 'dart:async';
import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';

/// Writes the libraries that where generated
/// by the preceding [ReflectPresentationLibraryBuilder]:

class ReflectPresentationLibraryWriter extends Builder {
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {
    try {
      var generatedLibraries =
          await buildStep.fetchResource<GeneratedLibraries>(resource);
      if (generatedLibraries.isEmpty) {
        throw ('No class found that extends $ApplicationPresentation');
      }
      var inputLibraryUri = buildStep.inputId.uri;
      var generatedLibrary =
          generatedLibraries.inputUrisAndLibraries[inputLibraryUri.toString()];

      if (generatedLibrary != null) {
        var outputAssetId = _createOutputAssetId(inputLibraryUri);
        var libraryCode = generatedLibrary.toString();
        print('\nWRITING\n${outputAssetId.uri}\n$libraryCode\n');
        buildStep.writeAsString(outputAssetId, libraryCode);
      }
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  AssetId _createOutputAssetId(Uri inputLibraryUri) {
    var outputPathFactory = PresentationOutputPathFactory(this);
    var outputAssetId = outputPathFactory.createOutputAssetId(inputLibraryUri);
    return outputAssetId;
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['_presentation.dart'] //TODO get from build.yaml options
      };
}
