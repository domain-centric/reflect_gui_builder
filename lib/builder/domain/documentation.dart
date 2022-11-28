/// Sometimes we need to define a concept.
///
/// We do this with:
/// * [Dart doc comments](https://dart.dev/guides/language/effective-dart/documentation)
///   that explains the concept
/// * Followed by a abstract class of which the class name corresponds with
///   the concept
/// * This class extends or implements the [ConceptDocumentation] class
///   to indicate it is intended as concept documentation
/// * This class has an empty body
///
/// So that:
/// * Developers can easily look up a concept by clicking on a class link
/// * The documentation can be used with a documentation generation tool
///   such as the documentation_builder package.
abstract class ConceptDocumentation {}
