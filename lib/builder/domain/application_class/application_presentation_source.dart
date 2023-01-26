import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:fluent_regex/fluent_regex.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/enum_class/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/build_logger.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:yaml/yaml.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_parameter_processor/action_method_parameter_processor_source.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_result_processor/action_method_result_processor_source.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/value_widget_factory/value_widget_factory_source.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';

/// Contains information from an [ApplicationPresentation] class source code.
/// See [SourceClass]
class ApplicationPresentationSource extends ClassSource {
  final List<ServiceClassSource> serviceClasses = [];
  final List<ValueWidgetFactorySource> valueWidgetFactories = [];
  final List<ActionMethodParameterProcessorSource>
      actionMethodParameterProcessors = [];
  final List<ActionMethodResultProcessorSource> actionMethodResultProcessors =
      [];
  Translatable name;
  Translatable description;
  String? version;
  String? titleImagePath;
  Uri? homePage;
  Uri? documentation;

  ApplicationPresentationSource({
    required super.libraryUri,
    required super.className,
    required this.name,
    required this.description,
    this.version,
    this.titleImagePath,
    this.homePage,
    this.documentation,
  });

  /// Find's all [DomainClass]es in the [ServiceClass]es
  Set<DomainClassSource> get domainClasses =>
      usedTypes.whereType<DomainClassSource>().toSet();

  /// Find's all [Enum]s in the [ServiceClass]es
  Set<EnumSource> get enumClasses => usedTypes.whereType<EnumSource>().toSet();

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
        .add('version', version)
        .add('titleImagePath', titleImagePath)
        .add('homePage', homePage)
        .add('documentation', documentation)
        .add('valueWidgetFactories', valueWidgetFactories)
        .add('actionMethodParameterProcessors', actionMethodParameterProcessors)
        .add('actionMethodResultProcessors', actionMethodResultProcessors)
        .add('serviceClasses', serviceClasses)
        .add('domainClasses', domainClasses)
        .add('enums', enumClasses)
        .toString();
  }
}

/// See [SourceClassFactory]
class ApplicationPresentationSourceFactory extends SourceFactory {
  final pubSpecYaml = PubSpecYaml();
  final log = BuildLoggerFactory.create();

  bool isValidApplicationPresentationElement(Element element) =>
      element is ClassElement &&
      element.isPublic &&
      !element.isAbstract &&
      hasSuperClass(
          element,
          'package:reflect_gui_builder/builder/domain/application_class/application_presentation.dart',
          'ApplicationPresentation') &&
      hasNamelessConstructorWithoutParameters(element);

  /// creates a [ApplicationPresentationSource] using a [ClassElement]
  /// that passed [isValidApplicationPresentationElement]
  ApplicationPresentationSource create(
      Builder builder, ClassElement applicationPresentationElement) {
    var applicationPresentationSource =
        _createApplicationPresentationSource(applicationPresentationElement);

    var context = SourceContext(
        builder, applicationPresentationElement, applicationPresentationSource);
    ValueWidgetFactorySourceFactory(context).populateApplicationPresentation();
    ActionMethodParameterProcessorSourceFactory(context)
        .populateApplicationPresentation();
    ActionMethodResultProcessorSourceFactory(context)
        .populateApplicationPresentation();
    ServiceClassSourceFactory(context).populateApplicationPresentation();
    return context.application;
  }

  ApplicationPresentationSource _createApplicationPresentationSource(
      ClassElement applicationPresentationElement) {
    return ApplicationPresentationSource(
      libraryUri: _createLibraryUri(applicationPresentationElement),
      className: _createClassName(applicationPresentationElement),
      name: _createName(applicationPresentationElement),
      description: _createDescription(applicationPresentationElement),
      version: _createVersion(),
      titleImagePath: _createTitleImagePath(applicationPresentationElement),
      documentation: _createDocumentationUri(),
      homePage: _createHomePageUri(),
    );
  }

  String _createLibraryUri(ClassElement applicationPresentationElement) =>
      applicationPresentationElement.library.source.uri.toString();

  String _createClassName(ClassElement applicationPresentationElement) =>
      applicationPresentationElement.name;

  Translatable _createName(ClassElement applicationPresentationElement) =>
      Translatable(
          key: _createNameKey(applicationPresentationElement),
          englishText: _createNameText(applicationPresentationElement));

  String _createNameKey(ClassElement applicationPresentationElement) =>
      '${applicationPresentationElement.asLibraryMemberPath}.name';

  static final _presentationSuffix =
      FluentRegex().literal('presentation').endOfLine().ignoreCase();

  String _createNameText(ClassElement applicationPresentationElement) =>
      _presentationSuffix
          .removeAll(applicationPresentationElement.name)
          .titleCase;

  Translatable _createDescription(
          ClassElement applicationPresentationElement) =>
      Translatable(
          key: _createDescriptionKey(applicationPresentationElement),
          englishText: _createDescriptionText(applicationPresentationElement));

  String _createDescriptionKey(ClassElement applicationPresentationElement) =>
      '${applicationPresentationElement.asLibraryMemberPath}.description';

  String _createDescriptionText(ClassElement applicationPresentationElement) {
    var description = pubSpecYaml.yaml['description'];
    if (_nullOrEmpty(description)) {
      return _createNameText(applicationPresentationElement);
    } else {
      return description;
    }
  }

  bool _nullOrEmpty(String? string) => string == null || string.trim().isEmpty;

  Uri? _createDocumentationUri() {
    var documentationUri = pubSpecYaml.yaml['documentation'];
    if (_nullOrEmpty(documentationUri)) {
      return null;
    } else {
      try {
        return Uri.parse(documentationUri);
      } catch (e) {
        return null;
      }
    }
  }

  Uri? _createHomePageUri() {
    var homePageUri = pubSpecYaml.yaml['homepage'];
    if (_nullOrEmpty(homePageUri)) {
      return null;
    } else {
      try {
        return Uri.parse(homePageUri);
      } catch (e) {
        return null;
      }
    }
  }

  String? _createVersion() => pubSpecYaml.yaml['version'];

  String? _createTitleImagePath(ClassElement applicationPresentationElement) {
    String className = _createNameText(applicationPresentationElement);
    String fileName = ReCase(className).snakeCase;
    String? foundAssetPath = _findAssetPath(fileName);
    if (foundAssetPath == null) {
      log.warning(
          'No title image found. Please define a $fileName asset in pubspec.yaml.');
    }
    return foundAssetPath;
  }

  String? _findAssetPath(String fileName) {
    var assets = pubSpecYaml.assets;
    RegExp imageAsset = RegExp('$fileName.(jpeg|webp|gif|png|bmp|wbmp)\$',
        caseSensitive: false);
    String? found =
        assets.firstWhereOrNull((asset) => imageAsset.hasMatch(asset));
    return found;
  }
}

abstract class ReflectGuiConfigPopulateFactory extends SourceFactory {
  /// add objects that contain information on source code
  /// to the [application] tree
  void populateApplicationPresentation();
}

/// All information needed to create a [ApplicationPresentationSource]
class SourceContext {
  final ClassElement applicationPresentationElement;
  late ApplicationPresentationSource application;
  late TypeSourceFactory typeFactory;
  late EnumSourceFactory enumSourceFactory;
  late DomainSourceFactory domainSourceFactory;
  late ActionMethodSourceFactory actionMethodSourceFactory;

  SourceContext(
    Builder builder,
    this.applicationPresentationElement,
    this.application,
  ) {
    typeFactory = TypeSourceFactory(this);
    domainSourceFactory = DomainSourceFactory(this);
    enumSourceFactory = EnumSourceFactory(this);
    actionMethodSourceFactory = ActionMethodSourceFactory(this);
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
