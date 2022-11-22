import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';

/// Contains information on a [ActionMethodResultProcessor]s source code.
/// It is created by the [ActionMethodResultProcessorSourceFactory]
class ActionMethodResultProcessorSource extends ClassSource {
  /// Te type of the result (return) type of the actionMethod
  final ClassSource? resultType;

  ActionMethodResultProcessorSource(
      {required ClassSource actionMethodResultProcessorType, this.resultType})
      : super(
            libraryUri: actionMethodResultProcessorType.libraryUri,
      libraryMemberPath: actionMethodResultProcessorType.libraryMemberPath);

  /// returns true if the result type is supported by the [ActionMethodResultProcessorSource]
  bool supports(ClassSource? resultType) => true; //TODO

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('resultType', resultType)
        .toString();
  }

}

/// Creates a list of [ActionMethodResultProcessorSource]s by using the
/// analyzer package
class ActionMethodResultProcessorSourceFactory extends SourceFactory {
  static const actionMethodResultProcessorFieldName =
      'actionMethodResultProcessors';
  static const actionMethodResultProcessorName = 'ActionMethodResultProcessor';
  static const actionMethodResultProcessorLibraryUri =
      'package:reflect_gui_builder/core/action_method_result_processor/action_method_result_processor.dart';

  List<ActionMethodResultProcessorSource> createAll(
      ClassElement reflectGuiConfigElement) {
    var field = findField(
        reflectGuiConfigElement, actionMethodResultProcessorFieldName);

    var elements = findInitializerElements(field);
    List<ActionMethodResultProcessorSource> sources = [];
    for (var element in elements) {
      _validate(field, element);

      var source = ActionMethodResultProcessorSource(
          actionMethodResultProcessorType:
              ClassSource.fromInterfaceElement(element as ClassElement),
          resultType: _createResultType(element, field));

      sources.add(source);
    }

    if (sources.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No ActionMethodResultProcessors found.');
    }

    return sources;
  }

  ClassSource? _createResultType(Element element, FieldElement field) {
    var superClass = findSuperClass(element as InterfaceElement,
        actionMethodResultProcessorLibraryUri, actionMethodResultProcessorName);
    var types = superClass!.typeArguments;
    if (types.isEmpty) {
      return null;
    }
    var genericElement = types.first.element;
    if (genericElement == null) {
      return null;
    }
    var resultType = ClassSource.fromInterfaceElement(genericElement as InterfaceElement);
    return resultType;
  }

  void _validate(FieldElement field, Element actionMethodResultProcessor) {
    if (actionMethodResultProcessor is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} must be a class.');
    }
    if (!actionMethodResultProcessor.isPublic) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} must be public.');
    }
    if (actionMethodResultProcessor.isAbstract) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(actionMethodResultProcessor)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(
        actionMethodResultProcessor)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} must be immutable and therefore must have a constant constructor.');
    }

    if (!hasSuperClass(
        actionMethodResultProcessor,
        actionMethodResultProcessorLibraryUri,
        actionMethodResultProcessorName)) {
      throw ('${field.asLibraryMemberPath}: ${actionMethodResultProcessor.asLibraryMemberPath} must extend $actionMethodResultProcessorName');
    }
  }
}
