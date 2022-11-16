import 'package:reflect_gui_builder/core/type/to_string.dart';

/// Provides meta data on a library member
class LibraryMemberReflection {
  /// Name of the library member.
  /// [libraryUri] combined with [name] uniquely identifies each member
  /// Examples:
  /// * myConstant
  /// * myFunction
  /// * MyClass
  /// * MyClass.myField
  /// * MyEnum.myValue
  final String name;

  /// A [Uri] to the library
  /// [libraryUri] combined with [name] uniquely identifies each member
  /// Examples:
  /// * dart:core
  /// * package:my_package/by_directory/my_lib.dart
  final Uri libraryUri;

  /// A full [Uri] to the library member ([libraryUri]/[name])
  /// Examples:
  /// * dart:core/String
  /// * package:my_package/by_directory/my_lib.dart/MyClass.myField
  final Uri fullUri;

  LibraryMemberReflection({required this.name, required this.libraryUri})
      : fullUri = Uri.parse('$libraryUri/$name');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberReflection &&
          runtimeType == other.runtimeType &&
          fullUri == other.fullUri;

  @override
  int get hashCode => name.hashCode ^ libraryUri.hashCode;

  @override
  String toString() {
    return '$runtimeType{fullUri: $fullUri}';
  }
}

/// Provides meta data on Class or Interface (abstract class)
class ClassReflection extends LibraryMemberReflection {
  ClassReflection? genericType;

  ClassReflection(
      {required super.libraryUri, required super.name, this.genericType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassReflection &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          libraryUri == other.libraryUri &&
          genericType == other.genericType;

  @override
  int get hashCode =>
      name.hashCode ^ libraryUri.hashCode ^ genericType.hashCode;

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('fullUri', fullUri)
        .add('genericType', genericType)
        .toString();
  }
}
