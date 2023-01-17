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
  final String libraryUri;

  /// A [Uri] to the library member: ([libraryUri]/[libraryMemberPath])
  /// Examples:
  /// * dart:core/String
  /// * package:my_package/by_directory/my_lib.dart/MyClass.myField
  final String libraryMemberUri;

  LibraryMemberPresentation(
      {required this.libraryMemberPath, required this.libraryUri})
      : libraryMemberUri = '$libraryUri/$libraryMemberPath';

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
  final List<ClassPresentation> genericTypes;
  final String className;

  ClassPresentation({
    required super.libraryUri,
    required this.className,
    this.genericTypes = const [],
  }) : super(libraryMemberPath: className);

  @override
  String toString() {
    return ToStringBuilder(runtimeType.toString())
        .add('libraryMemberUri', libraryMemberUri)
        .add('genericTypes', genericTypes)
        .toString();
  }
}

class DartCore extends ClassPresentation {
  DartCore(String className, {List<ClassPresentation> genericTypes = const []})
      : super(
            libraryUri: 'dart:core',
            className: className,
            genericTypes: genericTypes);

  DartCore.bool() : this('bool');

  DartCore.int() : this('int');

  DartCore.bigInt() : this('BigInt');

  DartCore.double() : this('double');

  DartCore.num() : this('num');

  DartCore.dateTime() : this('DateTime');

  DartCore.duration() : this('Duration');

  DartCore.string() : this('String');

  DartCore.symbol() : this('Symbol');

  DartCore.uri() : this('Uri');

  DartCore.object() : this('Object');

  DartCore.iterable({ClassPresentation? genericType})
      : this('Iterable',
            genericTypes: genericType == null ? [] : [genericType]);

  DartCore.iterator({ClassPresentation? genericType})
      : this('Iterator',
            genericTypes: genericType == null ? [] : [genericType]);

  DartCore.list({ClassPresentation? genericType})
      : this('List', genericTypes: genericType == null ? [] : [genericType]);

  DartCore.set({ClassPresentation? genericType})
      : this('Set', genericTypes: genericType == null ? [] : [genericType]);

  DartCore.map(ClassPresentation keyType, ClassPresentation valueType)
      : this('Map', genericTypes: [keyType, valueType]);
}
