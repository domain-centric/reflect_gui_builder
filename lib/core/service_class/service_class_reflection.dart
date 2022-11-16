import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../documentation.dart';
import '../reflect_gui/reflection_factory.dart';

/// TODO, for inspiration see https://github.com/reflect-framework/reflect-framework/wiki/03-The-Service-Layer#service-objects
class ServiceClass implements ConceptDocumentation {}

/// Contains information on a [ServiceClass]
class ServiceClassReflection extends ClassReflection {
  ServiceClassReflection({required super.name, required super.libraryUri});
}

/// Creates a list of [ServiceClassReflection]s by using the
/// analyzer package
class ServiceClassReflectionFactory extends ReflectionFactory {
  static const serviceClassesFieldName = 'serviceClasses';

  List<ServiceClassReflection> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field = findField(reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    List<ServiceClassReflection> reflections = [];
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var reflection = ServiceClassReflection(
          name: element.displayName, libraryUri: element.library!.source.uri);
      reflections.add(reflection);
    }

    if (reflections.isEmpty) {
      throw Exception('${field.asUri}: No service classes found.');
    }

    return reflections;
  }

  void _validateServiceClassElement(FieldElement field, Element serviceClass) {
    if (serviceClass is! ClassElement) {
      throw ('${field.asUri}: $serviceClass must be a class.');
    }
    if (!serviceClass.isPublic) {
      throw ('${field.asUri}: $serviceClass must be public.');
    }
    if (serviceClass.isAbstract) {
      throw ('${field.asUri}: $serviceClass may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asUri}: $serviceClass does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asUri}: $serviceClass must be immutable and therefore must have a constant constructor.');
    }

    //TODO _validateIfHasActionMethods(serviceClassElement);
  }
}
