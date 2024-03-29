import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/app/person/service/person_service.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_result_processor/action_method_result_processor.dart';
import 'package:reflect_gui_builder/builder/domain/value_widget_factory/value_widget_factory.dart';
import 'package:reflect_gui_builder/builder/domain/application_class/application_presentation.dart';

class MyFirstApp extends ApplicationPresentation {
  @override
  List<Type> valueWidgetFactories = [
    // TODO: Move to [ApplicationPresentation]
    StringWidgetFactory,
    IntWidgetFactory,
    ListWidgetFactory,
    EnumWidgetFactory,
  ];

  @override
  List<Type> actionMethodParameterProcessors = [
    // TODO: Move to [ApplicationPresentation]
    ProcessResultDirectlyWhenThereIsNoParameter,
    EditEnumInDialog,
    EditDomainObjectParameterInForm,
    EditStringParameterInDialog,
  ];

  @override
  List<Type> actionMethodResultProcessors = [
    // TODO: Move to [ApplicationPresentation]
    ShowMethodExecutedSnackBar,
    ShowStringInDialog,
    ShowDomainObjectInReadonlyFormTab,
    ShowListInTableTab,
  ];

  @override
  List<Type> serviceClasses = [
    PersonService,
  ];

var material2Light=ThemeData(primarySwatch: Colors.red, );
var material2Dark=ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark );
var material3Light=ThemeData( useMaterial3: true, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, backgroundColor: Colors.white));
var material3Dark=ThemeData( useMaterial3: true, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, backgroundColor: Colors.black, brightness: Brightness.dark));
  @override
  ThemeData get lightTheme =>material2Light;

  @override
  ThemeData get darkTheme =>
      ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark);
}
