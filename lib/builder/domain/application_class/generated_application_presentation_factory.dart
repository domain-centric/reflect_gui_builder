import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/generic/code_factory.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_code.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

/// See [PresentationClassFactory]
class GeneratedApplicationPresentationFactory extends CodeFactory {
  GeneratedApplicationPresentationFactory(CodeFactoryContext context)
      : super(context);

  @override
  void populate() {
    var librarySourceUri = application.libraryUri.toString();
    var classToAdd = _createClass();
    generatedLibraries.addClass(librarySourceUri, classToAdd);
  }

  _createClass() => Class(
        _className,
        superClass: _createSuperClass(),
        fields: _createFields(),
        methods: _createMethods(),
      );

  String get _className =>
      outputPathFactory.createOutputClassName(application.className);

  Type _createSuperClass() => Type('GeneratedApplicationPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/application_class/generated_application_presentation.dart');

  List<Field> _createFields() => [
        _createTranslatableField('name', application.name),
        _createTranslatableField('description', application.description),
        _createStringField('version', application.version),
        _createStringField('titleImagePath', application.titleImagePath),
        _createUriField('documentation', application.documentation),
        _createUriField('homePage', application.homePage),
        _createServiceClassesField(application.serviceClasses),
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  Field _createUriField(String fieldName, Uri? uri) => Field(
        fieldName,
        modifier: Modifier.final$,
        annotations: [Annotation.override()],
        value: UriConstructorCall(uri),
      );

  Field _createStringField(String fieldName, String? string) => Field(
        fieldName,
        annotations: [Annotation.override()],
        modifier: Modifier.final$,
        value: _createStringExpression(string),
      );

  Expression _createStringExpression(String? string) {
    if (string == null) {
      return Expression.ofNull();
    } else {
      return Expression.ofString(string);
    }
  }

  Field _createServiceClassesField(List<ServiceClassSource> serviceClasses) =>
      Field('serviceClasses',
          modifier: Modifier.final$,
          annotations: [Annotation.override()],
          value: _createServiceClassesExpression(serviceClasses));

  Expression _createServiceClassesExpression(
          List<ServiceClassSource> serviceClasses) =>
      Expression.ofList(serviceClasses
          .map((ServiceClassSource serviceClassSource) =>
              _createServiceClassPresentationConstructorCall(
                  serviceClassSource))
          .toList());

  Expression _createServiceClassPresentationConstructorCall(
          ServiceClassSource serviceClassSource) =>
      Expression.callConstructor(
          _createServiceClassPresentationType(serviceClassSource));

  Type _createServiceClassPresentationType(
      ServiceClassSource serviceClassSource) {
    var className =
        outputPathFactory.createOutputClassName(serviceClassSource.className);
    var libraryUri = outputPathFactory
        .createOutputUri(serviceClassSource.libraryUri)
        .toString();
    return Type(
      className,
      libraryUri: libraryUri,
    );
  }

  List<Method> _createMethods() => [
        _createThemeGetter('lightTheme' ),
        _createThemeGetter('darkTheme'),
      ];

  Method _createThemeGetter(
          String getterName) =>
      Method.getter(
        getterName,
        Expression.callConstructor(TypeFactory().create(application))
            .getProperty(getterName),
        annotations: [Annotation.override()],
      );
}

class UriConstructorCall extends Expression {
  factory UriConstructorCall(Uri? uri) {
    if (uri == null) {
      return UriConstructorCall._(Expression.ofNull().nodes);
    } else {
      return UriConstructorCall._(Expression.callConstructor(UriType(),
              name: 'parse', parameterValues: _createParameterValues(uri))
          .nodes);
    }
  }

  UriConstructorCall._(List<CodeNode> nodes) : super(nodes);

  static ParameterValues _createParameterValues(Uri uri) => ParameterValues([
        ParameterValue(Expression.ofString(uri.toString())),
      ]);
}

class UriType extends Type {
  UriType() : super('$Uri');
}
