import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation_factory.dart';
import 'package:reflect_gui_builder/builder/domain/enum_class/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

class EnumPresentationFactory extends CodeFactory {
  final ActionMethodPresentationFactory actionMethodPresentationFactory;

  EnumPresentationFactory(super.context)
      : actionMethodPresentationFactory =
            ActionMethodPresentationFactory(context.outputPathFactory);

  @override
  void populate() {
    for (var enumClass in application.enumClasses) {
      var librarySourceUri = enumClass.libraryUri.toString();
      var classes = _createClasses(enumClass);
      generatedLibraries.addClasses(librarySourceUri, classes);
    }
  }

  List<Class> _createClasses(EnumSource enumSource) {
    var actionMethodClasses =
        actionMethodPresentationFactory.createClasses(enumSource.actionMethods);
    var enumClass = _createEnumClass(enumSource, actionMethodClasses);
    return [enumClass, ...actionMethodClasses];
  }

  Class _createEnumClass(EnumSource enumSource, List<Class> propertyClasses) =>
      Class(
        _createClassName(enumSource),
        superClass: _createSuperClass(),
        constructors: _createConstructors(enumSource),
        fields: _createFields(enumSource, propertyClasses),
      );

  List<Constructor> _createConstructors(EnumSource enumSource) => [
        Constructor(Type(_createClassName(enumSource)),
            initializers: Initializers(
                constructorCall: ConstructorCall(
                    super$: true,
                    parameterValues: ParameterValues([
                      ParameterValue.named('libraryUri',
                          Expression.ofString(enumSource.libraryUri)),
                      ParameterValue.named('className',
                          Expression.ofString(enumSource.className)),
                    ]))))
      ];

  String _createClassName(EnumSource enumSource) =>
      outputPathFactory.createOutputClassName(enumSource.className);

  Type _createSuperClass() => Type('EnumPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/enum_class/enum_presentation.dart');

  List<Field> _createFields(
          EnumSource enumSource, List<Class> actionMethodClasses) =>
      [
        _createValuesField(enumSource),
        _createTranslatableFields(
          enumSource,
          'names',
          enumSource.names,
        ),
        _createTranslatableFields(
          enumSource,
          'descriptions',
          enumSource.descriptions,
        ),
        _createActionMethodsField(actionMethodClasses),
      ];

  Field _createTranslatableFields(EnumSource enumSource, String fieldName,
          Map<String, Translatable> translatableMap) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: Expression.ofMap({
            for (var entry in translatableMap.entries)
              Expression.ofType(TypeFactory().create(enumSource))
                      .getProperty(entry.key):
                  TranslatableConstructorCall(entry.value)
          }));

  Field _createActionMethodsField(
    List<Class> actionMethodsClasses,
  ) =>
      Field('actionMethods',
          annotations: [Annotation.override()],
          modifier: Modifier.final$,
          type: Type.ofList(genericType: ActionMethodPresentationType()),
          value: _createActionMethodsFieldValue(actionMethodsClasses));

  Expression _createActionMethodsFieldValue(List<Class> actionMethodClasses) =>
      Expression.ofList(actionMethodClasses
          .map((propertyClass) =>
              Expression.callConstructor(Type(_className(propertyClass))))
          .toList());

  String _className(Class propertyClass) =>
      CodeFormatter().unFormatted(propertyClass.name);

  Field _createValuesField(EnumSource enumSource) => Field(
        'values',
        annotations: [Annotation.override()],
        modifier: Modifier.final$,
        value: _createValuesFieldValue(enumSource),
      );

  Expression _createValuesFieldValue(EnumSource enumSource) =>
      Expression.ofType(TypeFactory().create(enumSource)).getProperty('values');
}
