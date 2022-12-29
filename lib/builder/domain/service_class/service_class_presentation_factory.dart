import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';

class ServiceClassPresentationFactory {
  final ApplicationPresentationSource application;
  final GeneratedLibraries generatedLibraries;

  ServiceClassPresentationFactory(this.application, this.generatedLibraries);

  void populate() {
    for (var serviceClass in application.serviceClasses) {
      var librarySourceUri = serviceClass.libraryUri.toString();
      var classToAdd = _createClass(serviceClass);
      generatedLibraries.addClass(librarySourceUri, classToAdd);
    }
  }

  Class _createClass(ServiceClassSource serviceClass) => Class(
        _createClassName(serviceClass),
        superClass: _createSuperClass(),
      );

  String _createClassName(ServiceClassSource serviceClass) =>
      generatedLibraries.outputPathFactory
          .createOutputClassName(serviceClass.className);

  Type _createSuperClass() => Type('ServiceClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation.dart');
}
