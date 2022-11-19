import 'package:reflect_gui_builder/core/type/type.dart';

/// Contains information from an [ActionMethod]s source code.
/// It is created by the [ActionMethodSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ActionMethodReflection].
abstract class ActionMethodSource extends LibraryMemberSource {
  ActionMethodSource({required super.name, required super.libraryUri});
}
