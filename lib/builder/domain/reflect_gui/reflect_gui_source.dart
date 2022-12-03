import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/enum/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/reflect_gui/reflect_gui_config.dart';
import 'package:reflect_gui_builder/builder/domain/reflect_gui/source_factory.dart';

import '../action_method_parameter_processor/action_method_parameter_processor_source.dart';
import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../domain_class/domain_class_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../property_factory/property_widget_factory_source.dart';
import '../service_class/service_class_source.dart';

/// Contains information from an [ReflectGuiConfig] class source code.
/// See [SourceClass]
class ReflectGuiConfigSource {
  final List<ServiceClassSource> serviceClasses = [];
  final List<PropertyWidgetFactorySource> propertyWidgetFactories = [];
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessors = [];
  final List<ActionMethodResultProcessorSource> actionMethodResultProcessors =
      [];

  /// Find's all [DomainClass]es in the [ServiceClass]es
  Set<DomainClassSource> get domainClasses =>
      usedTypes.whereType<DomainClassSource>().toSet();

  Set<EnumSource> get enums => usedTypes.whereType<EnumSource>().toSet();

  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    for (var serviceClass in serviceClasses) {
      usedTypes.addAll(serviceClass.usedTypes);
    }
    return usedTypes;
  }

  @override
  String toString() {
    return ToStringBuilder('$ReflectGuiConfigSource')
        .add('propertyWidgetFactories', propertyWidgetFactories)
        .add('actionMethodParameterProcessors', actionMethodParameterProcessors)
        .add('actionMethodResultProcessors', actionMethodResultProcessors)
        .add('serviceClasses', serviceClasses)
        .add('domainClasses', domainClasses)
        .add('enums', enums)
        .toString();
  }
}

/// See [SourceClassFactory]
class ReflectGuiConfigSourceFactory extends SourceFactory {
  bool isValidReflectGuiConfigElement(Element element) =>
      element is ClassElement &&
      element.isPublic &&
      !element.isAbstract &&
      hasSuperClass(
          element,
          'package:reflect_gui_builder/builder/domain/reflect_gui/reflect_gui_config.dart',
          'ReflectGuiConfig') &&
      hasNamelessConstructorWithoutParameters(element);

  /// creates a [ReflectGuiConfigSource] using a [ClassElement]
  /// that passed [isReflectGuiConfigClass]
  ReflectGuiConfigSource create(ClassElement reflectGuiConfigClassElement) {
    var context = FactoryContext(reflectGuiConfigClassElement);
    PropertyWidgetFactorySourceFactory(context).populateReflectGuiConfig();
    ActionMethodParameterProcessorSourceFactory(context)
        .populateReflectGuiConfig();
    ActionMethodResultProcessorSourceFactory(context)
        .populateReflectGuiConfig();
    ServiceClassSourceFactory(context).populateReflectGuiConfig();
    return context.reflectGuiConfigSource;
  }
}

abstract class ReflectGuiConfigPopulateFactory extends SourceFactory {
  /// add objects that contain information on source code
  /// to the [reflectGuiConfigSource] tree
  void populateReflectGuiConfig();
}

/// All information needed to create a [ReflectGuiConfigSource]
class FactoryContext {
  final ClassElement reflectGuiConfigElement;
  final ReflectGuiConfigSource reflectGuiConfigSource =
      ReflectGuiConfigSource();
  late TypeSourceFactory typeFactory;
  late EnumSourceFactory enumSourceFactory;
  late DomainSourceFactory domainSourceFactory;
  late ActionMethodSourceFactory actionMethodSourceFactory;

  FactoryContext(this.reflectGuiConfigElement) {
    typeFactory = TypeSourceFactory(this);
    domainSourceFactory = DomainSourceFactory(this);
    enumSourceFactory = EnumSourceFactory(this);
    actionMethodSourceFactory = ActionMethodSourceFactory(this);
  }
}
