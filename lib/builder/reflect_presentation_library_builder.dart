import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation_factory.dart';
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

      if (libraryToInclude(library)) {
        print('--${library.source}');

        var generatedLibraries =
            await buildStep.fetchResource<GeneratedLibraries>(resource);

        _populateGeneratedLibraries(library, generatedLibraries);
      }
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  void _populateGeneratedLibraries(
      LibraryElement library, GeneratedLibraries generatedLibraries) {
    var sourceFactory = ApplicationPresentationSourceFactory();
    for (var topElement in library.topLevelElements) {
      if (sourceFactory.isValidApplicationPresentationElement(topElement)) {
        var applicationPresentationSource =
            sourceFactory.create(this, topElement as ClassElement);
        //log.info('\n$applicationPresentationSource');

        CodeFactoryContext context = CodeFactoryContext(
            this, generatedLibraries, applicationPresentationSource);

        GeneratedApplicationPresentationFactory(context).populate();
        ServiceClassPresentationFactory(context).populate();
        DomainClassPresentationFactory(context).populate();
      }
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

/// No need to process the dart files in: package:reflect_gui_builder/builder/
bool libraryToInclude(LibraryElement library) => !library.source.uri
    .toString()
    .startsWith('package:reflect_gui_builder/builder/');
