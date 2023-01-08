import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

import '../action_method_parameter_processor/action_method_parameter_processor_source.dart';
import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// See [SourceClass]
class ActionMethodSource extends LibraryMemberSource {
  final Translatable name;
  final Translatable description;
  final String className;
  final String methodName;
  final ClassSource? parameterType;
  final ActionMethodParameterProcessorSource parameterProcessor;
  final ClassSource? resultType;
  final ActionMethodResultProcessorSource resultProcessor;

  ActionMethodSource(
      {required super.libraryUri,
      required this.className,
      required this.methodName,
      required this.name,
      required this.description,
      this.parameterType,
      required this.parameterProcessor,
      this.resultType,
      required this.resultProcessor})
      : super(libraryMemberPath: '$className.$methodName');

  /// Finds all the [ClassSource]s that are used in this [ActionMethod].
  /// It will also get [ClassSource]s used inside the
  /// DomainClass [ActionMethod]s and the [ActionMethod]s inside its [Property]s
  ///
  /// TODO: Be aware for never ending round trips.
  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    if (parameterType != null) {
      usedTypes.addAll(parameterType!.usedTypes);
    }
    if (resultType != null) {
      usedTypes.addAll(resultType!.usedTypes);
    }
    return usedTypes;
  }

  @override
  String toString() {
    return ToStringBuilder('$ActionMethodSource')
        .add('libraryMemberUri', libraryMemberUri)
        .add('parameterType', parameterType)
        .add('parameterProcessor', parameterProcessor)
        .add('resultType', resultType)
        .add('resultProcessor', resultProcessor)
        .toString();
  }
}

/// Creates a [ActionMethodSource]s by using the
/// analyzer package
class ActionMethodSourceFactory extends SourceFactory {
  final SourceContext context;

  ActionMethodSourceFactory(this.context);

  List<ActionMethodSource> createAll(InterfaceElement element) {
    var actionMethods = <ActionMethodSource>[];
    for (var methodElement in element.methods) {
      var actionMethod = _create(methodElement);
      if (actionMethod != null) {
        actionMethods.add(actionMethod);
      }
    }
    return actionMethods;
  }

  ActionMethodSource? _create(MethodElement methodElement) {
    if (methodElement.isPrivate) {
      return null;
    }
    if (methodElement.parameters.length > 1) {
      return null;
    }

    var parameterType = _createParameterType(methodElement);
    var parameterProcessor = _findParameterProcessorFor(parameterType);
    if (parameterProcessor == null) {
      return null;
    }

    var resultType = _createResultType(methodElement);
    var resultProcessorSource = _findResultProcessorFor(resultType);
    if (resultProcessorSource == null) {
      return null;
    }

    return ActionMethodSource(
        libraryUri: methodElement.library.source.uri,
        className: methodElement.enclosingElement.name!,
        methodName: methodElement.name,
        name: _createName(methodElement),
        description: _createDescription(methodElement),
        parameterType: parameterType,
        parameterProcessor: parameterProcessor,
        resultType: _createResultType(methodElement),
        resultProcessor: resultProcessorSource);
  }

  ActionMethodParameterProcessorSource? _findParameterProcessorFor(
          ClassSource? parameterType) =>
      context.applicationPresentation.actionMethodParameterProcessors
          .firstWhereOrNull((processor) => processor.supports(parameterType));

  ActionMethodResultProcessorSource? _findResultProcessorFor(
          ClassSource? resultType) =>
      context.applicationPresentation.actionMethodResultProcessors
          .firstWhereOrNull((processor) => processor.supports(resultType));

  ClassSource? _createParameterType(MethodElement methodElement) {
    if (methodElement.parameters.length == 1) {
      var parameterType = methodElement.parameters.first.type as InterfaceType;
      return context.typeFactory.create(parameterType);
    } else {
      return null;
    }
  }

  ClassSource? _createResultType(MethodElement methodElement) =>
      context.typeFactory.create(methodElement.returnType as InterfaceType);

  Translatable _createName(MethodElement methodElement) => Translatable(
      key: _createNameKey(methodElement),
      englishText: _createNameText(methodElement));

  String _createNameKey(MethodElement methodElement) =>
      '${methodElement.asLibraryMemberPath}.name';

  String _createNameText(MethodElement methodElement) =>
      methodElement.name.sentenceCase;

  Translatable _createDescription(MethodElement methodElement) => Translatable(
      key: _createDescriptionKey(methodElement),
      englishText: _createDescriptionText(methodElement));

  String _createDescriptionKey(MethodElement methodElement) =>
      '${methodElement.asLibraryMemberPath}.description';

  String _createDescriptionText(MethodElement methodElement) =>
      _createNameText(methodElement);
}
