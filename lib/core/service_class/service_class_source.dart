import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';


/// Contains information on a [ServiceClass]s source code.
/// It is created by the [ServiceClassSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ServiceClassReflection].
class ServiceClassSource extends ClassSource {
  ServiceClassSource({ required super.libraryUri, required super.name});
}

/// Creates a list of [ServiceClassSource]s by using the
/// analyzer package
class ServiceClassSourceFactory extends SourceFactory {
  static const serviceClassesFieldName = 'serviceClasses';

  List<ServiceClassSource> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field = findField(reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    List<ServiceClassSource> sources = [];
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var source = ServiceClassSource(
          name: element.displayName, libraryUri: element.library!.source.uri);
      sources.add(source);
    }

    if (sources.isEmpty) {
      throw Exception('${field.asLibraryMemberPath}: No service classes found.');
    }

    return sources;
  }

  void _validateServiceClassElement(FieldElement field, Element serviceClass) {
    if (serviceClass is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be a class.');
    }
    if (!serviceClass.isPublic) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be public.');
    }
    if (serviceClass.isAbstract) {
      throw ('${field.asLibraryMemberPath}: $serviceClass may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: $serviceClass does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be immutable and therefore must have a constant constructor.');
    }

    //TODO _validateIfHasActionMethods(serviceClassElement);
  }
}
