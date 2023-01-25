import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/reflect_presentation_library_builder.dart';

/// A Configuration class for a Graphical User Interface application.
/// It is used by the [ReflectPresentationLibraryBuilder] so that it knows how and which
///  [PresentationClass]es are to be generated.
abstract class ApplicationPresentation {
  /// Returns the [ValueWidgetFactory]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [StringWidgetFactory, IntWidgetFactory, ...]
  List<Type> get valueWidgetFactories;

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

  ThemeData get lightTheme =>
      ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);

  ThemeData get darkTheme =>
      ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark);
}
