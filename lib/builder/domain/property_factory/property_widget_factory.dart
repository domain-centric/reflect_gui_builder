import 'package:flutter/material.dart';

/// Creates property widgets for a specific property type
abstract class PropertyWidgetFactory<T> {
  const PropertyWidgetFactory();

  Widget createEditableFormField();

  Widget createReadOnlyFormField();

  Widget createTableCellField();
}

class StringWidgetFactory extends PropertyWidgetFactory<String> {
  final finalField = '';

  // late String lateField;
  static String staticField = '';
  static const String constField = '';

  const StringWidgetFactory();

  @override
  Widget createEditableFormField() => const TextField();

  //TODO link value to TextField
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyFormField() => const Text('');

  //TODO link value to Text
  //TODO add label
  //TODO add validation result text

  @override
  Widget createTableCellField() => const Text('');
  //TODO link value to Text
  //TODO add validation result text
}

class IntWidgetFactory extends PropertyWidgetFactory<int> {
  const IntWidgetFactory();

  @override
  Widget createEditableFormField() => const TextField();

  //TODO link value to TextField including unit of measurement, and formatter (e.g. thousands separator)
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyFormField() => const Text('');

  //TODO link value to Text including unit of measurement, and formatter (e.g. thousands separator)
  //TODO add label
  //TODO add validation result text

  @override
  Widget createTableCellField() => const Text('');
  //TODO link value to Text  including unit of measurement, and formatter (e.g. thousands separator)
  //TODO add validation result text
}
