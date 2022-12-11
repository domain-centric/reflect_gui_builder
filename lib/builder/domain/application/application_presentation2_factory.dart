import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

/// See [PresentationClassFactory]
class ApplicationPresentationFactory {
  create(ApplicationPresentationSource reflectGuiConfigSource) {
    final applicationPresentation = Class((c) => c
      ..name = '\$AcmePresentation'
      ..extend = const ApplicationPresentationReference()
      ..methods.add(Method((m) => m
        ..name = 'name'
        ..returns = TranslatableReference()
        ..lambda = true
        ..body = Code("${TranslatableReference().symbol}( "
            "key: '${reflectGuiConfigSource.serviceClasses.first.libraryMemberUri}', "
            "englishText:'${reflectGuiConfigSource.serviceClasses.first.className}')"))));
    final emitter = DartEmitter.scoped();
    //print('${applicationPresentation.accept(emitter)}');
    print(DartFormatter().format('${applicationPresentation.accept(emitter)}'));
  }
}


class ApplicationPresentationReference extends Reference {
  const ApplicationPresentationReference()
      : super('ApplicationPresentation',
            'package:reflect_gui_builder/builder/domain/application/aplication_presentation.dart');
}
