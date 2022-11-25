import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/core/domain_class/domain_class.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflect_gui_source.dart';
import 'package:reflect_gui_builder/core/type/to_string.dart';

import '../domain_class/domain_class_source.dart';

/// Contains information on a library member from its source code.
/// Implementations are normally created by [ReflectGuiConfigPopulateFactory] that converts
/// an source code [Element] from the analyzer package to
/// a [LibraryMemberSource]
class LibraryMemberSource {
  /// Name of the library member.
  /// Examples:
  /// * myConstant
  /// * myFunction
  /// * MyClass
  /// * MyClass.myField
  /// * MyClass.myMethod
  /// * MyEnum.myValue
  final String libraryMemberPath;

  /// A [Uri] to the library
  /// Examples:
  /// * dart:core
  /// * package:my_package/by_directory/my_lib.dart
  final Uri libraryUri;

  /// A [Uri] to the library member: ([libraryUri]/[libraryMemberPath])
  /// Examples:
  /// * dart:core/String
  /// * package:my_package/by_directory/my_lib.dart/MyClass.myField
  final Uri libraryMemberUri;

  LibraryMemberSource(
      {required this.libraryMemberPath, required this.libraryUri})
      : libraryMemberUri = Uri.parse('$libraryUri/$libraryMemberPath');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberSource &&
          runtimeType == other.runtimeType &&
          libraryMemberUri == other.libraryMemberUri;

  @override
  int get hashCode => libraryMemberPath.hashCode ^ libraryUri.hashCode;

  @override
  String toString() {
    return '$runtimeType{fullUri: $libraryMemberUri}';
  }
}

/// Contains information on a class from its source code.
/// Implementations are normally created by [ReflectGuiConfigPopulateFactory] that converts
/// an source code [Element] from the analyzer package to
/// a [LibraryMemberSource]
class ClassSource extends LibraryMemberSource {
  final ClassSource? genericType;
  final String className;

  ClassSource(
      {required Uri libraryUri, required this.className, this.genericType})
      : super(libraryUri: libraryUri, libraryMemberPath: className);

  Set<DomainClassSource> get domainClasses {
    var domainClasses = <DomainClassSource>{};
    if (this is DomainClassSource) {
      domainClasses.add(this as DomainClassSource);
    }
    if (genericType != null) {
      domainClasses.addAll(genericType!.domainClasses);
    }
    return domainClasses;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassSource &&
          runtimeType == other.runtimeType &&
          libraryMemberPath == other.libraryMemberPath &&
          libraryUri == other.libraryUri &&
          genericType == other.genericType;

  @override
  int get hashCode =>
      libraryMemberPath.hashCode ^ libraryUri.hashCode ^ genericType.hashCode;

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericType', genericType)
        .toString();
  }
}

class TypeSourceFactory {
  final ReflectGuiConfigSource reflectGuiConfig;
  late DomainClassSourceFactory domainClassFactory;

  TypeSourceFactory(this.reflectGuiConfig) {
    domainClassFactory = DomainClassSourceFactory(reflectGuiConfig);
  }

  /// returns:
  /// * A [DomainClassSource] if it is a [DomainClass]. Note that it will return
  ///   an existing [DomainClassSource] if one was already created.
  /// * Otherwise a [ClassSource] including its generic type if any
  ///   e.g. Person being the generic type in List<Person>

  ClassSource create(InterfaceElement element) {
    var domainClass = domainClassFactory.create(element);
    if (domainClass == null) {
      var genericType = _genericType(element);
      return ClassSource(
          libraryUri: libraryUri(element),
          className: className(element),
          genericType: genericType);
    } else {
      return domainClass;
    }
  }

  ClassSource create2(InterfaceType type) {
    var domainClass = domainClassFactory.create(type.element);
    if (domainClass == null) {
      var genericType = _genericType2(type);
      return ClassSource(
          libraryUri: libraryUri(type.element),
          className: className(type.element),
          genericType: genericType);
    } else {
      return domainClass;
    }
  }


  static final noneLetterSuffix = RegExp('[^a-zA-Z].*\$');

  static String className(InterfaceElement element) =>
      element.thisType
          .getDisplayString(withNullability: false)
          .replaceFirst(noneLetterSuffix, '');

  static Uri libraryUri(InterfaceElement element) => element.library.source.uri;

  InterfaceElement? _genericElement(Element element) {
    // if (element.typeParameters.length != 1) {
    //   /// only supports 1 generic type parameters
    //   /// Unsupported example: Map<int, String>
    //   return null;
    // } else {
    /// Supported example: List<Person> or Iterator<int>
    print(
        '* $element '); //${(element as ClassElement).thisType.typeArguments.first}');
    return null; //TODO
    // }
  }

  ClassSource? _genericType(Element element) {
    var genericElement = _genericElement(element);
    if (genericElement != null) {
      return create(genericElement);
    } else {
      return null;
    }
  }


  ClassSource? _genericType2(InterfaceType type) {
    if (type.typeArguments.length!=1) {
      return null;
    } else {
      return create2(type.typeArguments.first as InterfaceType);
    }
  }
}