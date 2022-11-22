import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';

/// Contains information on a [ActionMethodParameterProcessor]s source code.
/// It is created by the [ActionMethodParameterProcessorSourceFactory]
class ActionMethodParameterProcessorSource extends ClassSource {
  /// null = [ActionMethod] has no parameter
  final ClassSource? parameterType;

  ActionMethodParameterProcessorSource(
      {required ClassSource actionMethodParameterProcessorType,
      this.parameterType})
      : super(
            libraryUri: actionMethodParameterProcessorType.libraryUri,
            libraryMemberPath: actionMethodParameterProcessorType.libraryMemberPath);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('parameterType', parameterType)
        .toString();
  }
}

/// Creates a list of [ActionMethodParameterProcessorSource]s by using the
/// analyzer package
class ActionMethodParameterProcessorSourceFactory extends SourceFactory {
  static const actionMethodParameterProcessorFieldName =
      'actionMethodParameterProcessors';
  static const actionMethodParameterProcessorName =
      'ActionMethodParameterProcessor';
  static const actionMethodParameterProcessorLibraryUri =
      'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor.dart';

  List<ActionMethodParameterProcessorSource> createFrom(
      ClassElement reflectGuiConfigElement) {
    var field = findField(
        reflectGuiConfigElement, actionMethodParameterProcessorFieldName);

    var elements = findInitializerElements(field);
    List<ActionMethodParameterProcessorSource> sources = [];
    for (var element in elements) {
      _validate(field, element);

      var source = ActionMethodParameterProcessorSource(
          actionMethodParameterProcessorType:
          ClassSource.fromInterfaceElement(element as ClassElement),
          parameterType: _createParameterType(element, field));

      sources.add(source);
    }

    if (sources.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No ActionMethodResultProcessors found.');
    }

    return sources;
  }

  ClassSource? _createParameterType(Element element, FieldElement field) {
    var superClass = findSuperClass(
        element as InterfaceElement,
        actionMethodParameterProcessorLibraryUri,
        actionMethodParameterProcessorName);
    var types = superClass!.typeArguments;
    if (types.isEmpty) {
      return null;
    }
    var genericElement = types.first.element;
    if (genericElement == null) {
      return null;
    }
    var parameterType =
        ClassSource.fromInterfaceElement(genericElement as InterfaceElement);
    return parameterType;
  }

  void _validate(FieldElement field, Element actionMethodParameterProcessor) {
    if (actionMethodParameterProcessor is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} must be a class.');
    }
    if (!actionMethodParameterProcessor.isPublic) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} must be public.');
    }
    if (actionMethodParameterProcessor.isAbstract) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(
        actionMethodParameterProcessor)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(
        actionMethodParameterProcessor)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} must be immutable and therefore must have a constant constructor.');
    }

    if (!hasSuperClass(
        actionMethodParameterProcessor,
        actionMethodParameterProcessorLibraryUri,
        actionMethodParameterProcessorName)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodParameterProcessor.asLibraryMemberPath} must extend $actionMethodParameterProcessorName');
    }
  }
}
