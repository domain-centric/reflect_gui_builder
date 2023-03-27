import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application_class/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// Contains information from an [ValueWidgetFactory] source code.
/// See [SourceClass]
class ValueWidgetFactorySource extends ClassSource {
  final ClassSource valueType;

  ValueWidgetFactorySource(ClassSource widgetFactoryType, this.valueType)
      : super(
            libraryUri: widgetFactoryType.libraryUri,
            className: widgetFactoryType.className);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericTypes', genericTypes)
        .add('valueType', valueType)
        .toString();
  }
}

/// Creates [ValueWidgetFactorySource]s from a [ReflectGuiConfig] class
/// by using the analyzer package.
/// See [SourceClassFactory]
class ValueWidgetFactorySourceFactory extends ReflectGuiConfigPopulateFactory {
  static const valueWidgetFactoriesFieldName = 'valueWidgetFactories';
  static const valueWidgetFactoryName = 'ValueWidgetFactory';
  static const valueWidgetFactoryLibraryUri =
      'package:reflect_gui_builder/builder/domain/value_widget_factory/value_widget_factory.dart';
  final SourceContext context;
  ValueWidgetFactorySourceFactory(this.context);

  @override
  void populateApplicationPresentation() {
    var field = findField(
        context.applicationPresentationElement, valueWidgetFactoriesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validateValueWidgetFactoryElement(field, element);

      var superClass = findSuperClass(
          element, valueWidgetFactoryLibraryUri, valueWidgetFactoryName);
      var types = superClass!.typeArguments;
      if (types.isEmpty) {
        throw ('${field.asLibraryMemberPath}: $element must have a generic type.');
      }
      var valueWidgetFactoryType = context.typeFactory.create(element.thisType);
      var valueType = context.typeFactory.create(types.first as InterfaceType);

      var widgetFactory =
          ValueWidgetFactorySource(valueWidgetFactoryType, valueType);

      context.application.valueWidgetFactories.add(widgetFactory);
    }

    if (context.application.valueWidgetFactories.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No ValueWidgetFactories found.');
    }
  }

  void _validateValueWidgetFactoryElement(
      FieldElement field, Element valueWidgetFactory) {
    if (valueWidgetFactory is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: $valueWidgetFactory must be a class.');
    }
    if (!valueWidgetFactory.isPublic) {
      throw ('${field.asLibraryMemberPath}: $valueWidgetFactory must be public.');
    }
    if (valueWidgetFactory.isAbstract) {
      throw ('${field.asLibraryMemberPath}: $valueWidgetFactory may not be abstract.');
    }
    //TODO remove???
    // if (!hasNamelessConstructorWithoutParameters(valueWidgetFactory)) {
    //   throw ('${field.asLibraryMemberPath}: $valueWidgetFactory does not have a nameless constructor without parameters.');
    // }
    // if (!hasConstNamelessConstructorWithoutParameters(valueWidgetFactory)) {
    //   throw ('${field.asLibraryMemberPath}: $valueWidgetFactory must be immutable and therefore must have a constant constructor.');
    // }

    if (!hasSuperClass(valueWidgetFactory, valueWidgetFactoryLibraryUri,
        valueWidgetFactoryName)) {
      throw ('${field.asLibraryMemberPath}: $valueWidgetFactory must extend $valueWidgetFactoryName');
    }
  }
}
