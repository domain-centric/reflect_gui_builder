import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/item/item.dart';
import 'package:reflect_gui_builder/builder/domain/property_factory/property_widget_factory_source.dart';


/// Implementations of a [PropertyPresentation] class are
/// generated classes that contain [Property] information for the
/// graphical user interface.
///
/// [TYPE] examples:
/// * int: when it is a [Dart] [int] type
/// * Person: when it is a [DomainClass]
/// * List<Person>: a [Collection] of [DomainClass]es
abstract class PropertyPresentation<TYPE>
    extends DynamicItem {

  ClassPresentation get type;

  PropertyWidgetFactorySource get widgetFactory;

}
