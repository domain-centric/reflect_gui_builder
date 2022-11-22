import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method_result_processor/action_method_result_processor_source.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflect_gui_source.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflection_factory.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../action_method_parameter_processor/action_method_parameter_processor_source.dart';
import '../type/to_string.dart';

/// Contains information from an [ActionMethod]s source code.
/// It is created by the [ActionMethodSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ActionMethodReflection].
class ActionMethodSource extends LibraryMemberSource {
  final String className;
  final String methodName;
  final ActionMethodParameterProcessorSource parameterProcessorSource;
  final ActionMethodResultProcessorSource resultProcessorSource;

  ActionMethodSource(
      {required Uri libraryUri,
      required this.className,
      required this.methodName,
      required this.parameterProcessorSource,
      required this.resultProcessorSource})
      : super(
            libraryUri: libraryUri,
            libraryMemberPath: '$className.$methodName');

  @override
  String toString() {
    return ToStringBuilder('$ActionMethodSource')
        .add('libraryMemberUri', libraryMemberUri)
        .add('actionMethodParameterProcessorSource', parameterProcessorSource)
        .add('actionMethodResultProcessorSource', resultProcessorSource)
        .toString();
  }
}

/// Creates a [ActionMethodSource]s by using the
/// analyzer package
class ActionMethodSourceFactory extends SourceFactory {
  final ReflectGuiConfigSource reflectGuiConfigSource;

  ActionMethodSourceFactory(this.reflectGuiConfigSource);

  List<ActionMethodSource> createAll(List<MethodElement> methodElements) {
    var sources = <ActionMethodSource>[];
    for (var methodElement in methodElements) {
      var source = _create(methodElement);
      if (source != null) {
        sources.add(source);
      }
    }
    return sources;
  }

  ActionMethodSource? _create(MethodElement methodElement) {
    if (methodElement.isPrivate) {
      return null;
    }
    if (methodElement.parameters.length > 1) {
      return null;
    }

    var parameterProcessorSource = _findParameterProcessor(methodElement);
    if (parameterProcessorSource == null) {
      return null;
    }

    var resultProcessorSource = _findResultProcessor(methodElement);
    if (resultProcessorSource == null) {
      return null;
    }

    return ActionMethodSource(
        libraryUri: methodElement.library.source.uri,
        className: methodElement.enclosingElement.name!,
        methodName: methodElement.name,
        parameterProcessorSource: parameterProcessorSource,
        resultProcessorSource: resultProcessorSource);
  }

  ActionMethodParameterProcessorSource? _findParameterProcessor(
      MethodElement methodElement) {
    ClassSource? parameterType = _createParameterType(methodElement);
    for (var parameterProcessor
        in reflectGuiConfigSource.actionMethodParameterProcessorSources) {
      if (_parameterProcessorSupports(parameterProcessor, parameterType)) {
        return parameterProcessor;
      }
    }
    return null;
  }

  ActionMethodResultProcessorSource? _findResultProcessor(
      MethodElement methodElement) {
    ClassSource? resultType = _createResultType(methodElement);
    for (var resultProcessor
        in reflectGuiConfigSource.actionMethodResultProcessorSources) {
      if (_resultProcessorSupports(resultProcessor, resultType)) {
        return resultProcessor;
      }
    }
    return null;
  }

  ClassSource? _createParameterType(MethodElement methodElement) {
    if (methodElement.parameters.length == 1) {
      return ClassSource.fromInterfaceElement(
          methodElement.parameters.first as InterfaceElement);
    } else {
      return null;
    }
  }

  ClassSource? _createResultType(MethodElement methodElement) =>
      ClassSource.fromInterfaceElement(
          methodElement.returnType.element as InterfaceElement);

  bool _parameterProcessorSupports(
          ActionMethodParameterProcessorSource parameterProcessor,
          ClassSource? parameterType) =>
      true; //TODO

  bool _resultProcessorSupports(
          ActionMethodResultProcessorSource resultProcessor,
          ClassSource? resultType) =>
      true; //TODO
}
