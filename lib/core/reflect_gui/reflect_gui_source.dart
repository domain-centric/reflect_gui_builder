import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor_source.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflection_factory.dart';

import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../property_factory/property_widget_factory_source.dart';
import '../service_class/service_class_source.dart';
import '../type/to_string.dart';

/// Contains information from an [ActionMethod]s source code.
/// It is created by the [ReflectGuiConfigSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ReflectGuiConfigReflection].
class ReflectGuiConfigSource {
  final List<ServiceClassSource> serviceClasses;
  final List<PropertyWidgetFactorySource> propertyWidgetFactories;
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessors;
  final List<ActionMethodResultProcessorSource> actionMethodResultProcessors;

  ReflectGuiConfigSource({
    required this.propertyWidgetFactories,
    required this.actionMethodParameterProcessors,
    required this.actionMethodResultProcessors,
    required this.serviceClasses,
  });

  @override
  String toString() {
    return ToStringBuilder('$ReflectGuiConfigSource')
        .add('propertyWidgetFactories', propertyWidgetFactories)
        .add('actionMethodParameterProcessors', actionMethodParameterProcessors)
        .add('actionMethodResultProcessors', actionMethodResultProcessors)
        .add('serviceClasses', serviceClasses)
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
    var propertyWidgetFactorySources = PropertyWidgetFactorySourceFactory()
        .createFrom(reflectGuiConfigClassElement);
    var actionMethodParameterProcessorSources =
        ActionMethodParameterProcessorSourceFactory()
            .createFrom(reflectGuiConfigClassElement);
    var actionMethodResultProcessorSources =
        ActionMethodResultProcessorSourceFactory()
            .createFrom(reflectGuiConfigClassElement);
    var reflectGuiConfigSource = ReflectGuiConfigSource(
        propertyWidgetFactories: propertyWidgetFactorySources,
        actionMethodParameterProcessors: actionMethodParameterProcessorSources,
        actionMethodResultProcessors: actionMethodResultProcessorSources,
        serviceClasses: []);

    ServiceClassSourceFactory(reflectGuiConfigSource)
        .populateWith(reflectGuiConfigClassElement);

    return reflectGuiConfigSource;
  }
}
