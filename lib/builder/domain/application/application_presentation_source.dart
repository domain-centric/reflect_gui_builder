import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:fluent_regex/fluent_regex.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/application/generated_application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/enum/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:yaml/yaml.dart';

import '../action_method_parameter_processor/action_method_parameter_processor_source.dart';
import '../action_method_result_processor/action_method_result_processor_source.dart';
import '../domain_class/domain_class_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../property_factory/property_widget_factory_source.dart';
import '../service_class/service_class_source.dart';

/// Contains information from an [ApplicationPresentation] class source code.
/// See [SourceClass]
class ApplicationPresentationSource extends ClassSource
    implements GeneratedApplicationPresentation {
  final List<ServiceClassSource> serviceClasses = [];
  final List<PropertyWidgetFactorySource> propertyWidgetFactories = [];
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessors = [];
  final List<ActionMethodResultProcessorSource> actionMethodResultProcessors =
      [];
  @override
  Translatable name;
  @override
  Translatable description;
  @override
  Uri? documentation;
  @override
  Uri? homePage;
  @override
  Uri? titleImage;
  @override
  String? version;

  ApplicationPresentationSource({
    required super.libraryUri,
    required super.className,
    required this.name,
    required this.description,
    this.documentation,
    this.homePage,
    this.titleImage,
    this.version,
  });

  /// Find's all [DomainClass]es in the [ServiceClass]es
  Set<DomainClassSource> get domainClasses =>
      usedTypes.whereType<DomainClassSource>().toSet();

  /// Find's all [Enum]s in the [ServiceClass]es
  Set<EnumSource> get enums => usedTypes.whereType<EnumSource>().toSet();

  @override
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
        .add('libraryMemberUri', libraryMemberUri)
        .add('name', name)
        .add('description', description)
        .add('documentation', documentation)
        .add('homePage', homePage)
        .add('titleImage', titleImage)
        .add('version', version)
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
  ApplicationPresentationSource create(
      ClassElement applicationPresentationElement) {
    var context = FactoryContext(applicationPresentationElement);
    PropertyWidgetFactorySourceFactory(context)
        .populateApplicationPresentation();
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
  late ApplicationPresentationSource applicationPresentation;
  late TypeSourceFactory typeFactory;
  late EnumSourceFactory enumSourceFactory;
  late DomainSourceFactory domainSourceFactory;
  late ActionMethodSourceFactory actionMethodSourceFactory;
  final pubSpecYaml = PubSpecYaml();

  FactoryContext(this.applicationPresentationElement) {
    var libraryUri = applicationPresentationElement.library.source.uri;
    var className = applicationPresentationElement.name;
    applicationPresentation = ApplicationPresentationSource(
        libraryUri: libraryUri,
        className: className,
        name: _createName(),
        description: _createDescription());
    typeFactory = TypeSourceFactory(this);
    domainSourceFactory = DomainSourceFactory(this);
    enumSourceFactory = EnumSourceFactory(this);
    actionMethodSourceFactory = ActionMethodSourceFactory(this);
  }
  static final presentationSuffix =
      FluentRegex().literal('presentation').endOfLine().ignoreCase();

  Translatable _createName() =>
      Translatable(key: _createNameKey, englishText: _createNameText());

  String get _createNameKey =>
      '${applicationPresentationElement.asLibraryMemberPath}.name';

  String _createNameText() =>
      presentationSuffix.removeAll(applicationPresentationElement.name).sentenceCase;

  Translatable _createDescription() => Translatable(
      key: _createDescriptionKey, englishText: _createDescriptionText());

  String get _createDescriptionKey =>
      '${applicationPresentationElement.asLibraryMemberPath}.description';

  String _createDescriptionText() {
    var description = pubSpecYaml.yaml['description'];
    if (description == null || description.toString().trim().isEmpty) {
      return _createNameText();
    } else {
      return description;
    }
  }
}

class PubSpecYaml {
  final Map yaml;

  PubSpecYaml() : yaml = _read();

  List<String> get authors {
    YamlList? authors = yaml['authors'];
    if (authors == null) {
      return const [];
    }
    return authors.map((asset) => asset.toString()).toList();
  }

  List<String> get assets {
    var flutter = yaml['flutter'];
    if (flutter == null) {
      return const [];
    }
    YamlList? assets = flutter['assets'];
    if (assets == null) {
      return const [];
    }
    return assets.map((asset) => asset.toString()).toList();
  }

  static Map _read() {
    File yamlFile = File("pubspec.yaml");
    String yamlString = yamlFile.readAsStringSync();
    Map? yaml = loadYaml(yamlString);
    return yaml ?? {};
  }
}
