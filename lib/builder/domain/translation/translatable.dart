import 'package:code_builder/code_builder.dart';

class Translatable {
  /// unique key to identify a text
  final String key;

  /// English text, that may contain parameters, e.g. 'Must be less than {0}'
  final String englishText;

  Translatable(this.key, this.englishText);

  String translate(
          {String language = 'en', List<dynamic> parameters = const []}) =>
      englishText; //TODO
}