import 'package:flutter/material.dart';

import 'package:reflect_gui_builder/builder/domain/action_method/action_method.dart';
import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation.dart';

const dialogIcon = Icons.crop_7_5;
const formIcon = Icons.table_rows_sharp;

/// A [ActionMethodParameterProcessor] does something with
/// [ActionMethod] parameters. E.g.:show a form to edit or view a [DomainObject]
///
/// The [ActionMethodParameterProcessor] will eventually call
/// the [ActionMethodPresentation.resultProcessor] to process the method result.
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
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod,
    PARAMETER_TYPE actionMethodParameter,
  );
}

class EditEnumInDialog extends ActionMethodParameterProcessor<Enum> {
  const EditEnumInDialog();

  @override
  IconData? get defaultIcon => dialogIcon;

  @override
  void process(
    Object context,
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod,
    Object actionMethodParameter,
  ) {
    //TODO put in form OK button:  actionMethod.resultProcessor.process(context, enumValue);
  }
}

class EditDomainObjectParameterInForm
    extends ActionMethodParameterProcessor<Object> {
  const EditDomainObjectParameterInForm();

  @override
  IconData? get defaultIcon => formIcon;

  @override
  void process(
    Object context,
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod,
    Object actionMethodParameter,
  ) {
    // Tabs tabs = Provider.of<Tabs>(context, listen: false);
    //   FormExampleTab formTab = FormExampleTab(actionMethod);
    //   tabs.add(formTab);
    //TODO put in form OK button:  actionMethod.resultProcessor.process(context, domainObject);
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
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod,
    void actionMethodParameter,
  ) {
    actionMethod.resultProcessor
        .process(context, actionMethodOwner, actionMethod);
  }
}

//TODO other Dart types such as int, double,num, bool, DateTime
class EditStringParameterInDialog
    extends ActionMethodParameterProcessor<String> {
  const EditStringParameterInDialog();

  @override
  IconData? get defaultIcon => dialogIcon;

  @override
  void process(
    BuildContext context,
    Object actionMethodOwner,
    ActionMethodPresentation actionMethod,
    String actionMethodParameter,
  ) {
    // TODO create and open dialog
    //TODO put in dialog OK button: actionMethod..resultProcessor.process(context, string)
  }
}

// TODO class ExecuteDirectlyForMethodsWithProcessDirectlyAnnotation(
//     BuildContext context, InvokeWithParameter actionMethod, Object anyObject) {
//   actionMethod.invokeMethodAndProcessResult(context, anyObject);
// }
