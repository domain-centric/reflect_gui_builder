import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:reflect_gui_builder/core/action_method_result_processor/action_method_result_processor_source.dart';
import 'package:reflect_gui_builder/core/domain_class/domain_class_source.dart';
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
  final ClassSource? parameterType;
  final ActionMethodParameterProcessorSource parameterProcessor;
  final ClassSource? resultType;
  final ActionMethodResultProcessorSource resultProcessor;

  ActionMethodSource(
      {required Uri libraryUri,
      required this.className,
      required this.methodName,
      this.parameterType,
      required this.parameterProcessor,
      this.resultType,
      required this.resultProcessor})
      : super(
            libraryUri: libraryUri,
            libraryMemberPath: '$className.$methodName');

  /// Finds all the [DomainClass]es that are used in this [ActionMethod].
  /// It will also get [DomainClass]es used inside the
  /// DomainClass [ActionMethod]s and the [ActionMethod]s inside its [Property]s
  ///
  /// TODO: Be aware for never ending round trips.
  Set<DomainClassSource> get domainClasses  {
    var domainClasses=<DomainClassSource>{};
    if (parameterType!=null) {
      domainClasses.addAll(parameterType!.domainClasses);
    }
    if (resultType!=null) {
      domainClasses.addAll(resultType!.domainClasses);
    }
    return domainClasses;
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

    var parameterType = _createParameterType(methodElement);
    var parameterProcessor = _findParameterProcessorFor(parameterType);
    if (parameterProcessor == null) {
      return null;
    }

    ClassSource? resultType = _createParameterType(methodElement);
    var resultProcessorSource = _findResultProcessorFor(resultType);
    if (resultProcessorSource == null) {
      return null;
    }

    return ActionMethodSource(
        libraryUri: methodElement.library.source.uri,
        className: methodElement.enclosingElement.name!,
        methodName: methodElement.name,
        parameterType: parameterType,
        parameterProcessor: parameterProcessor,
        resultType: _createResultType(methodElement),
        resultProcessor: resultProcessorSource);
  }

  ActionMethodParameterProcessorSource? _findParameterProcessorFor(
          ClassSource? parameterType) =>
      reflectGuiConfigSource.actionMethodParameterProcessors
          .firstWhereOrNull((processor) => processor.supports(parameterType));

  ActionMethodResultProcessorSource? _findResultProcessorFor(
          ClassSource? resultType) =>
      reflectGuiConfigSource.actionMethodResultProcessors
          .firstWhereOrNull((processor) => processor.supports(resultType));

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
}
