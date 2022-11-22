import 'package:analyzer/dart/element/element.dart';
import 'package:reflect_gui_builder/core/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/core/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/core/type/type.dart';

import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/reflection_factory.dart';
import '../type/to_string.dart';

/// Contains information on a [ServiceClass]s source code.
/// It is created by the [ServiceClassSourceFactory].
/// It is later converted to generated Dart code
/// that implements [ServiceClassReflection].
class ServiceClassSource extends ClassSource {
  final List<ActionMethodSource> actionMethods;

  ServiceClassSource(
      {required super.libraryUri,
      required super.libraryMemberPath,
      required this.actionMethods});

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
class ServiceClassSourceFactory extends SourceFactory {
  static const serviceClassesFieldName = 'serviceClasses';

  final ReflectGuiConfigSource reflectGuiConfigSource;

  ServiceClassSourceFactory(this.reflectGuiConfigSource);

  /// populates the [reflectGuiConfigSource] with created [ServiceClassSource]s
  /// and all their sub classes
  void createAndPopulate(ClassElement reflectGuiConfigElement) {
    var field = findField(reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var actionMethodSources = _createActionMethodSources(element);
      _validateServiceClassActionMethodSources(
          field, element, actionMethodSources);
      var serviceClassSource = ServiceClassSource(
          libraryUri: element.library!.source.uri,
          libraryMemberPath: element.displayName,
          actionMethods: actionMethodSources);
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

  List<ActionMethodSource> _createActionMethodSources(Element element) {
    var classElement = element as ClassElement;
    var methodElements = classElement.methods;
    var factory = ActionMethodSourceFactory(reflectGuiConfigSource);
    return factory.createAll(methodElements);
  }

  void _validateServiceClassActionMethodSources(FieldElement field,
      Element serviceClass, List<ActionMethodSource> actionMethodSources) {
    if (actionMethodSources.isEmpty) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must contain 1 or more action methods.');
    }
  }
}
