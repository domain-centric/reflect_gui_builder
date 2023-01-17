// import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation2.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/item/item.dart';

abstract class DomainClassPresentation extends ClassPresentation
    implements Item {
  DomainClassPresentation(
      {required super.libraryUri, required super.className});

  // TODO List<ActionMethodPresentation> get actionMethods;

  List<PropertyPresentation> get properties;
}
