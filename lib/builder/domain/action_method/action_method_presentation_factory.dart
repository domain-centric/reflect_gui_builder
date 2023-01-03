import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class ActionMethodPresentationFactory {
//   e.g.
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
        _createName(actionMethod),
        _createDescription(actionMethod),
        _createVisible(),
        _createOrder(order),
        _createParameterProcessor(actionMethod),
      ]);

  ParameterValue _createOrder(int order) =>
      ParameterValue.named('order', Expression.ofInt(order));

  ParameterValue _createVisible() =>
      ParameterValue.named('visible', Expression.ofBool(true));

  ParameterValue _createDescription(ActionMethodSource actionMethod) =>
      ParameterValue.named(
          'description', TranslatableConstructorCall(actionMethod.description));

  ParameterValue _createName(ActionMethodSource actionMethod) =>
      ParameterValue.named(
          'name', TranslatableConstructorCall(actionMethod.name));

  ParameterValue _createParameterProcessor(ActionMethodSource actionMethod) =>
      ParameterValue.named(
        'parameterProcessor',
        Expression([
          KeyWord.const$,
          Code(' '),
          Expression.callConstructor(
              TypeFactory.create(actionMethod.parameterProcessor))
        ]),
      );
}

class ActionMethodPresentationType extends Type {
  ActionMethodPresentationType()
      : super('ActionMethodPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation2.dart');
}
