import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method_parameter_processor/action_method_parameter_processor_source.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflection_factory.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../domain_class/domain_class_source.dart';
import '../property_factory/property_widget_factory_source.dart';
import '../service_class/service_class_source.dart';
import '../type/to_string.dart';

/// Contains information from an [ActionMethod]s source code.
/// It is created by the [ReflectGuiConfigSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ReflectGuiConfigReflection].
class ReflectGuiConfigSource {
  final List<ServiceClassSource> serviceClasses=[];
  final List<PropertyWidgetFactorySource> propertyWidgetFactories=[];
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessors=[];
  final List<ActionMethodResultProcessorSource> actionMethodResultProcessors=[];


  /// Find's all [DomainClass]es in the [ServiceClass]es
  Set<DomainClassSource> get domainClasses {
    var domainClasses=<DomainClassSource>{};
    for (var serviceClass in serviceClasses) {
      domainClasses.addAll(serviceClass.domainClasses);
    }
    return domainClasses;
  }

  @override
  String toString() {
    return ToStringBuilder('$ReflectGuiConfigSource')
        .add('propertyWidgetFactories', propertyWidgetFactories)
        .add('actionMethodParameterProcessors', actionMethodParameterProcessors)
        .add('actionMethodResultProcessors', actionMethodResultProcessors)
        .add('serviceClasses', serviceClasses)
        .add('domainClasses', domainClasses)
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
  ReflectGuiConfigSource create(ClassElement reflectGuiConfigClassElement) {
    var context = PopulateFactoryContext(reflectGuiConfigClassElement);
    PropertyWidgetFactorySourceFactory(context).populateReflectGuiConfig();
   ActionMethodParameterProcessorSourceFactory(context).populateReflectGuiConfig();
   ActionMethodResultProcessorSourceFactory(context).populateReflectGuiConfig();
   ServiceClassSourceFactory(context).populateReflectGuiConfig();
    return context.reflectGuiConfigSource;
  }
}


abstract class ReflectGuiConfigPopulateFactory extends SourceFactory {
  final ClassElement reflectGuiConfigElement;
  final ReflectGuiConfigSource reflectGuiConfigSource;
  final TypeSourceFactory typeFactory;

  ReflectGuiConfigPopulateFactory(PopulateFactoryContext context)
      : reflectGuiConfigElement = context.reflectGuiConfigElement,
        reflectGuiConfigSource = context.reflectGuiConfigSource,
        typeFactory = context.typeFactory;

  /// add objects that contain information on source code
  /// to the [reflectGuiConfigSource] tree
  void populateReflectGuiConfig();
}

/// All information needed to create a [ReflectGuiConfigSource]
class PopulateFactoryContext {
  final ClassElement reflectGuiConfigElement;
  final ReflectGuiConfigSource reflectGuiConfigSource = ReflectGuiConfigSource();
  late TypeSourceFactory typeFactory;

  PopulateFactoryContext(this.reflectGuiConfigElement) {
    typeFactory = TypeSourceFactory(reflectGuiConfigSource);
  }
}