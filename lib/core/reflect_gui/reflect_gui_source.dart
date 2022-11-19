import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor_reflection.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflection_factory.dart';

import '../action_method_result_processor/action_method_result_processor_reflection.dart';
import '../property_factory/property_widget_factory_reflection.dart';
import '../service_class/service_class_source.dart';
import '../type/to_string.dart';

/// Contains information from an [ActionMethod]s source code.
/// It is created by the [ReflectGuiConfigSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ReflectGuiConfigReflection].
class ReflectGuiConfigSource {
  final List<ServiceClassSource> serviceClassSources;
  final List<PropertyWidgetFactorySource> propertyWidgetFactorySources;
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessorSources;
  final List<ActionMethodResultProcessorSource>
      actionMethodResultProcessorSources;

  ReflectGuiConfigSource({
    required this.propertyWidgetFactorySources,
    required this.actionMethodParameterProcessorSources,
    required this.actionMethodResultProcessorSources,
    required this.serviceClassSources,
  });

  @override
  String toString() {
    return ToStringBuilder('$ReflectGuiConfigSource')
        .add('propertyWidgetFactorySources', propertyWidgetFactorySources)
        .add('actionMethodParameterProcessorSources',
            actionMethodParameterProcessorSources)
        .add('actionMethodResultProcessorSources',
            actionMethodResultProcessorSources)
        .add('serviceClassSources', serviceClassSources)
        .toString();
  }
}

class ReflectGuiConfigSourceFactory extends SourceFactory {
  bool isValidReflectGuiConfigElement(Element element) =>
      element is ClassElement &&
      element.isPublic &&
      !element.isAbstract &&
      hasSuperClass(
          element,
          'package:reflect_gui_builder/core/reflect_gui/reflect_gui_config.dart',
          'ReflectGuiConfig') &&
      hasNamelessConstructorWithoutParameters(element);

  /// creates a [ReflectGuiConfigSource] using a [ClassElement]
  /// that passed [isReflectGuiConfigClass]
  ReflectGuiConfigSource createFrom(ClassElement reflectGuiConfigClassElement) {
    var serviceClassReflections =
        ServiceClassSourceFactory().createFrom(reflectGuiConfigClassElement);
    var propertyWidgetFactorySources = PropertyWidgetFactorySourceFactory()
        .createFrom(reflectGuiConfigClassElement);
    var actionMethodParameterProcessorSources =
        ActionMethodParameterProcessorSourceFactory()
            .createFrom(reflectGuiConfigClassElement);
    var actionMethodResultProcessorSources =
        ActionMethodResultProcessorSourceFactory()
            .createFrom(reflectGuiConfigClassElement);
    return ReflectGuiConfigSource(
        propertyWidgetFactorySources: propertyWidgetFactorySources,
        actionMethodParameterProcessorSources:
            actionMethodParameterProcessorSources,
        actionMethodResultProcessorSources: actionMethodResultProcessorSources,
        serviceClassSources: serviceClassReflections);
  }
}
