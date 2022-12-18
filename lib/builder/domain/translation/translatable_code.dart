import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

class TranslatableConstructorCall extends Expression {
  TranslatableConstructorCall(Translatable translatable)
      : super.callConstructor(TranslatableType(),
            parameterValues: _createParameterValues(translatable));

  static ParameterValues _createParameterValues(Translatable translatable) =>
      ParameterValues([
        ParameterValue.named('key', Expression.ofString(translatable.key)),
        ParameterValue.named(
            'englishText', Expression.ofString(translatable.englishText)),
      ]);
}

class TranslatableType extends Type {
  TranslatableType()
      : super('$Translatable',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/translation/translatable.dart');
}
