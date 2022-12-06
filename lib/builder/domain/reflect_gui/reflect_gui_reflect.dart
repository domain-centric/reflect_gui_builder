import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:reflect_gui_builder/builder/domain/reflect_gui/reflect_gui_source.dart';

/// See [ReflectionClassFactory]
class ReflectGuiConfigReflectionFactory {
  create(ReflectGuiConfigSource reflectGuiConfigSource) {
    final animal = Class((b) => b
      ..name = 'Animal'
      ..extend = refer('Organism')
      ..methods.add(Method.returnsVoid((b) => b
        ..name = 'eat'
        ..body = const Code("print('Yum!');"))));
    final emitter = DartEmitter.scoped();
    print(DartFormatter().format('${animal.accept(emitter)}'));
  }
}