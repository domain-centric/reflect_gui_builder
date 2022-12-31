import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// See [SourceClass]
class ActionMethodParameterProcessorSource extends ClassSource {
  /// null = [ActionMethod] has no parameter
  final ClassSource? parameterType;

  ActionMethodParameterProcessorSource(
      {required Uri libraryUri, required String className, this.parameterType})
      : super(libraryUri: libraryUri, className: className);

  /// returns true if the parameter type is supported
  /// by the [ActionMethodParameterProcessorSource]
  supports(ClassSource? parameterTypeToCompare) =>
      supported(parameterType, parameterTypeToCompare);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('parameterType', parameterType)
        .toString();
  }
}

/// Creates a list of [ActionMethodParameterProcessorSource]s
/// from a [ReflectGuiConfig] class by using the analyzer package
///
/// See [SourceClassFactory]
class ActionMethodParameterProcessorSourceFactory
    extends ReflectGuiConfigPopulateFactory {
  static const actionMethodParameterProcessorFieldName =
      'actionMethodParameterProcessors';
  static const actionMethodParameterProcessorName =
      'ActionMethodParameterProcessor';
  static const actionMethodParameterProcessorLibraryUri =
      'package:reflect_gui_builder/builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';

  final SourceContext context;

  ActionMethodParameterProcessorSourceFactory(this.context);

  @override
  void populateApplicationPresentation() {
    var field = findField(context.applicationPresentationElement,
        actionMethodParameterProcessorFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validate(field, element);

      var processor = ActionMethodParameterProcessorSource(
          libraryUri: element.library.source.uri,
          className: element.name,
          parameterType: _createParameterType(element, field));

      context.applicationPresentation.actionMethodParameterProcessors
          .add(processor);
    }

    if (context
        .applicationPresentation.actionMethodParameterProcessors.isEmpty) {
      throw Exception(
          '${field.asLibraryMemberPath}: No ActionMethodResultProcessors found.');
    }
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
    var parameterType = ClassSource(
        libraryUri: genericElement.library!.source.uri,
        className: genericElement.name!);
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
