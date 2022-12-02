import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/type_source.dart';
import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/reflection_factory.dart';

/// Contains information on a [Enum]s source code.
/// See [SourceClass]
class EnumSource extends ClassSource {
  final List<String> values;

  EnumSource(
      {required super.libraryUri,
      required super.className,
      required this.values});

  /// [EnumSource]s are created once for each class
  /// by the [TypeSourceFactory].
  /// Therefore [EnumSource]s are equal when
  /// the [runtimeType] and [libraryMemberUri] are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberSource &&
          runtimeType == EnumSource &&
          libraryMemberUri == other.libraryMemberUri;

  @override
  int get hashCode => libraryMemberPath.hashCode ^ libraryUri.hashCode;
}

/// See [SourceClassFactory]
class EnumSourceFactory extends SourceFactory {
  final ReflectGuiConfigSource reflectGuiConfig;

  EnumSourceFactory(this.reflectGuiConfig);

  /// Creates a [EnumSource] if it is a [Enum]. Note that it will
  /// return an existing [EnumSource] if one was already created.
  EnumSource? create(InterfaceElement element) {
    try {
      _validateEnumElement(element);
    } catch (e) {
      //print('$element $e');
      return null;
    }
    var libraryUri = TypeSourceFactory.libraryUri(element);
    var className = TypeSourceFactory.className(element);

    var existingEnum = _findExistingEnum(libraryUri, className);
    if (existingEnum != null) {
      return existingEnum;
    }
    var values = _enumValues(element);
    return EnumSource(
        libraryUri: libraryUri, className: className, values: values);
  }

  EnumSource? _findExistingEnum(Uri libraryUri, String className) {
    var enums = reflectGuiConfig.enums;
    var existingEnum = enums.firstWhereOrNull((enumSource) =>
        enumSource.libraryUri == libraryUri &&
        enumSource.libraryMemberPath == className);
    return existingEnum;
  }

  void _validateEnumElement(Element element) {
    if (element is! ClassElement) {
      throw ('Domain class: ${element.asLibraryMemberPath} must be a class.');
    }
    if (TypeSourceFactory.libraryUri(element).scheme == 'dart') {
      throw ('Domain class: ${element.asLibraryMemberPath} can not be a class from the Dart core package.');
    }
    if (!element.isPublic) {
      throw ('Domain class: ${element.asLibraryMemberPath} must be public.');
    }
    // TODO: DomainClass may be abstract???
    // if (element.isAbstract) {
    //   throw ('Domain class: ${element.asLibraryMemberPath} may not be abstract.');
    // }
    if (!hasNamelessConstructorWithoutParameters(element)) {
      throw ('Domain class: ${element.asLibraryMemberPath} does not have a nameless constructor without parameters.');
    }
    if (TypeSourceFactory.libraryUri(element)
        .toString()
        .startsWith('package:reflect_gui_builder/builder/domain')) {
      throw ('Domain class: ${element.asLibraryMemberPath} can not be a reflect_gui_builder class.');
    }
    //TODO _validateIfHasAtLeastOneProperty;
  }

  _enumValues(InterfaceElement element) => []; //TODO
}
