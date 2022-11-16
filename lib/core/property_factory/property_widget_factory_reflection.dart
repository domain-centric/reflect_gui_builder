import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';
/// Contains information on a [PropertyWidgetFactory]
class PropertyWidgetFactoryReflection extends ClassReflection {
  final ClassReflection propertyType;

  PropertyWidgetFactoryReflection(
      ClassReflection classReflection, this.propertyType)
      : super(
            libraryUri: classReflection.libraryUri, name: classReflection.name);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('fullUri', fullUri)
        .add('genericType', genericType)
        .add('propertyType', propertyType)
        .toString();
  }
}


/// Creates a list of [PropertyWidgetFactoryReflection]s by using the
/// analyzer package
class PropertyWidgetFactoryReflectionFactory extends ReflectionFactory {
  static const propertyWidgetFactoriesFieldName = 'propertyWidgetFactories';
  static const propertyWidgetFactoryName = 'PropertyWidgetFactory';
  static const propertyWidgetFactoryLibraryUri =
      'package:reflect_gui_builder/core/property_factory/property_widget_factory.dart';

  List<PropertyWidgetFactoryReflection> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field =
    findField(reflectGuiConfigElement, propertyWidgetFactoriesFieldName);

    var elements = findInitializerElements(field);
    List<PropertyWidgetFactoryReflection> reflections = [];
    for (var element in elements) {
      _validatePropertyWidgetFactoryElement(field, element);

      var superClass = findSuperClass(element as InterfaceElement,
          propertyWidgetFactoryLibraryUri, propertyWidgetFactoryName);
      var types = superClass!.typeArguments;
      if (types.isEmpty) {
        throw ('${field.asUri}: $element must have a generic type.');
      }
      var genericElement = types.first.element;
      if (genericElement == null) {
        throw ('${field.asUri}: $element must have a generic type.');
      }
      var classReflection = createClassReflection(element);
      var propertyType =
      createClassReflection(genericElement as InterfaceElement);

      var reflection =
      PropertyWidgetFactoryReflection(classReflection, propertyType);

      reflections.add(reflection);
    }

    if (reflections.isEmpty) {
      throw Exception('${field.asUri}: No PropertyWidgetFactories found.');
    }

    return reflections;
  }

  void _validatePropertyWidgetFactoryElement(
      FieldElement field, Element propertyWidgetFactory) {
    if (propertyWidgetFactory is! ClassElement) {
      throw ('${field.asUri}: $propertyWidgetFactory must be a class.');
    }
    if (!propertyWidgetFactory.isPublic) {
      throw ('${field.asUri}: $propertyWidgetFactory must be public.');
    }
    if (propertyWidgetFactory.isAbstract) {
      throw ('${field.asUri}: $propertyWidgetFactory may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(propertyWidgetFactory)) {
      throw ('${field.asUri}: $propertyWidgetFactory does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(propertyWidgetFactory)) {
      throw ('${field.asUri}: $propertyWidgetFactory must be immutable and therefore must have a constant constructor.');
    }

    if (!hasSuperClass(propertyWidgetFactory, propertyWidgetFactoryLibraryUri,
        propertyWidgetFactoryName)) {
      throw ('${field.asUri}: $propertyWidgetFactory must extend $propertyWidgetFactoryName');
    }

  }
}
