import 'package:flutter/material.dart';

import '../action_method/action_method.dart';
import '../action_method/action_method_reflection.dart';

/// A [ActionMethodParameterProcessor] does something with
/// [ActionMethod] parameters. E.g.:show a form to edit or view a [DomainObject]
///
/// The [ActionMethodParameterProcessor] will eventually call
/// the [ActionMethodReflection.resultProcessor] to process the method result.
///
/// [ActionMethodParameterProcessor]s are classes that:
///  - Extend [ActionMethodParameterProcessor]
///  - Are not abstract
///  - Have a public const unnamed constructor without parameters
///
///  [ActionMethodParameterProcessor]s are configured in the [ReflectGuiConfig]
///  These will be used to generate [ActionMethodSource] classes.
///
abstract class ActionMethodParameterProcessor<PARAMETER_TYPE> {
  const ActionMethodParameterProcessor();

  /// Default icon if any
  IconData? get defaultIcon;

  void process(
    BuildContext context,
    ActionMethodReflection actionMethod,
    PARAMETER_TYPE actionMethodParameter,
  );
}

class EditDomainObjectParameterInForm
    extends ActionMethodParameterProcessor<Object> {
  const EditDomainObjectParameterInForm();

  @override
  IconData? get defaultIcon => Icons.table_rows_sharp;

  @override
  void process(Object context, ActionMethodReflection actionMethod,
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
  void process(
    BuildContext context,
    ActionMethodReflection actionMethod,
    void actionMethodParameter,
  ) {
    actionMethod.resultProcessor.process(context, actionMethod, null);
  }
}

//TODO other Dart types such as int, double,num, bool, DateTime
class EditStringParameterInDialog
    extends ActionMethodParameterProcessor<String> {
  const EditStringParameterInDialog();

  @override
  IconData? get defaultIcon => Icons.crop_7_5;

  @override
  void process(
    BuildContext context,
    ActionMethodReflection actionMethod,
    String actionMethodParameter,
  ) {
    // TODO create and open dialog
    //TODO put in dialog OK button:
    //actionMethod.invokeMethodAndProcessResult(context, string);
  }
}

// TODO class ExecuteDirectlyForMethodsWithProcessDirectlyAnnotation(
//     BuildContext context, InvokeWithParameter actionMethod, Object anyObject) {
//   actionMethod.invokeMethodAndProcessResult(context, anyObject);
// }