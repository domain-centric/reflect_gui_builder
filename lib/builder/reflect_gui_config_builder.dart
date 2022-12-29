import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';

import 'domain/application/generated_application_presentation_factory.dart';
import 'domain/application/application_presentation_source.dart';
import 'domain/service_class/service_class_presentation_factory.dart';

/// Finds classes that implement [ApplicationPresentation]
/// Creates [ApplicationPresentationSource]s from these classes
/// Converts [ApplicationPresentationSource]s to [PresentationClass]es
/// Writes [PresentationClass]es as generated libraries

class ReflectGuiConfigBuilder extends Builder {
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {
    try {
      buildStep.inputId;
      // Get the `LibraryElement` for the primary input.
      var library = await buildStep.inputLibrary;

      var sourceFactory = ApplicationPresentationSourceFactory();
      var outputPathFactory = PresentationOutputPathFactory(this);
      var generatedLibraries = GeneratedLibraries(outputPathFactory);

      for (var topElement in library.topLevelElements) {
        if (sourceFactory.isValidApplicationPresentationElement(topElement)) {
          var applicationPresentationSource =
              sourceFactory.create(this, topElement as ClassElement);
          //log.info('\n$applicationPresentationSource');

          _populateWithApplicationPresentation(
              applicationPresentationSource, generatedLibraries);
          _populateWithServiceClassPresentations(
              applicationPresentationSource, generatedLibraries);
        }
      }

      if (generatedLibraries.inputUrisAndLibraries.isNotEmpty) {
        log.info('\n${generatedLibraries.inputUrisAndLibraries}');
        var outputAssetIdsAndLibraries =
            generatedLibraries.outputAssetIdsAndLibraries;
        for (var entry in outputAssetIdsAndLibraries.entries) {
          var outputAssetId = entry.key;
          var outputFile = _createOutputFile(outputAssetId);
          FutureOr<String> generatedLibraryCode = Future.value(entry.value);
          outputFile.writeAsString(entry.value);
          // TODO buildStep.writeAsString(outputAssetId, generatedLibraryCode);
        }
      }

      //TODO throw an error when no ReflectGuiConfiguration implementations are found
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  void _populateWithApplicationPresentation(
      ApplicationPresentationSource applicationPresentationSource,
      GeneratedLibraries generatedLibraries) {
    var presentationFactory = GeneratedApplicationPresentationFactory(
        applicationPresentationSource, generatedLibraries);
    presentationFactory.populate();
  }

  void _populateWithServiceClassPresentations(
      ApplicationPresentationSource applicationPresentationSource,
      GeneratedLibraries generatedLibraries) {
    var presentationFactory = ServiceClassPresentationFactory(
        applicationPresentationSource, generatedLibraries);
    presentationFactory.populate();
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['_presentation.dart'] //TODO get from build.yaml file
      };

  File _createOutputFile(AssetId outputAssetId) {
    var assetUri = outputAssetId.uri;
    var projectDirectory = Directory.current.path;
    var filePath = [projectDirectory, 'lib', ...assetUri.pathSegments.skip(1)]
        .join(Platform.pathSeparator);
    return File(filePath);
  }
}
