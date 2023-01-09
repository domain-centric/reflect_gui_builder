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
      var classes = _createClasses(domainClass);
      for (var aClass in classes) {
        generatedLibraries.addClass(librarySourceUri, aClass);
      }
    }
  }

  List<Class> _createClasses(DomainClassSource domainClassSource) {
    var propertyClasses =
        PropertyPresentationFactory().createClasses(domainClassSource);
    var domainClass = _createDomainClass(domainClassSource, propertyClasses);
    return [domainClass, ...propertyClasses];
  }

  Class _createDomainClass(
          DomainClassSource domainClass, List<Class> propertyClasses) =>
      Class(
        _createClassName(domainClass),
        superClass: _createSuperClass(),
        fields: _createFields(domainClass),
        methods: _createMethods(domainClass, propertyClasses),
      );

  String _createClassName(DomainClassSource domainClass) =>
      outputPathFactory.createOutputClassName(domainClass.className);

  Type _createSuperClass() => Type('DomainClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart');

  List<Field> _createFields(DomainClassSource domainClass) => [
        _createTranslatableField('name', domainClass.name),
        _createTranslatableField('description', domainClass.description),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  List<Method> _createMethods(
    DomainClassSource domainClass,
    List<Class> propertyClasses,
  ) =>
      [
        // _createActionMethodsGetter(serviceClass),
        _createPropertiesGetter(domainClass, propertyClasses),
      ];

  /// e.g. List<ActionMethodPresentation> get actionMethods => [allCustomers];

  // Method _createActionMethodsGetter(DomainClassSource domainClass) =>
  //     Method.getter(
  //       'actionMethods',
  //       _createActionMethodsGetterBody(domainClass),
  //       annotations: [Annotation.override()],
  //       type: Type.ofList(genericType: ActionMethodPresentationType()),
  //     );

  Method _createPropertiesGetter(
    DomainClassSource domainClass,
    List<Class> propertyClasses,
  ) =>
      Method.getter(
        'properties',
        _createPropertiesGetterBody(propertyClasses),
        annotations: [Annotation.override()],
        type: Type.ofList(genericType: PropertyPresentationType()),
      );

  // Expression _createActionMethodsGetterBody(DomainClassSource domainClass) =>
  //     Expression.ofList(domainClass.actionMethods
  //         .map((actionMethod) => Expression.ofVariable(actionMethod.methodName))
  //         .toList());

  Expression _createPropertiesGetterBody(List<Class> propertyClasses) =>
      Expression.ofList(propertyClasses
          .map((propertyClass) =>
              Expression.callConstructor(Type(_className(propertyClass))))
          .toList());

  String _className(Class propertyClass) =>
      CodeFormatter().unFormatted(propertyClass.name);
}
