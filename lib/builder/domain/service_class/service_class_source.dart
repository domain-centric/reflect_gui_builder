import 'package:analyzer/dart/element/element.dart';

import '../action_method/action_method_source.dart';
import '../domain_class/domain_class_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/reflection_factory.dart';

/// Contains information on a [ServiceClass]s source code.
/// It is created by the [ServiceClassSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ServiceClassReflection].
class ServiceClassSource extends ClassSource {
  final List<ActionMethodSource> actionMethods;

  ServiceClassSource(
      {required ClassSource serviceClass, required this.actionMethods})
      : super(
          libraryUri: serviceClass.libraryUri,
          className: serviceClass.className,
        );

  /// Finds all the [DomainClass]es that are used in all the [ActionMethod]s.
  @override
  Set<DomainClassSource> get domainClasses {
    var domainClasses = <DomainClassSource>{};
    for (var actionMethod in actionMethods) {
      domainClasses.addAll(actionMethod.domainClasses);
    }
    return domainClasses;
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

  ServiceClassSourceFactory(PopulateFactoryContext context) : super(context);

  /// populates the [reflectGuiConfigSource] with created [ServiceClassSource]s
  /// and all their sub classes
  @override
  void populateReflectGuiConfig() {
    var field = findField(reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var actionMethods = _createActionMethods(element as InterfaceElement);
      _validateServiceClassActionMethods(field, element, actionMethods);
      var serviceClassSource = ServiceClassSource(
          serviceClass: typeFactory.create(element.thisType),
          actionMethods: actionMethods);
      reflectGuiConfigSource.serviceClasses.add(serviceClassSource);
    }

    if (reflectGuiConfigSource.serviceClasses.isEmpty) {
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

  List<ActionMethodSource> _createActionMethods(InterfaceElement element) {
    var factory = ActionMethodSourceFactory(
      reflectGuiConfigSource: reflectGuiConfigSource,
      typeFactory: typeFactory,
    );
    return factory.createAll(element);
  }

  void _validateServiceClassActionMethods(FieldElement field,
      Element serviceClass, List<ActionMethodSource> actionMethodSources) {
    if (actionMethodSources.isEmpty) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must contain 1 or more action methods.');
    }
  }
}