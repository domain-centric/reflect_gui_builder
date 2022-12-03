import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';

import '../domain_class/domain_class_source.dart';
import '../enum/enum_source.dart';
import '../reflect_gui/reflect_gui_source.dart';

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

  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    usedTypes.add(this);
    if (genericType != null) {
      usedTypes.addAll(genericType!.usedTypes);
    }
    return usedTypes;
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
  String toString() => ToStringBuilder(runtimeType.toString())
      .add('libraryMemberUri', libraryMemberUri)
      .add('genericType', genericType)
      .toString();
}

class TypeSourceFactory {
  final FactoryContext context;

  TypeSourceFactory(this.context);

  /// returns:
  /// * A [DomainClassSource] if it is a [DomainClass]. Note that it will return
  ///   an existing [DomainClassSource] if one was already created.
  /// * A [EnumSource] if it is a [Enum]. Note that it will return
  ///   an existing [EnumSource] if one was already created.
  /// * Otherwise a [ClassSource] including its generic type if any
  ///   e.g. Person being the generic type in List<Person>

  ClassSource create(InterfaceType type) {
    var domainSource = context.domainSourceFactory.create(type.element);
    if (domainSource != null) {
      return domainSource;
    }
    var enumSource = context.enumSourceFactory.create(type.element);
    if (enumSource != null) {
      return enumSource;
    }
    var genericType = _genericType(type);
    return ClassSource(
        libraryUri: libraryUri(type.element),
        className: className(type.element),
        genericType: genericType);
  }

  static final noneLetterSuffix = RegExp('[^a-zA-Z].*\$');

  static String className(InterfaceElement element) => element.thisType
      .getDisplayString(withNullability: false)
      .replaceFirst(noneLetterSuffix, '');

  static Uri libraryUri(InterfaceElement element) => element.library.source.uri;

  ClassSource? _genericType(InterfaceType type) {
    if (type.typeArguments.length != 1 ||
        type.typeArguments.first is! InterfaceType) {
      return null;
    } else {
      return create(type.typeArguments.first as InterfaceType);
    }
  }
}

/// Returns true when the [typeToCompare] is supported by the [supportedType].
/// Note that:
/// * [typeToCompare] and or [supportedType] can be null.
/// * if the [supportedType] or one of its generic types is an [Object] type
///   than [typeToCompare] must be a [DomainClassSource]
/// * if the [supportedType] or one of its generic types is an [Enum] type
///   than [typeToCompare] must be a [EnumSource]
bool supported(ClassSource? supportedType, ClassSource? typeToCompare) {
  if (supportedType == null && typeToCompare == null) {
    return true;
  }
  if (supportedType != null && typeToCompare != null) {
    return _hasSameLibraryMemberUri(supportedType, typeToCompare) &&
            supported(supportedType.genericType, typeToCompare.genericType) ||
        _isDomainClass(supportedType, typeToCompare) ||
        _isEnum(supportedType, typeToCompare);
  } else {
    return false;
  }
}

bool _isEnum(ClassSource supportedType, ClassSource typeToCompare) =>
    supportedType.libraryMemberUri.toString() == 'dart:core/Enum' &&
    typeToCompare is EnumSource;

bool _isDomainClass(ClassSource supportedType, ClassSource typeToCompare) =>
    supportedType.libraryMemberUri.toString() == 'dart:core/Object' &&
    typeToCompare is DomainClassSource;

bool _hasSameLibraryMemberUri(
        ClassSource supportedType, ClassSource typeToCompare) =>
    (supportedType.libraryMemberPath == typeToCompare.libraryMemberPath);
