import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/documentation.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';

/// TODO See: https://github.com/reflect-framework/reflect-framework/wiki/02-The-Domain-Layer#TheDomainLayer_DomainObjects
class DomainClass implements ConceptDocumentation {}

/// Contains information on a [DomainClass]s source code.
class DomainClassSource extends ClassSource {

  DomainClassSource({required super.name, required super.libraryUri});
}

/// Creates a [DomainClassSource]s by using the
/// analyzer package
class DomainClassSourceFactory extends SourceFactory {

  DomainClassSource? createFrom(
      ClassElement reflectGuiConfigElement) {


    return null; //TODO
  }

  void _validateDomainClassElement(FieldElement field, Element domainClass) {
    if (domainClass is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: $domainClass must be a class.');
    }
    if (!domainClass.isPublic) {
      throw ('${field.asLibraryMemberPath}: $domainClass must be public.');
    }
    if (domainClass.isAbstract) {
      throw ('${field.asLibraryMemberPath}: $domainClass may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(domainClass)) {
      throw ('${field.asLibraryMemberPath}: $domainClass does not have a nameless constructor without parameters.');
    }

    //TODO _validateIfHasAtLeastOneProperty;

  }

}
