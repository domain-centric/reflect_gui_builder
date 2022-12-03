import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/source.dart';

import '../generic/to_string.dart';
import '../generic/type_source.dart';
import '../reflect_gui/reflect_gui_source.dart';
import '../reflect_gui/source_factory.dart';

/// Contains information on a [Enum]s source code.
/// See [SourceClass]
class EnumSource extends ClassSource {
  final List<String> values;
  final List<ActionMethodSource> actionMethods;

  EnumSource({
    required super.libraryUri,
    required super.className,
    required this.values,
    required this.actionMethods,
  });

  /// [EnumSource]s are created once for each class
  /// by the [TypeSourceFactory].
  /// Therefore [EnumSource]s are equal when
  /// the [runtimeType] and [libraryMemberUri] are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryMemberSource &&
          runtimeType == EnumSource &&
          libraryMemberUri == other.libraryMemberUri;

  @override
  int get hashCode => libraryMemberPath.hashCode ^ libraryUri.hashCode;

  @override
  String toString() => ToStringBuilder(runtimeType.toString())
      .add('libraryMemberUri', libraryMemberUri)
      .add('values', values)
      .add('actionMethods', actionMethods)
      .toString();
}

/// See [SourceClassFactory]
class EnumSourceFactory extends SourceFactory {
  final FactoryContext context;

  EnumSourceFactory(this.context);

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
    var values = _enumValues(element);
    //  var actionMethods = actionMethodSourceFactory.createAll(element);

    return EnumSource(
        libraryUri: libraryUri,
        className: className,
        values: values,
        actionMethods: []); //TODO);
  }

  EnumSource? _findExistingEnum(Uri libraryUri, String className) {
    var enums = context.reflectGuiConfigSource.enums;
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
            .startsWith('package:reflect_gui_builder/builder/domain') &&
        _enumValues(element).isNotEmpty;
  }

  List<String> _enumValues(InterfaceElement element) => element.fields
      .where((field) => field.isEnumConstant)
      .map((field) => field.name)
      .toList();
}
