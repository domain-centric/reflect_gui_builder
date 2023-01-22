import 'package:flutter/material.dart';

/// Creates [Widget]s to display or edit values for a specific type
abstract class ValueWidgetFactory<T> {
  const ValueWidgetFactory();

  Widget createEditableValue();

  Widget createReadOnlyValue();
}

class StringWidgetFactory extends ValueWidgetFactory<String> {
  final finalField = '';

  // late String lateField;
  static String staticField = '';
  static const String constField = '';

  const StringWidgetFactory();

  @override
  Widget createEditableValue() => const TextField();

  //TODO link value to TextField
  //TODO label
  //TODO add validation result text

  @override
  Widget createReadOnlyValue() => const Text('');

  //TODO link value to Text
  //TODO add label
  //TODO add validation result text

}

class IntWidgetFactory extends ValueWidgetFactory<int> {
  const IntWidgetFactory();

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

class ListWidgetFactory extends ValueWidgetFactory<List<Object>> {
  const ListWidgetFactory();

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
  const EnumWidgetFactory();

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
