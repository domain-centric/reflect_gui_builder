import 'package:analyzer/dart/element/element.dart';
import 'package:fluent_regex/fluent_regex.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:plural_noun/plural_noun.dart';

import '../action_method/action_method_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../application/application_presentation_source.dart';
import '../generic/source_factory.dart';

/// Contains information on a [ServiceClass]s source code.
/// It is created by the [ServiceClassSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ServiceClassReflection].
class ServiceClassSource extends ClassSource {
  final Translatable name;
  final Translatable description;

  final List<ActionMethodSource> actionMethods;

  ServiceClassSource(
      {required this.name,
      required this.description,
      required ClassSource serviceClass,
      required this.actionMethods})
      : super(
          libraryUri: serviceClass.libraryUri,
          className: serviceClass.className,
        );

  /// Finds all the [ClassSource]es that are used in all the [ActionMethod]s.
  @override
  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    for (var actionMethod in actionMethods) {
      usedTypes.addAll(actionMethod.usedTypes);
    }
    return usedTypes;
  }

  @override
  String toString() {
    return ToStringBuilder('$ServiceClassSource')
        .add('libraryMemberUri', libraryMemberUri)
        .add('actionMethods', actionMethods)
        .toString();
  }
}

/// Creates a list of [ServiceClassSource]s by using the
/// analyzer package
class ServiceClassSourceFactory extends ReflectGuiConfigPopulateFactory {
  static const serviceClassesFieldName = 'serviceClasses';

  final SourceContext context;
  ServiceClassSourceFactory(this.context);

  /// populates the [application] with created [ServiceClassSource]s
  /// and all their sub classes
  @override
  void populateApplicationPresentation() {
    var field = findField(
        context.applicationPresentationElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    for (ClassElement element in elements) {
      _validateServiceClassElement(field, element);
      var actionMethods = context.actionMethodSourceFactory.createAll(element);
      _validateServiceClassActionMethods(field, element, actionMethods);
      var serviceClassSource = ServiceClassSource(
          name: _createName(element),
          description: _createDescription(element),
          serviceClass: context.typeFactory.create(element.thisType),
          actionMethods: actionMethods);
      context.application.serviceClasses.add(serviceClassSource);
    }

    if (context.application.serviceClasses.isEmpty) {
      throw Exception('${field.asLibraryMemberPath}: may not be empty!');
    }
  }

  void _validateServiceClassElement(FieldElement field, Element serviceClass) {
    if (serviceClass is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must be a class.');
    }
    if (!serviceClass.isPublic) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must be public.');
    }
    if (serviceClass.isAbstract) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} may not be abstract.');
    }

    /// TODO would be nice if we could allow an single constructor with parameters, e.g. to inject infrastructure classes such as repositories, http clients or their test mocks
    if (!hasNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must be immutable and therefore must have a constant constructor.');
    }
  }

  void _validateServiceClassActionMethods(FieldElement field,
      Element serviceClass, List<ActionMethodSource> actionMethodSources) {
    if (actionMethodSources.isEmpty) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must contain 1 or more action methods.');
    }
  }

  Translatable _createName(ClassElement serviceClassElement) => Translatable(
      key: _createNameKey(serviceClassElement),
      englishText: _createNameText(serviceClassElement));

  String _createNameKey(ClassElement serviceClassElement) =>
      '${serviceClassElement.asLibraryMemberPath}.name';

  static final _serviceSuffix =
      FluentRegex().literal('service').endOfLine().ignoreCase();

  String _createNameText(ClassElement serviceClassElement) =>
      PluralRules().convertToPluralNoun(
          _serviceSuffix.removeFirst(serviceClassElement.name).titleCase);

  Translatable _createDescription(ClassElement serviceClassElement) =>
      Translatable(
          key: _createDescriptionKey(serviceClassElement),
          englishText: _createDescriptionText(serviceClassElement));

  String _createDescriptionKey(ClassElement serviceClassElement) =>
      '${serviceClassElement.asLibraryMemberPath}.description';

  String _createDescriptionText(ClassElement serviceClassElement) =>
      _createNameText(serviceClassElement);
}
