import 'package:analyzer/dart/element/element.dart';

import '../action_method/action_method_source.dart';
import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/source_factory.dart';

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

  final FactoryContext context;
  ServiceClassSourceFactory(this.context);

  /// populates the [reflectGuiConfigSource] with created [ServiceClassSource]s
  /// and all their sub classes
  @override
  void populateReflectGuiConfig() {
    var field =
        findField(context.reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var actionMethods = context.actionMethodSourceFactory
          .createAll(element as InterfaceElement);
      _validateServiceClassActionMethods(field, element, actionMethods);
      var serviceClassSource = ServiceClassSource(
          serviceClass: context.typeFactory.create(element.thisType),
          actionMethods: actionMethods);
      context.reflectGuiConfigSource.serviceClasses.add(serviceClassSource);
    }

    if (context.reflectGuiConfigSource.serviceClasses.isEmpty) {
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
}
