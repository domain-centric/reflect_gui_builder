import 'package:reflect_gui_builder/builder/domain/generic/documentation.dart';
import 'package:reflect_gui_builder/builder/reflect_gui_config_builder.dart';

/// A [ReflectionClass] is a Dart code class that is generated by
/// a [ReflectGuiConfigBuilder].
///
/// A [ReflectionClass] :
/// * name ends with the Reflection suffix
///   e.g. PersonReflection
/// * is created by a [ReflectionClassFactory]
///   e.g. PersonReflectionFactory
/// * its generated code contains information that is used by the
///   graphical user interface.
class ReflectionClass extends ConceptDocumentation{}


/// A [ReflectionClassFactory]
/// * name ends with the ReflectionFactory suffix
///   e.g. PersonReflectionFactory
/// * creates a [ReflectionClass].
/// * is used by the [ReflectGuiConfigBuilder]
/// * it converts a [SourceClass] to Dart code.
class ReflectionClassFactory extends ConceptDocumentation{}