import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart';
import 'package:reflect_gui_builder/gui/gui_tab.dart' as gui_tab;
import 'package:reflect_gui_builder/gui/gui_tab_form_example.dart';
import 'package:reflect_gui_builder/gui/scroll_view_with_scroll_bar.dart';
import 'package:responsive_layout_grid/responsive_layout_grid.dart';

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
class FormTab extends gui_tab.Tab {
  final ActionMethodPresentation actionMethod;
  final DomainClassPresentation domainClassPresentation;

  const FormTab({
    required this.actionMethod,
    required this.domainClassPresentation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FormContent(domainClassPresentation);
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

class FormContent extends StatelessWidget {
  final DomainClassPresentation domainClassPresentation;
  const FormContent(this.domainClassPresentation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScrollViewWithScrollBar(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: ResponsiveFormGrid(domainClassPresentation),
        ),
      );
}

class ResponsiveFormGrid extends StatelessWidget {
  final DomainClassPresentation domainClassPresentation;
  const ResponsiveFormGrid(this.domainClassPresentation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ResponsiveLayoutGrid(
      maxNumberOfColumns: maxNumberOfColumns,
      children: [
        ..._createFields(),
        _createButtonBarGutter(),
        _createCancelButton(
            context, CellPosition.nextRow(rowAlignment: RowAlignment.right)),
        _createSubmitButton(context, CellPosition.nextColumn()),
      ],
    );

  ResponsiveLayoutCell _createGroupBar(String title) => ResponsiveLayoutCell(
        position: CellPosition.nextRow(),
        columnSpan: ColumnSpan.remainingWidth(),
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey,
          child: Center(
            child: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      );

  ResponsiveLayoutCell _createTextField({
    required String label,
    required CellPosition position,
    ColumnSpan columnSpan = const ColumnSpan.size(2),
    int maxLines = 1,
  }) =>
      ResponsiveLayoutCell(
        position: position,
        columnSpan: columnSpan,
        child: Column(children: [
          Align(alignment: Alignment.topLeft, child: Text(label)),
          TextFormField(
            maxLines: maxLines,
            decoration: const InputDecoration(
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0)),
            ),
          ),
        ]),
      );

  ResponsiveLayoutCell _createSubmitButton(
      BuildContext context, CellPosition position) {
    return ResponsiveLayoutCell(
        position: position,
        child: ElevatedButton(
          onPressed: () {
            //TODO call Tab.close
          },
          child: const Center(
              child:
                  Padding(padding: EdgeInsets.all(16), child: Text('Submit'))),
        ));
  }

  ResponsiveLayoutCell _createCancelButton(
      BuildContext context, CellPosition position) {
    return ResponsiveLayoutCell(
        position: position,
        child: OutlinedButton(
          onPressed: () {
            //TODO call Tab.close
          },
          child: const Center(
              child:
                  Padding(padding: EdgeInsets.all(16), child: Text('Cancel'))),
        ));
  }

  _createButtonBarGutter() => ResponsiveLayoutCell(
        position: CellPosition.nextRow(),
        child: const SizedBox(height: 8),
      );

  List<Widget> _createFields() {
    var fields = <Widget>[];
    for (var property in domainClassPresentation.properties) {
      var field = property.widgetFactory.createEditableValue();
      fields.add(field);
    }
    return fields;
  }
}
