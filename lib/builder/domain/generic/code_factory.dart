import 'package:reflect_gui_builder/builder/domain/application/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generated_library/generated_library.dart';
import 'package:reflect_gui_builder/builder/domain/generic/build_logger.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';
import 'package:reflect_gui_builder/builder/reflect_presentation_library_builder.dart';

abstract class CodeFactory {
  final PresentationOutputPathFactory outputPathFactory;
  final GeneratedLibraries generatedLibraries;
  final ApplicationPresentationSource application;
  static final log = BuildLoggerFactory.create();

  CodeFactory(CodeFactoryContext context)
      : outputPathFactory = context.outputPathFactory,
        generatedLibraries = context.generatedLibraries,
        application = context.application;

  /// Generates classes using the [application]
  /// and puts then into the [generatedLibraries]
  void populate();
}

class CodeFactoryContext {
  final PresentationOutputPathFactory outputPathFactory;
  final GeneratedLibraries generatedLibraries;
  final ApplicationPresentationSource application;
  CodeFactoryContext(
    ReflectPresentationLibraryBuilder builder,
    this.generatedLibraries,
    this.application,
  ) : outputPathFactory = PresentationOutputPathFactory(builder);
}
