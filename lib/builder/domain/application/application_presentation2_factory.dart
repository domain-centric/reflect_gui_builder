import 'package:dart_code/dart_code.dart';
import 'package:fluent_regex/fluent_regex.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

import '../translation/translatable_code.dart';

/// See [PresentationClassFactory]
class ApplicationPresentationFactory {
  final ApplicationPresentationSource application;

  ApplicationPresentationFactory(this.application);

  create() {
    var c = Class(
      _createClassName(),
      superClass: _createSuperClass(),
      fields: _createFields(),
    );
    print(CodeFormatter().format(c));
  }

  static final presentationSuffix =
      FluentRegex().literal('presentation').endOfLine().ignoreCase();

  String _createClassName() =>
      '${presentationSuffix.removeAll(application.className)}Presentation';

  String _createClassDisplayName() =>
      presentationSuffix.removeAll(application.className);

  Type _createSuperClass() => Type('ApplicationPresentation2',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/application/application_presentation2.dart');

  List<Field> _createFields() => [
        _createNameField(),
        _createDescriptionField(),
      ];

  Field _createNameField() => Field('name',
      type: TranslatableType(),
      annotations: [Annotation.override()],
      value: TranslatableConstructorCall(
          key: '${application.libraryMemberUri}.name',
          englishText: _createClassDisplayName()));

  Field _createDescriptionField() => Field('description',
      type: TranslatableType(),
      annotations: [Annotation.override()],
      value: TranslatableConstructorCall(
          key: '${application.libraryMemberUri}.description',
          englishText: _createClassDisplayName()));
}
