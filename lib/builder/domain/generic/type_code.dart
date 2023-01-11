import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';

class TypeFactory {
  Type create(ClassSource classSource) => Type(
        classSource.className,
        libraryUri: classSource.libraryUri.toString(),
      );
}
