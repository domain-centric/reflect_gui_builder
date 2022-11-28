import 'package:reflect_gui_builder/app/person/service/person_service.dart'
    as i1;

import '../builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';
import '../builder/domain/action_method_result_processor/action_method_result_processor.dart';
import '../builder/domain/property_factory/property_widget_factory.dart';
import '../builder/domain/reflect_gui/reflect_gui_config.dart';

class MyApplicationConfig extends ReflectGuiConfig {
  /// Returns the [PropertyWidgetFactory]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [StringWidgetFactory, IntWidgetFactory, ...]
  /// TODO: Move to [ReflectGuiConfig]
  List<Type> propertyWidgetFactories = [
    StringWidgetFactory,
    IntWidgetFactory,
  ];

  /// Returns the [ActionMethodParameterProcessor]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [EditDomainObjectParameterInForm, EditStringParameterInDialog, ...]
  /// TODO: Move to [ReflectGuiConfig]
  List<Type> actionMethodParameterProcessors = [
    ProcessResultDirectlyWhenThereIsNoParameter,
    EditDomainObjectParameterInForm,
    EditStringParameterInDialog,
  ];

  /// Returns the [ActionMethodResultProcessor]s that are to be used in the application.
  /// The order is the order of processing (order of importance)!
  /// This must be a literal [List] without logic.
  /// e.g.: [ShowMethodExecutedSnackBar, ShowStringInDialog]
  /// TODO: Move to [ReflectGuiConfig]
  List<Type> actionMethodResultProcessors = [
    ShowMethodExecutedSnackBar,
    ShowStringInDialog,
    ShowDomainObjectInReadonlyFormTab,
    ShowListInTableTab,
  ];

  /// Define the [ServiceClass]es that are to be used in the application.
  /// This must be a literal [List] without logic.
  /// e.g.: [ProductService, ShoppingCartService]
  /// TODO: Move to [ReflectGuiConfig]
  List<Type> serviceClasses = [
    i1.PersonService,
  ];
//TODO 1 can we use analyzer to find the PersonService class and what if it is in another package or returns a DelagatingList?
//TODO 2  what if it is in another package
// TODO 3 what if it  returns a Delegating List?
}
