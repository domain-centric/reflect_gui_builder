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
  final ActionMethodParameterProcessorSource
      actionMethodParameterProcessorSource;
  final ActionMethodResultProcessorSource actionMethodResultProcessorSource;

  ActionMethodSource(
      {required Uri libraryUri,
      required this.className,
      required this.methodName,
      required this.actionMethodParameterProcessorSource,
      required this.actionMethodResultProcessorSource})
      : super(libraryUri: libraryUri, name: '$className.$methodName');

  @override
  String toString() {
    return ToStringBuilder('$ActionMethodSource')
        .add('libraryMemberUri', libraryMemberUri)
        .add('actionMethodParameterProcessorSource', actionMethodParameterProcessorSource)
        .add('actionMethodResultProcessorSource', actionMethodResultProcessorSource)
        .toString();
  }
}

/// Creates a [ActionMethodSource]s by using the
/// analyzer package
class ActionMethodSourceFactory extends SourceFactory {
  final ReflectGuiConfigSource reflectGuiConfigSource;

  ActionMethodSourceFactory(this.reflectGuiConfigSource);

  bool isActionMethod(MethodElement methodElement) => true;

  ActionMethodSource create(MethodElement methodElement) => ActionMethodSource(
      libraryUri: methodElement.library.source.uri,
      className: methodElement.enclosingElement.name!,
      methodName: methodElement.name,
      actionMethodParameterProcessorSource:
          reflectGuiConfigSource.actionMethodParameterProcessorSources.first,
      //TODO
      actionMethodResultProcessorSource:
          reflectGuiConfigSource.actionMethodResultProcessorSources.first //TODO
      );
}
