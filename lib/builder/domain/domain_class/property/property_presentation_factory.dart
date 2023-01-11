import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_source.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class PropertyPresentationFactory {
  
  PropertyPresentationFactory();

  List<Class> createClasses(DomainClassSource domainClass) {
    var classes = <Class>[];
    var order = 0;
    for (var property in domainClass.properties) {
      order += 100;
      var propertyClass = _createClass(property, order);
      classes.add(propertyClass);
    }
    return classes;
  }

  _createClass(PropertySource property, int order) => Class(
        _createClassName(property),
        superClass: PropertyPresentationType(),
        fields: _createFields(property, order),
      );

  String _createClassName(PropertySource property) => '\$'
      '${property.className}'
      '${property.propertyName.pascalCase}'
      'Presentation';

  List<Field> _createFields(PropertySource property, int order) => [
        _createTranslatableField('name', property.name),
        _createTranslatableField('description', property.description),
        _createOrderField(order),
        _createVisibleField(),
        _createTypeField(property),
        _createWidgetFactoryField(property),
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

  _createTypeField(PropertySource property) => Field(
        'type',
        modifier: Modifier.final$,
        annotations: [Annotation.override()],
        value: _createTypeConstructorCall(property),
      );

  Expression _createTypeConstructorCall(PropertySource property) =>
      Expression.callConstructor(_createClassPresentationType(),
          parameterValues: _createTypeConstructorCallParameterValues(property));

  ParameterValues _createTypeConstructorCallParameterValues(PropertySource property) {
    //TODO return correct type using TypeFactory
    return ParameterValues([
      ParameterValue.named('libraryUri', Expression.ofString(property.propertyType.libraryUri)),
      ParameterValue.named('className', Expression.ofString(property.propertyType.className)),
      ///TODO recursively: ParameterValue.named('genericType', ...etc
    ]);
  }

  Type _createClassPresentationType() => Type(
      'ClassPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart');

  _createWidgetFactoryField(PropertySource property) => Field('widgetFactory',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: Expression.callConstructor(
          TypeFactory().create(property.widgetFactory),
          isConst: true));
}

class PropertyPresentationType extends Type {
  PropertyPresentationType()
      : super('PropertyPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart');
}
