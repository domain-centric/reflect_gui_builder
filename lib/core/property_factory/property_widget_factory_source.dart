import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';

/// Contains information from an [ActionMethodReflection]s source code.
/// It is created by the [ActionMethodSourceFactory].
class PropertyWidgetFactorySource extends ClassSource {
  final ClassSource propertyType;

  PropertyWidgetFactorySource(
      ClassSource propertyWidgetFactoryType, this.propertyType)
      : super(
            libraryUri: propertyWidgetFactoryType.libraryUri,
            name: propertyWidgetFactoryType.name);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericType', genericType)
        .add('propertyType', propertyType)
        .toString();
  }
}

/// Creates a list of [PropertyWidgetFactorySource]s by using the
/// analyzer package
class PropertyWidgetFactorySourceFactory extends SourceFactory {
  static const propertyWidgetFactoriesFieldName = 'propertyWidgetFactories';
  static const propertyWidgetFactoryName = 'PropertyWidgetFactory';
  static const propertyWidgetFactoryLibraryUri =
      'package:reflect_gui_builder/core/property_factory/property_widget_factory.dart';

  List<PropertyWidgetFactorySource> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field =
        findField(reflectGuiConfigElement, propertyWidgetFactoriesFieldName);

    var elements = findInitializerElements(field);
    List<PropertyWidgetFactorySource> sources = [];
    for (var element in elements) {
      _validatePropertyWidgetFactoryElement(field, element);

      var superClass = findSuperClass(element as InterfaceElement,
          propertyWidgetFactoryLibraryUri, propertyWidgetFactoryName);
      var types = superClass!.typeArguments;
      if (types.isEmpty) {
        throw ('${field.asLibraryMemberPath}: $element must have a generic type.');
      }
      var genericElement = types.first.element;
      if (genericElement == null) {
        throw ('${field.asLibraryMemberPath}: $element must have a generic type.');
      }
      var classReflection = createClassReflection(element);
      var propertyType =
          createClassReflection(genericElement as InterfaceElement);

      var source = PropertyWidgetFactorySource(classReflection, propertyType);

      sources.add(source);
    }

    if (sources.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No PropertyWidgetFactories found.');
    }

    return sources;
  }

  void _validatePropertyWidgetFactoryElement(
      FieldElement field, Element propertyWidgetFactory) {
    if (propertyWidgetFactory is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory must be a class.');
    }
    if (!propertyWidgetFactory.isPublic) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory must be public.');
    }
    if (propertyWidgetFactory.isAbstract) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(propertyWidgetFactory)) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(propertyWidgetFactory)) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory must be immutable and therefore must have a constant constructor.');
    }

    if (!hasSuperClass(propertyWidgetFactory, propertyWidgetFactoryLibraryUri,
        propertyWidgetFactoryName)) {
      throw ('${field.asLibraryMemberPath}: $propertyWidgetFactory must extend $propertyWidgetFactoryName');
    }
  }
}
