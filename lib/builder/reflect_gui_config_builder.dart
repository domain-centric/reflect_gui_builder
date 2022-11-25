import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import '../core/reflect_gui/reflect_gui_source.dart';

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

      var reflectGuiReflectFactory = ReflectGuiConfigSourceFactory();

      for (var topElement in library.topLevelElements) {
        if (reflectGuiReflectFactory
            .isValidReflectGuiConfigElement(topElement)) {
          var reflectGuiReflection =
              reflectGuiReflectFactory.create(topElement as ClassElement);
          log.info('\n$reflectGuiReflection');
          //TODO Store instances as a [BuildStep] resource so it can be used by other builders and store as [BuildStep] resource so it can be used by other builders
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
