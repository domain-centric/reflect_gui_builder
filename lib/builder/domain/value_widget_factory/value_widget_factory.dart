import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart';
import 'package:responsive_layout_grid/responsive_layout_grid.dart';

/// Creates [Widget]s to display or edit values for a specific type
abstract class ValueWidgetFactory<T> {
  final PropertyPresentation property;

  const ValueWidgetFactory(this.property);

  Widget createEditableValue();

  Widget createReadOnlyValue();
}

class PropertyLabel extends StatelessWidget {
  final PropertyPresentation property;
  const PropertyLabel(this.property, {super.key});

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.centerLeft, //TODO for languages right to left
      child: Text(property.name.englishText, //TODO make multilingual
          style: const TextStyle(fontSize: 12)));
}

class StringWidgetFactory extends ValueWidgetFactory<String> {
  final finalField = '';

  // late String lateField;
  static String staticField = '';
  static const String constField = '';

  const StringWidgetFactory(super.property);

  @override
  Widget createEditableValue() => ResponsiveLayoutCell(
        columnSpan: const ColumnSpan.size(2),
        //TODO add column span
        //TODO add position e.g. {CellPositionNextRow}
        child: Column(
          children: [
            PropertyLabel(property),
            TextField(
              controller: TextEditingController(
                  text: "Nils ten Hoeve"), //TODO link to field
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            //TODO add action method context menu button
            //TODO add password
            //TODO add description
            //TODO add suffix (e.g. unit of measurement)
            //TODO add validation result text
          ],
        ),
      );

  @override
  Widget createReadOnlyValue() => Column(children: [
        PropertyLabel(property),
        const Text('Nils ten Hoeve'),
      ]);

  //TODO link value to Text
  //TODO add label
  //TODO add validation result text
}

class IntWidgetFactory extends ValueWidgetFactory<int> {
  const IntWidgetFactory(super.property);

// See ... for numeral input
  @override
  Widget createEditableValue() => ResponsiveLayoutCell(
        columnSpan: const ColumnSpan.size(2),
        //TODO add colum n span
        child: Column(
          children: [
            PropertyLabel(property),
            TextField(
              controller:
                  TextEditingController(text: "123"), //TODO link to field
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
// for below version 2 use this:  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater you can also use this
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            //TODO add action method context menu button
            //TODO add password
            //TODO add description
            //TODO add suffix (e.g. unit of measurement)
            //TODO add validation result text
          ],
        ),
      );

  //TODO link value to TextField including unit of measurement, and formatter (e.g. thousands separator)
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyValue() => const Text('');

  //TODO link value to Text including unit of measurement, and formatter (e.g. thousands separator)
  //TODO add label
  //TODO add validation result text
}

class ListWidgetFactory extends ValueWidgetFactory<List<Object>> {
  const ListWidgetFactory(super.property);

  @override
  Widget createEditableValue() => const TextField();

  //TODO link value to TextField including unit of measurement, and formatter (e.g. thousands separator)
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyValue() => const Text('');

  //TODO link value to Text including unit of measurement, and formatter (e.g. thousands separator)
  //TODO add label
  //TODO add validation result text
}

class EnumWidgetFactory extends ValueWidgetFactory<Enum> {
  const EnumWidgetFactory(super.property);

  @override
  Widget createEditableValue() => const TextField();

  //TODO link value to TextField including unit of measurement, and formatter (e.g. thousands separator)
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyValue() => const Text('');

  //TODO link value to Text including unit of measurement, and formatter (e.g. thousands separator)
  //TODO add label
  //TODO add validation result text
}
