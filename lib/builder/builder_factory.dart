import 'package:build/build.dart';
import 'reflect_gui_config_builder.dart';

/// run from command line: dart run build_runner build lib --delete-conflicting-outputs

Builder reflectGuiConfigBuilder(BuilderOptions builderOptions) =>
    ReflectGuiConfigBuilder();
