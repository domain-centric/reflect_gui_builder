import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/build_logger.dart';
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
        _createUriField('documentationUri', application.documentationUri)
      ];

  Field _createTranslatableField(String fieldName, Translatable translatable) =>
      Field(fieldName,
          annotations: [Annotation.override()],
          value: TranslatableConstructorCall(translatable));

  _createUriField(String fieldName, Uri? uri) => Field(fieldName,
      annotations: [Annotation.override()], value: UriConstructorCall(uri));
}

class UriConstructorCall extends Expression {
  factory UriConstructorCall(Uri? uri) {
    if (uri == null) {
      return UriConstructorCall._([Code('null')]);
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
