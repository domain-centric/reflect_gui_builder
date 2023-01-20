import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';

/// Contains information on a [DomainClass] source code.
/// See [SourceClass]
class DomainClassSource extends ClassSource {
  final Translatable name;
  final Translatable description;
  final List<PropertySource> properties;

  DomainClassSource({
    required super.libraryUri,
    required super.className,
    required this.name,
    required this.description,
    required this.properties,
  });

  @override
  String toString() => ToStringBuilder(runtimeType.toString())
      .add('libraryMemberUri', libraryMemberUri)
      .add('genericTypes', genericTypes)
      .add('properties', properties)
      .toString();

  /// [DomainClassSource]s are created once for each class
  /// by the [TypeSourceFactory].
  /// Therefore [DomainClassSource]s are equal when
  /// the [runtimeType] and [libraryMemberUri] compare
  /// because other fields will be the identical.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberSource &&
          runtimeType == DomainClassSource &&
          libraryMemberUri == other.libraryMemberUri;

  @override
  int get hashCode => libraryMemberPath.hashCode ^ libraryUri.hashCode;

  /// Finds all the [ClassSource]s that are used in this [ActionMethod].
  /// It will also get [ClassSource]s used inside the
  /// DomainClass [ActionMethod]s and the [ActionMethod]s inside its [Property]s
  ///
  /// TODO: Be aware for never ending round trips.
  @override
  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    usedTypes.add(this);
    for (var property in properties) {
      usedTypes.addAll(property.propertyType.usedTypes);
    }

    /// TODO add actionMethods.usedTypes???
    return usedTypes;
  }
}

/// See [SourceClassFactory]
class DomainSourceFactory extends SourceFactory {
  final SourceContext context;
  final PropertySourceFactory propertySourceFactory;

  DomainSourceFactory(this.context)
      : propertySourceFactory = PropertySourceFactory(context);

  /// Creates a [DomainClassSource] if it is a [DomainClass]. Note that it will
  /// return an existing [DomainClassSource] if one was already created.
  DomainClassSource? create(InterfaceElement element) {
    if (!_isSupportedDomainClass(element)) {
      return null;
    }
    var libraryUri = TypeSourceFactory.libraryUri(element);
    var className = TypeSourceFactory.className(element);

    var existingDomainClass = _findExistingDomainClass(libraryUri, className);
    if (existingDomainClass != null) {
      return existingDomainClass;
    }

    var properties = propertySourceFactory.create(element as ClassElement);
    return DomainClassSource(
      libraryUri: libraryUri,
      className: className,
      name: _createName(element),
      description: _createDescription(element),
      properties: properties,
    );
  }

  DomainClassSource? _findExistingDomainClass(
      String libraryUri, String className) {
    var domainClasses = context.application.domainClasses;
    var existingDomainClass = domainClasses.firstWhereOrNull((domainClass) =>
        domainClass.libraryUri == libraryUri &&
        domainClass.libraryMemberPath == className);
    return existingDomainClass;
  }

  bool _isSupportedDomainClass(Element element) {
    return element is ClassElement &&
        element.isPublic &&
        !element.isAbstract &&
        hasNamelessConstructorWithoutParameters(element) &&
        !element.asLibraryMemberPath.startsWith('dart:') &&
        !element.asLibraryMemberPath
            .startsWith('package:reflect_gui_builder/builder/domain') &&
        propertySourceFactory.hasProperty(element);
  }

  Translatable _createName(ClassElement domainClassElement) => Translatable(
      key: _createNameKey(domainClassElement),
      englishText: _createNameText(domainClassElement));

  String _createNameKey(ClassElement domainClassElement) =>
      '${domainClassElement.asLibraryMemberPath}.name';
  String _createNameText(ClassElement domainClassElement) =>
      domainClassElement.name.titleCase;

  Translatable _createDescription(ClassElement domainClassElement) =>
      Translatable(
          key: _createDescriptionKey(domainClassElement),
          englishText: _createDescriptionText(domainClassElement));

  String _createDescriptionKey(ClassElement domainClassElement) =>
      '${domainClassElement.asLibraryMemberPath}.description';

  String _createDescriptionText(ClassElement domainClassElement) =>
      _createNameText(domainClassElement);
}
