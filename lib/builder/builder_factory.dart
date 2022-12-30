import 'package:build/build.dart';
import 'package:reflect_gui_builder/builder/reflect_presentation_library_writer.dart';
import 'package:reflect_gui_builder/builder/reflect_presentation_library_builder.dart';

/// run from command line: dart run build_runner build lib --delete-conflicting-outputs

Builder reflectPresentationLibraryBuilder(BuilderOptions builderOptions) =>
    ReflectPresentationLibraryBuilder();

Builder reflectPresentationLibraryWriter(BuilderOptions builderOptions) =>
    ReflectPresentationLibraryWriter();