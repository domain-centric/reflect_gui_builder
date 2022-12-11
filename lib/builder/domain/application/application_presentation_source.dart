import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/enum/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';

import '../action_method_parameter_processor/action_method_parameter_processor_source.dart';
import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../domain_class/domain_class_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../property_factory/property_widget_factory_source.dart';
import '../service_class/service_class_source.dart';

/// Contains information from an [ApplicationPresentation] class source code.
/// See [SourceClass]
class ApplicationPresentationSource {
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
    return ToStringBuilder('$ApplicationPresentationSource')
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
class ApplicationPresentationSourceFactory extends SourceFactory {
  bool isValidApplicationPresentationElement(Element element) =>
      element is ClassElement &&
      element.isPublic &&
      !element.isAbstract &&
      hasSuperClass(
          element,
          'package:reflect_gui_builder/builder/domain/application/application_presentation.dart',
          'ApplicationPresentation') &&
      hasNamelessConstructorWithoutParameters(element);

  /// creates a [ApplicationPresentationSource] using a [ClassElement]
  /// that passed [isValidApplicationPresentationElement]
  ApplicationPresentationSource create(ClassElement applicationPresentationElement) {
    var context = FactoryContext(applicationPresentationElement);
    PropertyWidgetFactorySourceFactory(context).populateApplicationPresentation();
    ActionMethodParameterProcessorSourceFactory(context)
        .populateApplicationPresentation();
    ActionMethodResultProcessorSourceFactory(context)
        .populateApplicationPresentation();
    ServiceClassSourceFactory(context).populateApplicationPresentation();
    return context.applicationPresentation;
  }
}

abstract class ReflectGuiConfigPopulateFactory extends SourceFactory {
  /// add objects that contain information on source code
  /// to the [applicationPresentation] tree
  void populateApplicationPresentation();
}

/// All information needed to create a [ApplicationPresentationSource]
class FactoryContext {
  final ClassElement applicationPresentationElement;
  final ApplicationPresentationSource applicationPresentation =
      ApplicationPresentationSource();
  late TypeSourceFactory typeFactory;
  late EnumSourceFactory enumSourceFactory;
  late DomainSourceFactory domainSourceFactory;
  late ActionMethodSourceFactory actionMethodSourceFactory;

  FactoryContext(this.applicationPresentationElement) {
    typeFactory = TypeSourceFactory(this);
    domainSourceFactory = DomainSourceFactory(this);
    enumSourceFactory = EnumSourceFactory(this);
    actionMethodSourceFactory = ActionMethodSourceFactory(this);
  }
}
