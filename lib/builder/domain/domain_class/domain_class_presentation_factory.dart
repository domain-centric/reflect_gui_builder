import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class DomainClassPresentationFactory extends CodeFactory {
  final PropertyPresentationFactory propertyPresentationFactory;

  DomainClassPresentationFactory(super.context)
      : propertyPresentationFactory =
            PropertyPresentationFactory(context.outputPathFactory);

  @override
  void populate() {
    for (var domainClass in application.domainClasses) {
      var librarySourceUri = domainClass.libraryUri.toString();
      var classes = _createClasses(domainClass);
      generatedLibraries.addClasses(librarySourceUri, classes);
    }
  }

  List<Class> _createClasses(DomainClassSource domainClassSource) {
    var propertyClasses =
        propertyPresentationFactory.createClasses(domainClassSource);
    var domainClass = _createDomainClass(domainClassSource, propertyClasses);
    return [domainClass, ...propertyClasses];
  }

  Class _createDomainClass(
          DomainClassSource domainClass, List<Class> propertyClasses) =>
      Class(
        _createClassName(domainClass),
        superClass: _createSuperClass(),
        constructors: _createConstructors(domainClass),
        fields: _createFields(domainClass, propertyClasses),
      );

  List<Constructor> _createConstructors(DomainClassSource domainClass) => [
        Constructor(Type(_createClassName(domainClass)),
            initializers: Initializers(
                constructorCall: ConstructorCall(
                    super$: true,
                    parameterValues: ParameterValues([
                      ParameterValue.named('libraryUri',
                          Expression.ofString(domainClass.libraryUri)),
                      ParameterValue.named('className',
                          Expression.ofString(domainClass.className)),
                    ]))))
      ];

  String _createClassName(DomainClassSource domainClass) =>
      outputPathFactory.createOutputClassName(domainClass.className);

  Type _createSuperClass() => Type('DomainClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart');

  List<Field> _createFields(
          DomainClassSource domainClass, List<Class> propertyClasses) =>
      [
        _createTranslatableField('name', domainClass.name),
        _createTranslatableField('description', domainClass.description),
        _createPropertiesField(propertyClasses),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  Field _createPropertiesField(
    List<Class> propertyClasses,
  ) =>
      Field('properties',
          annotations: [Annotation.override()],
          modifier: Modifier.final$,
          type: Type.ofList(genericType: PropertyPresentationType()),
          value: _createPropertiesFieldValue(propertyClasses));

  Expression _createPropertiesFieldValue(List<Class> propertyClasses) =>
      Expression.ofList(propertyClasses
          .map((propertyClass) =>
              Expression.callConstructor(Type(_className(propertyClass))))
          .toList());

  String _className(Class propertyClass) =>
      CodeFormatter().unFormatted(propertyClass.name);
}
