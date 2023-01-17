import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/item/item.dart';
import 'package:reflect_gui_builder/builder/domain/property_factory/property_widget_factory.dart';

/// Implementations of a [PropertyPresentation] class are
/// generated classes that contain [Property] information for the
/// graphical user interface.
///
/// [TYPE] examples:
/// * int: when it is a [Dart] [int] type
/// * Person: when it is a [DomainClass]
/// * List<Person>: a [Collection] of [DomainClass]es
abstract class PropertyPresentation<TYPE> extends DynamicItem {
  ClassPresentation get type;

  PropertyWidgetFactory get widgetFactory;

// TODO make TableConfig<TYPE> for a ResponsiveFlowGridTable

// TableConfig.minColumns
// TableConfig.maxColumns
// TableConfig.toolBar (widget, can be null)
// TableConfig.rowWidgetFactory (is used when all visible columns do not fit, e.g. a narrow but higher widget, default puts all must show column widgets from widgetFactories)
// TableConfig.emptyWidgetFactory (is used when there are no rows, can be null)
// TableConfig.columns

// TableColumn.header (widget, can be null)
// TableColumn.order=double
// TableColumn.span=int
// TableColumn.visible=always or never or ifFits(priority=1)
// TableColumn.widgetFactory= (default implementation for dart types int, double, string, bool, enum???, domainObject??? etc)

}
