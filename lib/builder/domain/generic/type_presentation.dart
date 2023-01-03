import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';

/// See [PresentationClass]
/// a [LibraryMemberPresentation]
class LibraryMemberPresentation {
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

  LibraryMemberPresentation(
      {required this.libraryMemberPath, required this.libraryUri})
      : libraryMemberUri = Uri.parse('$libraryUri/$libraryMemberPath');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberPresentation &&
          runtimeType == other.runtimeType &&
          libraryMemberUri == other.libraryMemberUri;

  @override
  int get hashCode => libraryMemberPath.hashCode ^ libraryUri.hashCode;

  @override
  String toString() {
    return '$runtimeType{fullUri: $libraryMemberUri}';
  }
}

/// See [PresentationClass]
class ClassPresentation extends LibraryMemberPresentation {
  final ClassPresentation? genericType;
  final String className;

  ClassPresentation(
      {required Uri libraryUri, required this.className, this.genericType})
      : super(libraryUri: libraryUri, libraryMemberPath: className);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericType', genericType)
        .toString();
  }
}
