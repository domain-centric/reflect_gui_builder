import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';

import '../domain_class/domain_class_source.dart';
import '../enum/enum_source.dart';
import '../application/application_presentation_source.dart';

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
  final List<ClassSource> genericTypes;
  final String className;

  ClassSource(
      {required Uri libraryUri,
      required this.className,
      this.genericTypes = const []})
      : super(libraryUri: libraryUri, libraryMemberPath: className);

  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    usedTypes.add(this);
    for (var genericType in genericTypes) {
      usedTypes.addAll(genericType.usedTypes);
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
          genericTypes == other.genericTypes;

  @override
  int get hashCode =>
      libraryMemberPath.hashCode ^ libraryUri.hashCode ^ genericTypes.hashCode;

  @override
  String toString() => ToStringBuilder(runtimeType.toString())
      .add('libraryMemberUri', libraryMemberUri)
      .add('genericTypes', genericTypes)
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
    var genericTypes = _genericTypes(type);
    return ClassSource(
        libraryUri: libraryUri(type.element),
        className: className(type.element),
        genericTypes: genericTypes);
  }

  static final noneLetterSuffix = RegExp('[^a-zA-Z].*\$');

  static String className(InterfaceElement element) => element.thisType
      .getDisplayString(withNullability: false)
      .replaceFirst(noneLetterSuffix, '');

  static Uri libraryUri(InterfaceElement element) => element.library.source.uri;

  List<ClassSource> _genericTypes(InterfaceType type) {
    var genericTypes = <ClassSource>[];
    for (var typeArgument in type.typeArguments) {
      var genericType = create(typeArgument as InterfaceType);
      genericTypes.add(genericType);
    }
    return genericTypes;
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
            _hasSameGenericTypes(supportedType, typeToCompare) ||
        _isDomainClass(supportedType, typeToCompare) ||
        _isEnum(supportedType, typeToCompare);
  } else {
    return false;
  }
}

bool _hasSameGenericTypes(
    ClassSource supportedType, ClassSource typeToCompare) {
  if (supportedType.genericTypes.length != typeToCompare.genericTypes.length) {
    return false;
  }
  for (int i = 0; i < supportedType.genericTypes.length; i++) {
    var supportedTypeGenericType = supportedType.genericTypes[i];
    var typeToCompareGenericType = typeToCompare.genericTypes[i];
    var isSupported =
        supported(supportedTypeGenericType, typeToCompareGenericType);
    if (!isSupported) {
      return false;
    }
  }
  return true;
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
