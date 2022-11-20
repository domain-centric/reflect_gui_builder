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
  final List<ActionMethodSource> actionMethodSources;

  ServiceClassSource(
      {required super.libraryUri,
      required super.name,
      required this.actionMethodSources});

  @override
  String toString() {
    return ToStringBuilder('$ServiceClassSource')
        .add('libraryMemberUri', libraryMemberUri)
        .add('actionMethodSources', actionMethodSources)
        .toString();
  }
}

/// Creates a list of [ServiceClassSource]s by using the
/// analyzer package
class ServiceClassSourceFactory extends SourceFactory {
  static const serviceClassesFieldName = 'serviceClasses';

  final ReflectGuiConfigSource reflectGuiConfigSource;

  ServiceClassSourceFactory(this.reflectGuiConfigSource);

  /// populates the [reflectGuiConfigSource] with [ServiceClassSource] and
  /// [DomainClassSource] with all their sub classes
  void populateWith(ClassElement reflectGuiConfigElement) {
    var field = findField(reflectGuiConfigElement, serviceClassesFieldName);

    var elements = findInitializerElements(field);
    for (var element in elements) {
      _validateServiceClassElement(field, element);
      var actionMethodSources = _createActionMethodSources(element);
      _validateServiceClassActionMethodSources(
          field, element, actionMethodSources);
      var serviceClassSource = ServiceClassSource(
          name: element.displayName,
          libraryUri: element.library!.source.uri,
          actionMethodSources: actionMethodSources);
      reflectGuiConfigSource.serviceClassSources.add(serviceClassSource);
    }

    if (reflectGuiConfigSource.serviceClassSources.isEmpty) {
      throw Exception('${field.asLibraryMemberPath}: may not be empty!');
    }
  }

  void _validateServiceClassElement(FieldElement field, Element serviceClass) {
    if (serviceClass is! ClassElement) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be a class.');
    }
    if (!serviceClass.isPublic) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be public.');
    }
    if (serviceClass.isAbstract) {
      throw ('${field.asLibraryMemberPath}: $serviceClass may not be abstract.');
    }
    if (!hasNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: $serviceClass does not have a nameless constructor without parameters.');
    }
    if (!hasConstNamelessConstructorWithoutParameters(serviceClass)) {
      throw ('${field.asLibraryMemberPath}: $serviceClass must be immutable and therefore must have a constant constructor.');
    }
  }

  List<ActionMethodSource> _createActionMethodSources(Element element) {
    var classElement = element as ClassElement;
    var methodElements = classElement.methods;
    var factory = ActionMethodSourceFactory(reflectGuiConfigSource);
    var sources = <ActionMethodSource>[];
    for (var methodElement in methodElements) {
      if (factory.isActionMethod(methodElement)) {
        var source = factory.create(methodElement);
        sources.add(source);
      }
    }
    return sources;
    //
  }

  void _validateServiceClassActionMethodSources(FieldElement field,
      Element serviceClass, List<ActionMethodSource> actionMethodSources) {
    if (actionMethodSources.isEmpty) {
      throw ('${field.asLibraryMemberPath}: ${serviceClass.asLibraryMemberPath} must contain 1 or more action methods.');
    }
  }
}
