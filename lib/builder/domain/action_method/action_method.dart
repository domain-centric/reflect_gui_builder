import '../generic/documentation.dart';

/// ## [ActionMethod]
///
/// [ActionMethod]s are methods in a [ServiceObject] or [DomainObject] that
/// comply with a set of rules and are therefore recognized by the
/// [ReflectFramework].
///
/// [ActionMethod]s are displayed as menu items in a [ReflectGuiApplication]
/// or as commands in other types of [ReflectApplication]s.
///
/// A method needs to comply to the following rules to be considered a [ActionMethod] if:
/// - the method is in a [ServiceObject] or [DomainObject]
/// - and the method is public (method name does not start with an underscore)
/// - and there is a [ActionMethodParameterProcessor]
///   that can process the method parameter signature.
/// - and there is a [ActionMethodResultProcessor]
///   that can process the method result.
abstract class ActionMethod implements ConceptDocumentation {}
