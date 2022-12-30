import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/application/generated_application_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation_factory.dart';

/// Generates libraries:
/// * Finds classes that implement [ApplicationPresentation]
/// * Creates [ApplicationPresentationSource]s from these classes
/// * Converts [ApplicationPresentationSource]s to [GeneratedLibraries]
/// * Stores these [GeneratedLibraries] into the [BuildStep] so it
///   can be used by the [ReflectPresentationLibraryWriter]

class ReflectPresentationLibraryBuilder extends Builder {
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {
    try {
      var library = await buildStep.inputLibrary;

      var sourceFactory = ApplicationPresentationSourceFactory();
      var generatedLibraries =
          await buildStep.fetchResource<GeneratedLibraries>(resource);

      for (var topElement in library.topLevelElements) {
        if (sourceFactory.isValidApplicationPresentationElement(topElement)) {
          var applicationPresentationSource =
              sourceFactory.create(this, topElement as ClassElement);
          //log.info('\n$applicationPresentationSource');

          CodeFactoryContext context = CodeFactoryContext(
              this, generatedLibraries, applicationPresentationSource);

          GeneratedApplicationPresentationFactory(context).populate();
          ServiceClassPresentationFactory(context).populate();
        }
      }

//TODO remove commented code

      // if (generatedLibraries.inputUrisAndLibraries.isNotEmpty) {
      //   log.info('\n${generatedLibraries.inputUrisAndLibraries}');
      //   var outputAssetIdsAndLibraries =
      //       generatedLibraries.outputAssetIdsAndLibraries;
      //   for (var entry in outputAssetIdsAndLibraries.entries) {
      //     var outputAssetId = entry.key;
      //     // var outputFile = _createOutputFile(outputAssetId);
      //     // FutureOr<String> generatedLibraryCode = Future.value(entry.value);
      //     // outputFile.writeAsString(entry.value);
      //     // TODO buildStep.writeAsString(outputAssetId, generatedLibraryCode);
      //   }
      // }

      //TODO throw an error when no ReflectGuiConfiguration implementations are found
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  // void _populateWithApplicationPresentation(
  //     ApplicationPresentationSource applicationPresentationSource,
  //     GeneratedLibraries generatedLibraries) {
  //   var presentationFactory = GeneratedApplicationPresentationFactory(
  //       applicationPresentationSource, generatedLibraries);
  //   presentationFactory.populate();
  // }

  // void _populateWithServiceClassPresentations(
  //     ApplicationPresentationSource applicationPresentationSource,
  //     GeneratedLibraries generatedLibraries) {
  //   var presentationFactory = ServiceClassPresentationFactory(
  //       applicationPresentationSource, generatedLibraries);
  //   presentationFactory.populate();
  // }

  // File _createOutputFile(AssetId outputAssetId) {
  //   var assetUri = outputAssetId.uri;
  //   var projectDirectory = Directory.current.path;
  //   var filePath = [projectDirectory, 'lib', ...assetUri.pathSegments.skip(1)]
  //       .join(Platform.pathSeparator);
  //   return File(filePath);
  // }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': [
          //This builder has no outputs, see generatedLibraries
          '.noOutput',
           ] 
      };
}
