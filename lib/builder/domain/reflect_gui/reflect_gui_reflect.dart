import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:reflect_gui_builder/builder/domain/reflect_gui/reflect_gui_source.dart';

/// See [ReflectionClassFactory]
class ReflectGuiConfigReflectionFactory {
  create(ReflectGuiConfigSource reflectGuiConfigSource) {
    final applicationPresentation = Class((c) => c
      ..name = '\$AcmePresentation'
      ..extend = refer('ApplicationPresentation')
      ..methods.add(Method((m) => m
        ..name = 'name'
        ..returns = refer('String')
        ..lambda=true
        ..body = Code(reflectGuiConfigSource.serviceClasses.first.className))));
    final emitter = DartEmitter.scoped();
    print(DartFormatter().format('${applicationPresentation.accept(emitter)}'));
  }

}