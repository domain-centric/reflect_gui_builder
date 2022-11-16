import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor_reflection.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflection_factory.dart';

import '../property_factory/property_widget_factory_reflection.dart';
import '../service_class/service_class_reflection.dart';
import '../type/to_string.dart';

class ReflectGuiReflection {
  final List<ServiceClassReflection> serviceClassReflections;
  final List<PropertyWidgetFactoryReflection> propertyWidgetFactoryReflections;
  final List<ActionMethodParameterProcessorReflection>
      actionMethodParameterProcessorReflections;

  ReflectGuiReflection({
    required this.propertyWidgetFactoryReflections,
    required this.actionMethodParameterProcessorReflections,
    required this.serviceClassReflections,
  });

  @override
  String toString() {
    return ToStringBuilder('$ReflectGuiReflection')
        .add(
            'propertyWidgetFactoryReflections', propertyWidgetFactoryReflections)
        .add('actionMethodParameterProcessorReflections',
            actionMethodParameterProcessorReflections)
        .add('serviceClassReflections', serviceClassReflections)
        .toString();
  }
}

class ReflectGuiReflectionFactory extends ReflectionFactory {
  bool isValidReflectGuiConfigElement(Element element) =>
      element is ClassElement &&
      element.isPublic &&
      !element.isAbstract &&
      hasSuperClass(
          element,
          'package:reflect_gui_builder/core/reflect_gui/reflect_gui_config.dart',
          'ReflectGuiConfig') &&
      hasNamelessConstructorWithoutParameters(element);

  /// creates a [ReflectGuiReflection] using a [ClassElement]
  /// that passed [isReflectGuiConfigClass]
  ReflectGuiReflection createFrom(ClassElement reflectGuiConfigClassElement) {
    var serviceClassReflections = ServiceClassReflectionFactory()
        .createFrom(reflectGuiConfigClassElement);
    var propertyWidgetFactoryReflections =
        PropertyWidgetFactoryReflectionFactory()
            .createFrom(reflectGuiConfigClassElement);
    var actionMethodParameterProcessorReflections =
        ActionMethodParameterProcessorReflectionFactory()
            .createFrom(reflectGuiConfigClassElement);

    return ReflectGuiReflection(
        propertyWidgetFactoryReflections: propertyWidgetFactoryReflections,
        actionMethodParameterProcessorReflections:
            actionMethodParameterProcessorReflections,
        serviceClassReflections: serviceClassReflections);
  }
}
