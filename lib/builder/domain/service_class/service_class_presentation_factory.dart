import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';

class ServiceClassPresentationFactory extends CodeFactory{
  
  ServiceClassPresentationFactory(CodeFactoryContext context): super(context);

  @override
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
      outputPathFactory
          .createOutputClassName(serviceClass.className);

  Type _createSuperClass() => Type('ServiceClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation2.dart');
}
