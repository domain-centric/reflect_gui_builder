import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

class TranslatableConstructorCall extends Expression {
  
  TranslatableConstructorCall(
      {required String key, required String englishText})
      : super.callConstructor(TranslatableType(),
            parameterValues: _createParameterValues(key, englishText));

  static ParameterValues _createParameterValues(
          String key, String englishText) =>
      ParameterValues([
        ParameterValue.named('key', Expression.ofString(key)),
        ParameterValue.named('englishText', Expression.ofString(englishText)),
      ]);
}

class TranslatableType extends Type {
  TranslatableType(): super('$Translatable',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/translation/translatable.dart') ;
  
}