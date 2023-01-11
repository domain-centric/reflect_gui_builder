import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:recase/recase.dart';

/// See [SourceClass]
class PropertySource extends LibraryMemberSource {
  final String className;
  final String propertyName;
  final String propertyType;
  final Translatable name;
  final Translatable description;
  final ClassSource widgetFactory;

  PropertySource({
    required super.libraryUri,
    required this.className,
    required this.propertyName,
    required this.propertyType,
    required this.name,
    required this.description,
    required this.widgetFactory,
  }) : super(libraryMemberPath: '$className.$propertyName');

  @override
  String toString() => ToStringBuilder('$PropertySource')
      .add('libraryMemberPath', libraryMemberPath)
      .add('name', name)
      .add('description', description)
      .add('type', propertyType)
      .toString();
}

/// See [SourceClassFactory]
class PropertySourceFactory {
  List<PropertySource> create(ClassElement element) {
    print('=>$element'); //TODO why is this called so often???
    var allFields = _findAllFields(element.thisType);
    var properties = <PropertySource>[];
    for (var field in allFields) {
      var property = _createProperty(field);
      if (property != null) {
        properties.add(property);
      }
    }
    return properties;
  }

  bool hasProperty(ClassElement element) {
    var allFields = _findAllFields(element.thisType);
    for (var field in allFields) {
      var property = _createProperty(field);
      if (property != null) {
        return true;
      }
    }
    return false;
  }

  /// returns fields of a interface type
  /// and all fields of its super classes and mixins, except from [Object]
  List<FieldElement> _findAllFields(InterfaceType interfaceType) {
    if (interfaceType.isDartCoreObject) {
      return [];
    }
    var allFields = <FieldElement>[];
    allFields.addAll(interfaceType.element.fields);
    for (var superType in interfaceType.allSupertypes) {
      //recursive call. TODO do we need to prevent endless round calls?
      allFields.addAll(_findAllFields(superType));
    }
    for (var mixinType in interfaceType.mixins) {
      //recursive call. TODO do we need to prevent endless round calls?
      allFields.addAll(_findAllFields(mixinType));
    }
    return allFields;
  }

  PropertySource? _createProperty(FieldElement field) {
    if (!_isValidProperty(field)) {
      return null;
    }
    String libraryMemberPath = field.asLibraryMemberPath;
    Translatable name = Translatable(
        key: '$libraryMemberPath.name', englishText: field.name.sentenceCase);
    Translatable description = Translatable(
        key: '$libraryMemberPath.description',
        englishText: field.name.sentenceCase);

    String propertyType = field.type.toString(); //TODO use TypeSourceFactory
    var widgetFactory = _createWidgetFactory();
    return PropertySource(
      libraryUri: field.enclosingElement.source!.uri,
      className: field.enclosingElement.name!,
      propertyName: field.displayName,
      propertyType: propertyType,
      name: name,
      description: description,
      widgetFactory: widgetFactory,
    );
  }

  ClassSource _createWidgetFactory() => ClassSource(
      libraryUri: Uri.parse(
          'package:reflect_gui_builder/builder/domain/property_factory/property_widget_factory.dart'),
      className: 'StringWidgetFactory');

  bool _isValidProperty(FieldElement field) =>
      field.isPublic && field.getter != null; //TODO verify if type is supported
}
