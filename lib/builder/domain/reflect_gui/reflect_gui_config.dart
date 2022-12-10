import 'package:reflect_gui_builder/builder/reflect_gui_config_builder.dart';

/// A Configuration class for a Graphical User Interface application.
/// It is used by the [ReflectGuiConfigBuilder] so that it knows how and which
///  [Presentation] classes are to be generated.
abstract class ReflectGuiConfig {
  /// Returns the [PropertyWidgetFactory]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [StringWidgetFactory, IntWidgetFactory, ...]
  List<Type> get propertyWidgetFactories;

  /// Returns the [ActionMethodParameterProcessor]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [EditDomainObjectParameterInForm, EditStringParameterInDialog, ...]
  List<Type> get actionMethodParameterProcessors;

  /// Returns the [ActionMethodResultProcessor]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [ShowMethodExecutedSnackBar, ShowStringInDialog]
  List<Type> get actionMethodResultProcessors;

  /// Returns the [ServiceClass]es that are to be used in the application.
  /// This must be a literal [List] without logic.
  /// e.g.: [ProductService, ShoppingCartService]
  List<Type> get serviceClasses;
}
