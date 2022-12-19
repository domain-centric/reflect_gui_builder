import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/build_logger.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

/// See [PresentationClassFactory]
class GeneratedApplicationPresentationFactory {
  final ApplicationPresentationSource application;
  static final log = BuildLoggerFactory.create();

  GeneratedApplicationPresentationFactory(this.application);

  create() {
    var c = Class(
      application
          .className, // TODO add $ as a prefix of the class name to mark it is generated
      superClass: _createSuperClass(),
      fields: _createFields(),
    );
    log.info('\n${CodeFormatter().format(c)}');
  }

  Type _createSuperClass() => Type('GeneratedApplicationPresentation',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/application/generated_application_presentation.dart');

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
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  Field _createUriField(String fieldName, Uri? uri) => Field(fieldName,
      annotations: [Annotation.override()], value: UriConstructorCall(uri));

  Field _createStringField(String fieldName, String? string) => Field(fieldName,
      annotations: [Annotation.override()],
      value: _createStringExpression(string));

  Expression _createStringExpression(String? string) {
    if (string == null) {
      return Expression.ofNull();
    } else {
      return Expression.ofString(string);
    }
  }

  Field _createServiceClassesField(List<ServiceClassSource> serviceClasses) =>
      Field('serviceClasses',
          annotations: [Annotation.override()],
          value: _createServiceClassesExpression(serviceClasses));

  Expression _createServiceClassesExpression(
          List<ServiceClassSource> serviceClasses) =>
      Expression.ofList(serviceClasses
          .map((ServiceClassSource serviceClassSource) =>
              Expression.callConstructor(Type(
                serviceClassSource
                    .libraryMemberPath, //TODO convert to generated name, e.g. PersonService => $PersonServicePresentation
                libraryUri: serviceClassSource.libraryUri
                    .toString(), //TODO convert path to generated file
              )))
          .toList());
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
