import 'package:code_builder/code_builder.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';

class Translatable {
  /// unique key to identify a text
  final String key;

  /// English text, that may contain parameters, e.g. 'Must be less than {0}'
  final String englishText;

  Translatable({required this.key, required this.englishText});

  String translate(
          {String language = 'en', List<dynamic> parameters = const []}) =>
      englishText; //TODO

  @override
  String toString() => ToStringBuilder('$Translatable')
      .add('key', key)
      .add('englishText', englishText)
      .toString();
}
