import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/to_string.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/application_class/application_presentation_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source_factory.dart';

/// Contains information on a [Enum] source code.
/// See [SourceClass]
class EnumSource extends ClassSource {
  final Map<String, Translatable> names;
  final Map<String, Translatable> descriptions;
  final List<ActionMethodSource> actionMethods;

  EnumSource({
    required super.libraryUri,
    required super.className,
    required this.names,
    required this.descriptions,
    required this.actionMethods,
  });

  @override
  String toString() => ToStringBuilder(runtimeType.toString())
      .add('libraryMemberUri', libraryMemberUri)
      .add('genericTypes', genericTypes)
      .add('names', names)
      .add('descriptions', descriptions)
      .add('actionMethods', actionMethods)
      .toString();

  /// [EnumSource]s are created once for each class
  /// by the [TypeSourceFactory].
  /// Therefore [EnumSource]s are equal when
  /// the [runtimeType] and [libraryMemberUri] compare
  /// because other fields will be the identical.

  /// Finds all the [ClassSource]s that are used in this [ActionMethod].
  /// It will also get [ClassSource]s used inside the
  /// DomainClass [ActionMethod]s and the [ActionMethod]s inside its [Property]s
  ///
  /// TODO: Be aware for never ending round trips.
  @override
  Set<ClassSource> get usedTypes {
    var usedTypes = <ClassSource>{};
    usedTypes.add(this);
    for (var actionMethod in actionMethods) {
      usedTypes.addAll(actionMethod.usedTypes);
    }
    return usedTypes;
  }
}

/// See [SourceClassFactory]
class EnumSourceFactory extends SourceFactory {
  final SourceContext context;
  final ActionMethodSourceFactory actionMethodSourceFactory;

  EnumSourceFactory(this.context)
      : actionMethodSourceFactory = ActionMethodSourceFactory(context);

  /// Creates a [EnumSource] if it is a [Enum]. Note that it will
  /// return an existing [EnumSource] if one was already created.
  EnumSource? create(InterfaceElement element) {
    if (!_isSupportedEnum(element)) {
      return null;
    }
    var libraryUri = TypeSourceFactory.libraryUri(element);
    var className = TypeSourceFactory.className(element);

    var existingEnum = _findExistingEnum(libraryUri, className);
    if (existingEnum != null) {
      return existingEnum;
    }

    element as EnumElement;

    var actionMethods = actionMethodSourceFactory.createAll(element);

    return EnumSource(
      libraryUri: libraryUri,
      className: className,
      names: _createNames(element),
      descriptions: _createDescriptions(element),
      actionMethods: actionMethods,
    );
  }

  EnumSource? _findExistingEnum(String libraryUri, String className) {
    var enums = context.application.enumClasses;
    var existingEnum = enums.firstWhereOrNull((enumSource) =>
        enumSource.libraryUri == libraryUri &&
        enumSource.libraryMemberPath == className);
    return existingEnum;
  }

  bool _isSupportedEnum(Element element) {
    return element is EnumElement &&
        element.isPublic &&
        !element.asLibraryMemberPath.startsWith('dart:') &&
        !element.asLibraryMemberPath
            .startsWith('package:reflect_gui_builder/builder/domain');
  }

  Map<String, Translatable> _createNames(EnumElement enumElement) => {
        for (var field in _enumValueFields(enumElement))
          field.name: Translatable(
              key: _createNameKey(field), englishText: _createNameText(field))
      };

  String _createNameKey(FieldElement fieldElement) =>
      '${fieldElement.asLibraryMemberPath}.name';

  String _createNameText(FieldElement fieldElement) =>
      fieldElement.name.titleCase;

  Map<String, Translatable> _createDescriptions(EnumElement enumElement) => {
        for (var field in _enumValueFields(enumElement))
          field.name: Translatable(
              key: _createDescriptionKey(field),
              englishText: _createDescriptionText(field))
      };

  Iterable<FieldElement> _enumValueFields(EnumElement enumElement) =>
      enumElement.fields.whereNot((field) => field.name == 'values');

  String _createDescriptionKey(FieldElement fieldElement) =>
      '${fieldElement.asLibraryMemberPath}.description';

  String _createDescriptionText(FieldElement fieldElement) =>
      _createNameText(fieldElement);
}
