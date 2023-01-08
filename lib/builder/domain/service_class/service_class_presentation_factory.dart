import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class ServiceClassPresentationFactory extends CodeFactory {
  ServiceClassPresentationFactory(CodeFactoryContext context) : super(context);

  @override
  void populate() {
    int index = 0;
    for (var serviceClass in application.serviceClasses) {
      index += 100;
      var librarySourceUri = serviceClass.libraryUri.toString();
      var classToAdd = _createClass(serviceClass, index);
      generatedLibraries.addClass(librarySourceUri, classToAdd);
    }
  }

  Class _createClass(ServiceClassSource serviceClass, int index) => Class(
        _createClassName(serviceClass),
        superClass: _createSuperClass(),
        fields: _createFields(serviceClass, index),
        methods: _createMethods(serviceClass),
      );

  String _createClassName(ServiceClassSource serviceClass) =>
      outputPathFactory.createOutputClassName(serviceClass.className);

  Type _createSuperClass() => Type('ServiceClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation.dart');

  List<Field> _createFields(ServiceClassSource serviceClass, int index) => [
        _createTranslatableField('name', serviceClass.name),
        _createTranslatableField('description', serviceClass.description),
        _createOrderField(index),
        _createVisibleField(),
        _createServiceObjectField(serviceClass),
        ..._createActionMethodFields(serviceClass),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  _createOrderField(int index) => Field(
        'order',
        modifier: Modifier.final$,
        annotations: [Annotation.override()],
        value: Expression.ofInt(index),
      );

  _createVisibleField() => Field('visible',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: Expression.ofBool(true));

  List<Method> _createMethods(ServiceClassSource serviceClass) => [
        _createActionMethodsGetter(serviceClass),
      ];

  /// e.g. List<ActionMethodPresentation> get actionMethods => [allCustomers];

  Method _createActionMethodsGetter(ServiceClassSource serviceClass) =>
      Method.getter(
        'actionMethods',
        _createActionMethodsGetterBody(serviceClass),
        annotations: [Annotation.override()],
        type: Type.ofList(genericType: ActionMethodPresentationType()),
      );

  Expression _createActionMethodsGetterBody(ServiceClassSource serviceClass) =>
      Expression.ofList(serviceClass.actionMethods
          .map((actionMethod) => Expression.ofVariable(actionMethod.methodName))
          .toList());

  List<Field> _createActionMethodFields(ServiceClassSource serviceClass) {
    final presentationFactory = ActionMethodPresentationFactory();
    var fields = <Field>[];
    var order = 0;
    for (var actionMethod in serviceClass.actionMethods) {
      order += 100;
      var field = presentationFactory.create(actionMethod, order);
      fields.add(field);
    }
    return fields;
  }

  Field _createServiceObjectField(ServiceClassSource serviceClass) =>
      Field('serviceObject',
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: Expression.callConstructor(
            TypeFactory.create(serviceClass),
            isConst: true,
          ));
}
