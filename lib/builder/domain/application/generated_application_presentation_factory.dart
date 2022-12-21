import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/generic/build_logger.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable_code.dart';

/// See [PresentationClassFactory]
class GeneratedApplicationPresentationFactory {
  final ApplicationPresentationSource application;
  final PresentationOutputPathFactory outputPathFactory;
  static final log = BuildLoggerFactory.create();

  GeneratedApplicationPresentationFactory(
      this.outputPathFactory, this.application);

  void populate(GeneratedLibraries generatedLibraries) {
    var librarySourceUri = application.libraryUri.toString();
    var classToAdd = _createClass();
    generatedLibraries.addClass(librarySourceUri, classToAdd);
  }

  _createClass() => Class(
        _className,
        superClass: _createSuperClass(),
        fields: _createFields(),
      );
  // log.info('\n${CodeFormatter().format(createdClass)}');

  String get _className =>
      outputPathFactory.createOutputClassName(application.className);

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
        .createImportOutputUri(serviceClassSource.libraryUri)
        .toString();
    return Type(
      className,
      libraryUri: libraryUri,
    );
  }
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
