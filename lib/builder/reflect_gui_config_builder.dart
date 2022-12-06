import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'domain/reflect_gui/reflect_gui_reflect.dart';
import 'domain/reflect_gui/reflect_gui_source.dart';

/// Finds classes that implement [ReflectGuiConfig]
/// Creates instances, see [reflectGuiConfigs] below
/// Stores instances as a [BuildStep] resource so it can be used by other builders
class ReflectGuiConfigBuilder extends Builder {
  @override
  Future<FutureOr<void>> build(BuildStep buildStep) async {
    try {
      buildStep.inputId;
      // Get the `LibraryElement` for the primary input.
      var library = await buildStep.inputLibrary;

      var sourceFactory = ReflectGuiConfigSourceFactory();
      var reflectionFactory = ReflectGuiConfigReflectionFactory();

      for (var topElement in library.topLevelElements) {
        if (sourceFactory
            .isValidReflectGuiConfigElement(topElement)) {
          var reflectGuiConfigSource =
              sourceFactory.create(topElement as ClassElement);
          log.info('\n$reflectGuiConfigSource');
          var reflection= reflectionFactory.create(reflectGuiConfigSource);
        }
      }
      //TODO throw an error when no ReflectGuiConfiguration implementations are found
    } catch (e, stackTrace) {
      log.severe('Failed\n$e\n$stackTrace');
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.NoOutput']
      };
}
