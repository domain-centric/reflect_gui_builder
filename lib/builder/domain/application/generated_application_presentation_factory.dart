import 'package:dart_code/dart_code.dart';
import 'package:fluent_regex/fluent_regex.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:recase/recase.dart';

import '../translation/translatable_code.dart';

/// See [PresentationClassFactory]
class GeneratedApplicationPresentationFactory {
  final ApplicationPresentationSource application;

  GeneratedApplicationPresentationFactory(this.application);

  create() {
    var c = Class(
      ApplicationName().createClassName(application),
      superClass: _createSuperClass(),
      fields: _createFields(),
    );
    print(CodeFormatter().format(c));
  }

  Type _createSuperClass() => Type('ApplicationPresentation2',
      libraryUri:
          'package:reflect_gui_builder/builder/domain/application/application_presentation2.dart');

  List<Field> _createFields() => [
        ApplicationName().createField(application),
        ApplicationDescription().createField(application),
      ];
}

class ApplicationName {
  static const name = 'name';
  static final presentationSuffix =
      FluentRegex().literal('presentation').endOfLine().ignoreCase();

  Field createField(ApplicationPresentationSource application) => Field(name,
      type: TranslatableType(),
      annotations: [Annotation.override()],
      value: TranslatableConstructorCall(
          key: '${application.libraryMemberUri}.$name',
          englishText: createName(application)));

  String createName(ApplicationPresentationSource application) =>
      presentationSuffix.removeAll(application.className).sentenceCase;

  String createClassName(ApplicationPresentationSource application) =>
      '${presentationSuffix.removeAll(application.className)}Presentation';
}

class ApplicationDescription {
  static const description = 'description';

  Field createField(ApplicationPresentationSource application) => Field(
      description,
      type: TranslatableType(),
      annotations: [Annotation.override()],
      value: TranslatableConstructorCall(
          key: '${application.libraryMemberUri}.$description',
          englishText: createDescription(application)));

  //TODO get description from pubspec, if none, fall back on [ApplicationName]
  createDescription(ApplicationPresentationSource application) =>
      ApplicationName().createName(application);
}
