import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

/// Implementations of a [ClassPresentation] class are
/// generated classes that contain [Enum] information for the
/// graphical user interface.
abstract class EnumPresentation<ENUM_TYPE extends Enum>
    extends ClassPresentation {
  EnumPresentation({required super.libraryUri, required super.className});

  List<ENUM_TYPE> get values;

  Map<ENUM_TYPE, Translatable> get names;

  Map<ENUM_TYPE, Translatable> get descriptions;

  List<ActionMethodPresentation> get actionMethods;
}
