import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// See [SourceClass]
class ActionMethodResultProcessorSource extends ClassSource {
  /// Te type of the result (return) type of the actionMethod
  final ClassSource? resultType;

  ActionMethodResultProcessorSource(
      {required super.libraryUri, required String className, this.resultType})
      : super(className: className);

  /// returns true if the result type is supported
  /// by the [ActionMethodResultProcessorSource]
  bool supports(ClassSource? resultTypeToCompare) =>
      supported(resultType, resultTypeToCompare);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('resultType', resultType)
        .toString();
  }
}

/// Creates a list of [ActionMethodResultProcessorSource]s
/// from a [ReflectGuiConfig] class by using the analyzer package
///
/// See [SourceClassFactory]
class ActionMethodResultProcessorSourceFactory
    extends ReflectGuiConfigPopulateFactory {
  static const actionMethodResultProcessorFieldName =
      'actionMethodResultProcessors';
  static const actionMethodResultProcessorName = 'ActionMethodResultProcessor';
  static const actionMethodResultProcessorLibraryUri =
      'package:reflect_gui_builder/builder/domain/action_method_result_processor/action_method_result_processor.dart';

  final SourceContext context;
  ActionMethodResultProcessorSourceFactory(this.context);

  @override
  void populateApplicationPresentation() {
    var field = findField(context.applicationPresentationElement,
        actionMethodResultProcessorFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validate(field, element);

      var processor = ActionMethodResultProcessorSource(
          libraryUri: element.library.source.uri.toString(),
          className: element.name,
          resultType: _createResultType(element));

      context.application.actionMethodResultProcessors
          .add(processor);
    }

    if (context.application.actionMethodResultProcessors.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No ActionMethodResultProcessors found.');
    }
  }

  ClassSource? _createResultType(Element element) {
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
    var resultType = context.typeFactory.create(types.first as InterfaceType);
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
