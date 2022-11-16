import 'package:flutter/widgets.dart';
import 'package:reflect_gui_builder/core/reflect_gui/reflect_gui_config.dart';

import '../action_method/action_method.dart';


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
///  These will be used to generate [ActionMethodReflection] classes.
///
abstract class ActionMethodParameterProcessor<T> {
  const ActionMethodParameterProcessor();

  void call(BuildContext context, InvokeWithParameter actionMethod, T actionMethodParameter);
}

class EditDomainObjectParameterInForm extends ActionMethodParameterProcessor<Object> {

  const EditDomainObjectParameterInForm();

  @override
  void call(Object context, InvokeWithParameter actionMethod, Object actionMethodParameter) {
    // Tabs tabs = Provider.of<Tabs>(context, listen: false);
//   FormExampleTab formTab = FormExampleTab(actionMethod);
//   tabs.add(formTab);
//
//   //TODO put in form OK button:  actionMethod.invokeMethodAndProcessResult(context, domainObject);
  }

}

// OLD:
// @ActionMethodParameterProcessor(
//     index: 102) //, defaultIcon: Icons.table_chart_sharp)
// void editDomainObjectParameterInForm(BuildContext context,
//     InvokeWithParameter actionMethod, @DomainClass() Object domainObject) {
//   Tabs tabs = Provider.of<Tabs>(context, listen: false);
//   FormExampleTab formTab = FormExampleTab(actionMethod);
//   tabs.add(formTab);
//
//   //TODO put in form OK button:  actionMethod.invokeMethodAndProcessResult(context, domainObject);
// }
//
// //TODO other Dart types such as int, double,num, bool, DateTime
// @ActionMethodParameterProcessor(index: 103) //, defaultIcon: Icons.crop_7_5)
// void editStringParameterInDialog(
//     BuildContext context, InvokeWithParameter actionMethod, String string) {
//   // TODO create and open dialog
//
//   //TODO put in dialog OK button:
//   actionMethod.invokeMethodAndProcessResult(context, string);
// }
//
// @ActionMethodParameterProcessor(
//     index: 150) //, requiredAnnotations: [ExecutionMode.directly])
// void executeDirectlyForMethodsWithProcessDirectlyAnnotation(
//     BuildContext context, InvokeWithParameter actionMethod, Object anyObject) {
//   actionMethod.invokeMethodAndProcessResult(context, anyObject);
// }