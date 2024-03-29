import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reflect_gui_builder/builder/domain/action_method/action_method.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';
import 'package:reflect_gui_builder/gui/gui_tab.dart';
import 'package:reflect_gui_builder/gui/gui_tab_table.dart';

const dialogIcon = Icons.crop_7_5;
const formIcon = Icons.table_rows_sharp;
const tableIcon = Icons.table_chart_sharp;

/// A [ActionMethodResultProcessor] processes the [ActionMethod] results
/// (e.g. displays the results to the user or sends back an reply)
///
///  [ActionMethodResultProcessor]s are classes that:
///  - Extend [ActionMethodResultProcessor]
///  - Are not abstract
///  - Have a public const unnamed constructor without parameters
///
///  [ActionMethodResultProcessor]s are configured in the [ReflectGuiConfig]
///  These will be used to generate [ActionMethodSource] classes.
abstract class ActionMethodResultProcessor<RESULT_TYPE> {
  const ActionMethodResultProcessor();

  /// Default icon if any
  IconData? get defaultIcon;

  ///  Call's the action method (with or without parameter) and shows
  ///  the result in the user interface.
  ///  There will be multiple implementations for different result types [RESULT_TYPE].
  void process(
    BuildContext context,
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod, [
    Object? actionMethodParameter,
  ]);
}

class ShowMethodExecutedSnackBar extends ActionMethodResultProcessor<void> {
  const ShowMethodExecutedSnackBar();

  @override
  IconData? get defaultIcon => null;

  @override
  void process(BuildContext context, Object actionMethodOwner,
      ActionMethodPresentation actionMethod,
      [Object? actionMethodParameter]) {
    // TODO: implement process
  }
}

//TODO show other dart types in dialog, e.g. int, double, num, date/time
class ShowStringInDialog extends ActionMethodResultProcessor<String> {
  const ShowStringInDialog();

  @override
  IconData? get defaultIcon => dialogIcon;

  @override
  void process(BuildContext context, Object actionMethodOwner,
      ActionMethodPresentation actionMethod,
      [Object? actionMethodParameter]) {
    // TODO: implement process
  }
}

class ShowDomainObjectInReadonlyFormTab extends ActionMethodResultProcessor<

    /// By convention the object type is special. It only represents [Object]s
    /// that are recognized as [DomainObject]s
    Object> {
  const ShowDomainObjectInReadonlyFormTab();

  @override
  IconData? get defaultIcon => formIcon;

  @override
  void process(BuildContext context, Object actionMethodOwner,
      ActionMethodPresentation actionMethod,
      [Object? actionMethodParameter]) {
    /// TODO: use [ActionMethodReflection.resultDomainReflection]
    // var tabs = Provider.of<Tabs>(context, listen: false);
    // var formTab =
    // FormExampleTab(actionMethodInfo); //TODO readonly + pass domain object
    // tabs.add(formTab);
  }
}

class ShowListInTableTab extends ActionMethodResultProcessor<
    List<

        /// By convention the object type is special. It only represents [Object]s
        /// that are recognized as [DomainObject]s
        Object>> {
  const ShowListInTableTab();

  @override
  IconData? get defaultIcon => tableIcon;

  @override
  void process(BuildContext context, Object actionMethodOwner,
      ActionMethodPresentation actionMethod,
      [Object? actionMethodParameter]) {
    // TODO: implement call
    /// TODO: use [ActionMethodReflection.resultDomainReflection]
    var tabs = Provider.of<Tabs>(context, listen: false);
    var tableTab = TableExampleTab(actionMethod); // TODO pass collection
    tabs.add(tableTab);
  }
}
