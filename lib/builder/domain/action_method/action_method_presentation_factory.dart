import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class ActionMethodPresentationFactory {
  // e.g.
//  final allCustomers = ActionMethodPresentation<List,void>(
//       name: Translatable(key: '...', englishText: 'All customers'),
//       description: Translatable(key: '...', englishText: 'All customers'),
//       order: 100,
//       visible: true,
//       methodOwnerFactory: () => const PersonService(),
//       parameterProcessor: const ProcessResultDirectlyWhenThereIsNoParameter(),
//       resultType: ClassPresentation(className: 'List', libraryUri: Uri.parse('dart:core'), genericType: const $PersonPresentation() ),
//       resultProcessor: const ShowListInTableTab());
  Field create(ActionMethodSource actionMethod, int order) => Field(
        actionMethod.methodName,
        modifier: Modifier.final$,
        value: _createConstructorCall(actionMethod, order),
      );

  Expression _createConstructorCall(
          ActionMethodSource actionMethod, int order) =>
      Expression.callConstructor(ActionMethodPresentationType(),
          parameterValues:
              _createConstructorParameterValues(actionMethod, order));

  ParameterValues _createConstructorParameterValues(
          ActionMethodSource actionMethod, int order) =>
      ParameterValues([
        _createTranslatableParameter('name', actionMethod.name),
        _createTranslatableParameter('description', actionMethod.description),
        ParameterValue.named('visible', Expression.ofBool(true)),
        ParameterValue.named('order', Expression.ofInt(order)),
      ]);

  ParameterValue _createTranslatableParameter(
    String name,
    Translatable translatable,
  ) =>
      ParameterValue.named(name, TranslatableConstructorCall(translatable));
}

class ActionMethodPresentationType extends Type {
  ActionMethodPresentationType()
      : super('ActionMethodPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation2.dart');
}
