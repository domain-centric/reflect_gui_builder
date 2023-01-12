import 'package:dart_code/dart_code.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class ActionMethodPresentationFactory {
  List<Class> createClasses(ServiceClassSource serviceClass) {
    var classes = <Class>[];
    var order = 0;
    for (var actionMethod in serviceClass.actionMethods) {
      order += 100;
      var generatedClass = create(actionMethod, order);
      classes.add(generatedClass);
    }
    return classes;
  }

  Class create(ActionMethodSource actionMethod, int order) => Class(
        _createClassName(actionMethod),
        superClass: ActionMethodPresentationType(),
        fields: _createFields(actionMethod, order),
      );

  String _createClassName(ActionMethodSource actionMethod) =>
      '${actionMethod.className}'
      '${actionMethod.methodName.pascalCase}'
      'Presentation';

  List<Field> _createFields(ActionMethodSource actionMethod, int order) => [
        _createTranslatableField('name', actionMethod.name),
        _createTranslatableField('description', actionMethod.description),
        _createOrderField(order),
        _createVisibleField(),
        _createIconField(actionMethod),
        _createParameterProcessorField(actionMethod),
        _createResultProcessorField(actionMethod),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  Field _createOrderField(int order) => Field(
        'order',
        modifier: Modifier.final$,
        annotations: [Annotation.override()],
        value: Expression.ofInt(order),
      );

  Field _createVisibleField() => Field('visible',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: Expression.ofBool(true));

  Field _createParameterProcessorField(ActionMethodSource actionMethod) =>
      Field('parameterProcessor',
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: _createParameterProcessorConstructorCall(actionMethod));

  Expression _createParameterProcessorConstructorCall(
          ActionMethodSource actionMethod) =>
      Expression.callConstructor(
        TypeFactory().create(actionMethod.parameterProcessor),
        isConst: true,
      );

  Field _createResultProcessorField(ActionMethodSource actionMethod) =>
      Field('resultProcessor',
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: _createResultProcessorConstructorCall(actionMethod));

  Expression _createResultProcessorConstructorCall(
      ActionMethodSource actionMethod) {
    return Expression.callConstructor(
      TypeFactory().create(actionMethod.resultProcessor),
      isConst: true,
    );
  }

  Field _createIconField(ActionMethodSource actionMethod) => Field('icon',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: _createResultProcessorConstructorCall(actionMethod)
          .getProperty('defaultIcon')
          .ifNull(_createParameterProcessorConstructorCall(actionMethod)
              .getProperty('defaultIcon'))
          .ifNull(Expression.ofType(
                  Type('Icons', libraryUri: 'package:flutter/material.dart'))
              .getProperty('fiber_manual_record_rounded')));
}

class ActionMethodPresentationType extends Type {
  ActionMethodPresentationType()
      : super('ActionMethodPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart');
}
