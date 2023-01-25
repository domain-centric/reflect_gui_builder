import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';
import 'package:reflect_gui_builder/gui/gui_tab.dart' as gui_tab;
import 'package:reflect_gui_builder/gui/gui_tab_form_example.dart';

///Forms:
// ======
// * NarrowForm: all input fields underneath each other.
//   The app bar can have a menu button for domain action methods
// * WideForm: input fields next or below each other.
//   Can have a menu bar on top of form (with overflow menu button if need to)
//   for domain action methods
//
//
// Input fields other than tables:
// filled style where possible, labels always floating above
//
// e.g.
// TextField
// NumberField
// Date\TimeField
// ComboFields
// DomainObjectField
// CheckBoxes
// RadioButtons
// Other (custom made and added to ReflectGuiApplication)
//
// Width
// input fields are located underneath each other by default with
//  a maximum length of ....px
// It is recommended to reduce/specify a smaller width where possible (TODO link)
//
// Grouping
// ?next to eachother (flow layout)?
// ?checkboxes / radiobuttons?
// ?named?
//
// Textfield
// =========
// annotations:
// obscureText
// textCapitalization
// maxLength
// maxLines
// keyboardType
// validation
// width
// icon
// prefixIcon
// suffixIcon
// helperText
// autocompletion
//
// readonly = disabled and decoration: InputDecoration.collapsed(hintText: "") to hide edit line
//
// can have a menu button for property action methods
//
// for data types:
// String
// Char?
//
// Numberfield
// =========
// annotations:
// obscure
// length
// keyboardtype
// validation
// width
// formatting
//
// can have a menu button for property action methods
//
// for data types:
// Int
// Double
// ? other
//
// TODO other input fields
// =======================
//
//
//
//
// Tables
// ======
// NarrowTable: 1 column without header
// WideTable: multiple columns with header, number of columns depend on available width
//
// can have a menu bar (with overflow menu button if need to) for domain action methods
//
// Width
// Tables are always located underneath each other
// Tables take all available width if need to.
// For tables you can define the width of columns.
//
// for data types:
// lists
// streams
// ?DataTableSource?
///
class FormExampleTab extends gui_tab.Tab {
  final ActionMethodPresentation actionMethod;

  const FormExampleTab(this.actionMethod, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormExamplePage();
  }

  @override
  bool get canCloseDirectly =>
      true; // TODO: Can not close form directly when containing unsaved data

  @override
  // TODO: implement close
  gui_tab.TabCloseResult get close => throw UnimplementedError();

  @override
  IconData get iconData => Icons.table_rows_sharp;

  @override
  String get title => actionMethod.name.englishText;
}

class FormExampleTabFactory implements gui_tab.TabFactory {
  @override
  gui_tab.Tab create(ActionMethodPresentation actionMethod) {
    return FormExampleTab(actionMethod);
  }
}
