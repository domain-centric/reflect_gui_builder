import 'package:reflect_gui_builder/builder/domain/generic/documentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/reflect_gui_config_builder.dart';

/// A [SourceClass] is a class that contains information from Dart source code.
///
/// A [SourceClass] :
/// * name ends with the Source suffix
///   e.g. DomainSource
/// * is created by a [SourceClassFactory]
///   e.g. DomainSourceFactory
/// * It is used by a [PresentationClassFactory] but is decoupled from generating
///   a [PresentationClass] code, so it has no methods to convert to Dart code.
class SourceClass extends ConceptDocumentation {}

/// A [SourceClassFactory]
/// * name ends with the SourceFactory suffix
///   e.g. DomainSourceFactory
/// * creates a [SourceClass] by converting the source code model
///   from the analyzer package to a more specific and
///   better understandable [SourceClass] model.
/// * is used by the [ReflectGuiConfigBuilder]
class SourceClassFactory extends ConceptDocumentation {}
