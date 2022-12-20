import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';

import 'domain/application/generated_application_presentation_factory.dart';
import 'domain/application/application_presentation_source.dart';

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

      for (var topElement in library.topLevelElements) {
        if (sourceFactory.isValidApplicationPresentationElement(topElement)) {
          var applicationPresentationSource =
              sourceFactory.create(this, topElement as ClassElement);
          log.info('\n$applicationPresentationSource');
          var presentationOutputPathFactory =
              PresentationOutputPathFactory(this);
          var presentationFactory = GeneratedApplicationPresentationFactory(
              presentationOutputPathFactory, applicationPresentationSource);
          presentationFactory.create();
        }
      }
      //TODO throw an error when no ReflectGuiConfiguration implementations are found
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.no_output'] //TODO get from build.yaml file
      };
}
