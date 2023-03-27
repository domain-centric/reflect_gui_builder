import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_source.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class PropertyPresentationFactory {
  final ClassPresentationFactory classPresentationFactory;

  PropertyPresentationFactory(PresentationOutputPathFactory outputPathFactory)
      : classPresentationFactory = ClassPresentationFactory(outputPathFactory);

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
        methods: _createMethods(property),
      );

  String _createClassName(PropertySource property) => '${property.className}'
      '${property.propertyName.pascalCase}'
      'Presentation';

  List<Field> _createFields(PropertySource property, int order) => [
        _createTranslatableField('name', property.name),
        _createTranslatableField('description', property.description),
        _createOrderField(order),
        _createVisibleField(),
        _createTypeField(property),
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

  Field _createTypeField(PropertySource property) => Field('type',
      modifier: Modifier.final$,
      annotations: [Annotation.override()],
      value: classPresentationFactory.create(property.propertyType));

  List<Method> _createMethods(PropertySource property) =>
      [_createWidgetFactoryGetter(property)];

  Method _createWidgetFactoryGetter(PropertySource property) => Method.getter(
        'widgetFactory',
        Expression.callConstructor(TypeFactory().create(property.widgetFactory),
            parameterValues:
                ParameterValues([ParameterValue(Expression.ofThis())])),
        annotations: [Annotation.override()],
      );
}

class PropertyPresentationType extends Type {
  PropertyPresentationType()
      : super('PropertyPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart');
}
