import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

/// An [Item] can be a:
/// - [ApplicationInfo] Te name and description of the application
/// - [DomainClassInfo] The name and description in a list row or a form or a field
abstract class Item {
  Translatable get name;

  Translatable get description;
}

/// An [DynamicItem] can be a:
/// - [ServiceClassInfo] e.g. a main menu item
/// - [DomainObjectProperty] e.g. a form field or row
/// - [ActionMethod], e.g. a menu item
abstract class DynamicItem extends Item {
  /// Whether this item is visible
  /// Note that Items do not have an disabled state!
  /// See [https://axesslab.com/disabled-buttons-suck/] on why.
  /// Instead items are either visible or invisible
  bool get visible;

  /// Order of appearance, relative to its peers.
  /// The lower the number, the higher on the list.
  /// This number should be 100 by default when not specified.
  double get order;
}
