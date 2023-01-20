import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// Contains information from an [PropertyWidgetFactory] source code.
/// See [SourceClass]
class PropertyWidgetFactorySource extends ClassSource {
  final ClassSource propertyType;

  PropertyWidgetFactorySource(
      ClassSource propertyWidgetFactoryType, this.propertyType)
      : super(
            libraryUri: propertyWidgetFactoryType.libraryUri,
            className: propertyWidgetFactoryType.className);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericTypes', genericTypes)
        .add('propertyType', propertyType)
        .toString();
  }
}

/// Creates [PropertyWidgetFactorySource]s from a [ReflectGuiConfig] class
/// by using the analyzer package.
/// See [SourceClassFactory]
class PropertyWidgetFactorySourceFactory
    extends ReflectGuiConfigPopulateFactory {
  static const propertyWidgetFactoriesFieldName = 'propertyWidgetFactories';
  static const propertyWidgetFactoryName = 'PropertyWidgetFactory';
  static const propertyWidgetFactoryLibraryUri =
      'package:reflect_gui_builder/builder/domain/property_factory/property_widget_factory.dart';
  final SourceContext context;
  PropertyWidgetFactorySourceFactory(this.context);

  @override
  void populateApplicationPresentation() {
    var field = findField(context.applicationPresentationElement,
        propertyWidgetFactoriesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validatePropertyWidgetFactoryElement(field, element);

      var superClass = findSuperClass(
          element, propertyWidgetFactoryLibraryUri, propertyWidgetFactoryName);
      var types = superClass!.typeArguments;
      if (types.isEmpty) {
        throw ('${field.asLibraryMemberPath}: $element must have a generic type.');
      }
      var propertyWidgetFactoryType =
          context.typeFactory.create(element.thisType);
      var propertyType = context.typeFactory
          .create(types.first as InterfaceType);

      var widgetFactory =
          PropertyWidgetFactorySource(propertyWidgetFactoryType, propertyType);

      context.application.propertyWidgetFactories.add(widgetFactory);
    }

    if (context.application.propertyWidgetFactories.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No PropertyWidgetFactories found.');
    }
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
