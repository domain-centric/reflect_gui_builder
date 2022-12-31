import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

import '../translation/translatable.dart';

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

  Class _createClass(ServiceClassSource serviceClass, int index) =>
      Class(_createClassName(serviceClass),
          superClass: _createSuperClass(),
          fields: _createFields(serviceClass, index));

  String _createClassName(ServiceClassSource serviceClass) =>
      outputPathFactory.createOutputClassName(serviceClass.className);

  Type _createSuperClass() => Type('ServiceClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation2.dart');

  List<Field> _createFields(ServiceClassSource serviceClass, int index) => [
        _createTranslatableField('name', serviceClass.name),
        _createTranslatableField('description', serviceClass.description),
        _createOrderField(index),
        _createVisibleField(),
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
}
