import 'package:flutter/material.dart';

import '../action_method/action_method.dart';
import '../action_method/action_method_reflection.dart';

/// A [ActionMethodParameterProcessor] does something with
/// [ActionMethod] parameters, for a given method parameter signature,
/// before the [ActionMethodResultProcessor] is called to process the
/// method result.
///
/// [ActionMethodParameterProcessor]s are classes that:
///  - Extend [ActionMethodParameterProcessor]
///  - Are not abstract
///  - Have a public const unnamed constructor without parameters
///
///  [ActionMethodParameterProcessor]s are configured in the [ReflectGuiConfig]
///  These will be used to generate [ActionMethodSource] classes.
///
abstract class ActionMethodParameterProcessor<T> {
  const ActionMethodParameterProcessor();

  /// Default icon if any
  IconData? get defaultIcon;

  void call(BuildContext context, InvokeWithParameter actionMethod,
      T actionMethodParameter);
}

class EditDomainObjectParameterInForm
    extends ActionMethodParameterProcessor<Object> {
  const EditDomainObjectParameterInForm();

  @override
  IconData? get defaultIcon => Icons.table_rows_sharp;

  @override
  void call(Object context, InvokeWithParameter actionMethod,
      Object actionMethodParameter) {
    // Tabs tabs = Provider.of<Tabs>(context, listen: false);
    //   FormExampleTab formTab = FormExampleTab(actionMethod);
    //   tabs.add(formTab);
    //TODO put in form OK button:  actionMethod.invokeMethodAndProcessResult(context, domainObject);
  }
}

class ProcessResultDirectlyWhenThereIsNoParameter
    extends ActionMethodParameterProcessor<void> {
  const ProcessResultDirectlyWhenThereIsNoParameter();

  @override
  IconData? get defaultIcon => null;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      void actionMethodParameter) {
    actionMethod.invokeMethodAndProcessResult(context, null);
  }
}

//TODO other Dart types such as int, double,num, bool, DateTime
class EditStringParameterInDialog
    extends ActionMethodParameterProcessor<String> {
  const EditStringParameterInDialog();

  @override
  IconData? get defaultIcon => Icons.crop_7_5;

  @override
  void call(BuildContext context, InvokeWithParameter actionMethod,
      String actionMethodParameter) {
    // TODO create and open dialog
    //TODO put in dialog OK button:
    //actionMethod.invokeMethodAndProcessResult(context, string);
  }
}

// TODO class ExecuteDirectlyForMethodsWithProcessDirectlyAnnotation(
//     BuildContext context, InvokeWithParameter actionMethod, Object anyObject) {
//   actionMethod.invokeMethodAndProcessResult(context, anyObject);
// }
