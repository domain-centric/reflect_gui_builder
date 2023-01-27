import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/app/my_first_app.presentation.dart';
import 'package:reflect_gui_builder/app/person/service/person_service.dart'
    as i1;
import 'package:reflect_gui_builder/gui/gui.dart';

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
    i1.PersonService,
  ];

  @override
  ThemeData get lightTheme =>
      ThemeData(primarySwatch: Colors.red, brightness: Brightness.light);

  @override
  ThemeData get darkTheme =>
      ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark);
}
