import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/type/to_string.dart';

import '../domain_class/domain_class_source.dart';

/// Contains information on a library member from its source code.
/// Implementations are normally created by [SourceFactory] that converts
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
/// Implementations are normally created by [SourceFactory] that converts
/// an source code [Element] from the analyzer package to
/// a [LibraryMemberSource]
class ClassSource extends LibraryMemberSource {
  ClassSource? genericType;

  ClassSource(
      {required super.libraryUri,
      required super.libraryMemberPath,
      this.genericType});

  factory ClassSource.fromInterfaceElement(InterfaceElement element) {
    return ClassSource(
        libraryMemberPath: _className(element),
        libraryUri: element.library.source.uri);
  }

  static final noneLetterSuffix = RegExp('[^a-zA-Z].*\$');

  static String _className(InterfaceElement element) => element.thisType
      .getDisplayString(withNullability: false)
      .replaceFirst(noneLetterSuffix, '');

  Set<DomainClassSource> get domainClasses {
    var domainClasses = <DomainClassSource>{};
    if (this is DomainClassSource) {
      var domainClass = this as DomainClassSource;
      domainClasses.add(domainClass);
      domainClasses.addAll(domainClass.domainClasses);
    } else if (genericType != null) {
      domainClasses.addAll(genericType!.domainClasses);
    }
    return domainClasses;
  }

// factory ClassSource.fromInterfaceElementWithGenericType(InterfaceElement element) {
// var name = element.thisType.getDisplayString(withNullability: false);
// var libraryUri = element.library.source.uri;
// ClassSource? genericType;
// if (genericElement != null) {
// genericType = createClassSource(genericElement);
//
// /// TODO recursive call for [genericElement.typeArguments]
// }
// return ClassSource(
// name: name, libraryUri: libraryUri, genericType: genericType);
// }

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
