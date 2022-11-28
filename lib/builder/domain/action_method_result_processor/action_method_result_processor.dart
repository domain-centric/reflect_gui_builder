import 'package:flutter/material.dart';

import '../action_method/action_method.dart';
import '../action_method/action_method_reflection.dart';

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
abstract class ActionMethodResultProcessor<T> {
  const ActionMethodResultProcessor();

  /// Default icon if any
  IconData? get defaultIcon;

  ///  Call's the action method (with or without parameter) and shows
  ///  the result in the user interface.
  ///  There will be multiple implementations for different result types [T].
  void call(BuildContext context, InvokeWithParameter actionMethod,
      T actionMethodResult);
}

class ShowMethodExecutedSnackBar extends ActionMethodResultProcessor<void> {
  const ShowMethodExecutedSnackBar();

  @override
  IconData? get defaultIcon => null;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      void actionMethodResult) {
    // TODO: implement call
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //         '${actionMethodInfo.name} has executed successfully.'), //TODO make multilingual
    //   ),
    // );
  }
}

//TODO show other dart types in dialog, e.g. int, double, num, date/time
class ShowStringInDialog extends ActionMethodResultProcessor<String> {
  const ShowStringInDialog();

  @override
  IconData? get defaultIcon => Icons.crop_7_5;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      void actionMethodResult) {
    // TODO: implement
  }
}

class ShowDomainObjectInReadonlyFormTab extends ActionMethodResultProcessor<

    /// By convention the object type is special. It only represents [Object]s
    /// that are recognized as [DomainObject]s
    Object> {
  const ShowDomainObjectInReadonlyFormTab();

  @override
  IconData? get defaultIcon => Icons.table_rows_sharp;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      Object actionMethodResult) {
    // TODO: implement call
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
  IconData? get defaultIcon => Icons.table_chart_sharp;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      List<Object> actionMethodResult) {
    // TODO: implement call
    /// TODO: use [ActionMethodReflection.resultDomainReflection]
    // var tabs = Provider.of<Tabs>(context, listen: false);
    // var tableTab = TableExampleTab(actionMethodInfo); // TODO pass collection
    // tabs.add(tableTab);
  }
}
