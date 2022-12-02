import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/type_source.dart';
import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/reflection_factory.dart';

/// Contains information on a [DomainClass] source code.
/// See [SourceClass]
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

/// See [SourceClassFactory]
class DomainSourceFactory extends SourceFactory {
  final ReflectGuiConfigSource reflectGuiConfig;

  DomainSourceFactory(this.reflectGuiConfig);

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

    return DomainClassSource(libraryUri: libraryUri, className: className);
  }

  DomainClassSource? _findExistingDomainClass(
      Uri libraryUri, String className) {
    var domainClasses = reflectGuiConfig.domainClasses;
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
            .startsWith('package:reflect_gui_builder/builder/domain');
    //TODO _validateIfHasAtLeastOneProperty;
  }
}
