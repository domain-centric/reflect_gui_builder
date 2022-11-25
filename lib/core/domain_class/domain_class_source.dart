import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/reflection_factory.dart';

/// Contains information on a [DomainClass]s source code.
class DomainClassSource extends ClassSource {
  DomainClassSource({required super.libraryUri, required super.className});

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
}

/// Creates a [DomainClassSource]s by using the
/// analyzer package
class DomainClassSourceFactory extends SourceFactory {
  final ReflectGuiConfigSource reflectGuiConfig;

  DomainClassSourceFactory(this.reflectGuiConfig);

  /// Creates a [DomainClassSource] if it is a [DomainClass]. Note that it will
  /// return an existing [DomainClassSource] if one was already created.
  DomainClassSource? create(InterfaceElement element) {
    try {
      _validateDomainClassElement(element);
    } catch (e) {
      print('$element $e');
      return null;
    }
    var libraryUri = TypeSourceFactory.libraryUri(element);
    var className = TypeSourceFactory.className(element);

    var existingDomainClass = _findExistingDomainClass(libraryUri, className);
    if (existingDomainClass != null) {
      return existingDomainClass;
    }

    return DomainClassSource(libraryUri: libraryUri, className: className);
  }

  DomainClassSource? _findExistingDomainClass(Uri libraryUri, String className) {
      var domainClasses = reflectGuiConfig.domainClasses;
    var existingDomainClass = domainClasses.firstWhereOrNull((domainClass) =>
        domainClass.libraryUri == libraryUri &&
        domainClass.libraryMemberPath == className);
    return existingDomainClass;
  }

  void _validateDomainClassElement(Element element) {
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
    if (TypeSourceFactory.libraryUri(element).toString().startsWith('package:reflect_gui_builder/core')) {// TODO rename to package:reflect_gui_builder/builder and move core folder under builder and rename core folder to domain
      throw ('Domain class: ${element.asLibraryMemberPath} can not be a reflect_gui_builder class.');
    }
    //TODO _validateIfHasAtLeastOneProperty;
  }
}
