import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class DomainClassPresentationFactory extends CodeFactory {
  DomainClassPresentationFactory(super.context);

  @override
  void populate() {
    for (var domainClass in application.domainClasses) {
      var librarySourceUri = domainClass.libraryUri.toString();
      var classToAdd = _createClass(domainClass);
      generatedLibraries.addClass(librarySourceUri, classToAdd);
    }
  }

  Class _createClass(DomainClassSource domainClass) => Class(
        _createClassName(domainClass),
        superClass: _createSuperClass(),
        fields: _createFields(domainClass),
        methods: _createMethods(domainClass),
      );

  String _createClassName(DomainClassSource domainClass) =>
      outputPathFactory.createOutputClassName(domainClass.className);

  Type _createSuperClass() => Type('DomainClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart');

  List<Field> _createFields(DomainClassSource domainClass) => [
        _createTranslatableField('name', domainClass.name),
        _createTranslatableField('description', domainClass.description),
        ///..._createActionMethodFields(domainClass),
        ..._createPropertyFields(domainClass),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  List<Method> _createMethods(DomainClassSource domainClass) => [
        // _createActionMethodsGetter(serviceClass),
        _createPropertiesGetter(domainClass),
      ];

  /// e.g. List<ActionMethodPresentation> get actionMethods => [allCustomers];

  // Method _createActionMethodsGetter(DomainClassSource domainClass) =>
  //     Method.getter(
  //       'actionMethods',
  //       _createActionMethodsGetterBody(domainClass),
  //       annotations: [Annotation.override()],
  //       type: Type.ofList(genericType: ActionMethodPresentationType()),
  //     );

  Method _createPropertiesGetter(DomainClassSource domainClass) =>
      Method.getter(
        'properties',
        _createPropertiesGetterBody(domainClass),
        annotations: [Annotation.override()],
         type: Type.ofList(genericType: PropertyPresentationType()),
       
      );

  // Expression _createActionMethodsGetterBody(DomainClassSource domainClass) =>
  //     Expression.ofList(domainClass.actionMethods
  //         .map((actionMethod) => Expression.ofVariable(actionMethod.methodName))
  //         .toList());

  Expression _createPropertiesGetterBody(DomainClassSource domainClass) =>
      Expression.ofList(domainClass.properties
          .map((property) => Expression.ofVariable(property.propertyName))
          .toList());

  List<Field> _createPropertyFields(DomainClassSource domainClass) {
    final presentationFactory = PropertyPresentationFactory();
    var fields = <Field>[];
    var order = 0;
    for (var property in domainClass.properties) {
      order += 100;
      var field = presentationFactory.create(property, order);
      fields.add(field);
    }
    return fields;
  }
}
