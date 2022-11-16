import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';
/// Contains information on a [ActionMethodParameterProcessor]
class ActionMethodParameterProcessorReflection extends ClassReflection {
  final ClassReflection parameterType;

  ActionMethodParameterProcessorReflection(
      ClassReflection classReflection, this.parameterType)
      : super(
            libraryUri: classReflection.libraryUri, name: classReflection.name);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('fullUri', fullUri)
        .add('genericType', genericType)
        .add('parameterType', parameterType)
        .toString();
  }
}


/// Creates a list of [ActionMethodParameterProcessorReflection]s by using the
/// analyzer package
class ActionMethodParameterProcessorReflectionFactory extends ReflectionFactory {
  static const actionMethodParameterProcessorFieldName = 'actionMethodParameterProcessors';
  static const actionMethodParameterProcessorName = 'ActionMethodParameterProcessor';
  static const actionMethodParameterProcessorLibraryUri =
      'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor.dart';

  List<ActionMethodParameterProcessorReflection> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field =
    findField(reflectGuiConfigElement, actionMethodParameterProcessorFieldName);

    var elements = findInitializerElements(field);
    List<ActionMethodParameterProcessorReflection> reflections = [];
    for (var element in elements) {
      _validatePropertyWidgetFactoryElement(field, element);

      var superClass = findSuperClass(element as InterfaceElement,
          actionMethodParameterProcessorLibraryUri, actionMethodParameterProcessorName);
      var types = superClass!.typeArguments;
      if (types.isEmpty) {
        throw ('${field.asUri}: $element must have a generic type.');
      }
      var genericElement = types.first.element;
      if (genericElement == null) {
        throw ('${field.asUri}: $element must have a generic type.');
      }
      var classReflection = createClassReflection(element);
      var parameterType =
      createClassReflection(genericElement as InterfaceElement);

      var reflection =
      ActionMethodParameterProcessorReflection(classReflection, parameterType);

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

    if (!hasSuperClass(propertyWidgetFactory, actionMethodParameterProcessorLibraryUri,
        actionMethodParameterProcessorName)) {
      throw ('${field.asUri}: $propertyWidgetFactory must extend $actionMethodParameterProcessorName');
    }

  }
}
