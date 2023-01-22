import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class ServiceClassPresentationFactory extends CodeFactory {
  final ActionMethodPresentationFactory actionMethodPresentationFactory;

  ServiceClassPresentationFactory(CodeFactoryContext context)
      : actionMethodPresentationFactory =
            ActionMethodPresentationFactory(context.outputPathFactory),
        super(context);

  @override
  void populate() {
    int order = 0;
    for (var serviceClass in application.serviceClasses) {
      order += 100;
      var librarySourceUri = serviceClass.libraryUri.toString();
      var classes = _createClasses(serviceClass, order);
      generatedLibraries.addClasses(librarySourceUri, classes);
    }
  }

  List<Class> _createClasses(ServiceClassSource serviceClassSource, int order) {
    var actionMethodClasses = actionMethodPresentationFactory
        .createClasses(serviceClassSource.actionMethods);
    var serviceClass =
        _createServiceClass(serviceClassSource, order, actionMethodClasses);
    return [serviceClass, ...actionMethodClasses];
  }

  Class _createServiceClass(ServiceClassSource serviceClass, int order,
          List<Class> actionMethodClasses) =>
      Class(
        _createClassName(serviceClass),
        superClass: _createSuperClass(),
        fields: _createFields(serviceClass, order, actionMethodClasses),
      );

  String _createClassName(ServiceClassSource serviceClass) =>
      outputPathFactory.createOutputClassName(serviceClass.className);

  Type _createSuperClass() => Type('ServiceClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation.dart');

  List<Field> _createFields(ServiceClassSource serviceClass, int index,
          List<Class> actionMethodClasses) =>
      [
        _createTranslatableField('name', serviceClass.name),
        _createTranslatableField('description', serviceClass.description),
        _createOrderField(index),
        _createVisibleField(),
        _createServiceObjectField(serviceClass),
        _createActionMethodsField(actionMethodClasses),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  _createOrderField(int order) => Field(
        'order',
        modifier: Modifier.final$,
        annotations: [Annotation.override()],
        value: Expression.ofInt(order),
      );

  _createVisibleField() => Field('visible',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: Expression.ofBool(true));

  /// e.g. List<ActionMethodPresentation> get actionMethods => [allCustomers];

  Field _createActionMethodsField(List<Class> actionMethodClasses) => Field(
        'actionMethods',
        annotations: [Annotation.override()],
        modifier: Modifier.final$,
        type: Type.ofList(genericType: ActionMethodPresentationType()),
        value: _createActionMethodsFieldValue(actionMethodClasses),
      );

  Expression _createActionMethodsFieldValue(List<Class> actionMethodClasses) =>
      Expression.ofList(actionMethodClasses
          .map((actionMethodClass) =>
              Expression.callConstructor(Type(_className(actionMethodClass))))
          .toList());

  String _className(Class actionMethodClass) =>
      CodeFormatter().unFormatted(actionMethodClass.name);

  Field _createServiceObjectField(ServiceClassSource serviceClass) =>
      Field('serviceObject',
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: Expression.callConstructor(
            TypeFactory().create(serviceClass),
            isConst: true,
          ));
}
