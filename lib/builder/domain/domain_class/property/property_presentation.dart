import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/item/item.dart';
import 'package:reflect_gui_builder/builder/domain/property_factory/property_widget_factory_source.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';


/// Implementations of a [PropertyPresentation] class are
/// generated classes that contain [Property] information for the
/// graphical user interface.
///
/// [TYPE] examples:
/// * int: when it is a [Dart] [int] type
/// * Person: when it is a [DomainClass]
/// * List<Person>: a [Collection] of [DomainClass]es
class PropertyPresentation<TYPE>
    extends DynamicItem {
  @override
  final Translatable name;

  @override
  final Translatable description;

  @override
  final bool visible;

  @override
  final double order;

  final ClassPresentation type;

  final PropertyWidgetFactorySource widgetFactory;

  PropertyPresentation({
    required this.name,
    required this.description,
    required this.visible,
    required this.order,
    required this.type,
    required this.widgetFactory,
  });

}
