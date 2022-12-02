import 'package:flutter/cupertino.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_result_processor/action_method_result_processor.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class.dart';

import '../generic/type_reflection.dart';
import '../item/item.dart';

/// Implementations of a [ActionMethodReflection] class are
/// generated classes that contain [ActionMethod] information for the
/// graphical user interface.
///
/// [PARAMETER_TYPE] or [RESULT_TYPE] examples:
/// * void: when there is none
/// * int: when it is a [Dart] [int] type
/// * Person: when it is a [DomainClass]
/// * List<Person>: a [Collection] of [DomainClass]es
abstract class ActionMethodReflection<PARAMETER_TYPE, RESULT_TYPE> extends DynamicItem {
  Object get methodOwner;

  /// Returns a reflection class that contains information on
  /// the [ActionMethod]s parameter type.
  /// It:
  /// * is null when there the [ActionMethod] has no parameter
  /// * it could contain information on a [DomainClass] or [Enum].
  ClassReflection? get parameterType;

  ActionMethodParameterProcessor get actionMethodParameterProcessor;

  /// Starts the [ActionMethod] process (e.g. when clicking on a menu button)
  /// It:
  /// * calls the _createParameter() method (if it exists)
  /// * and then calls the [actionMethodParameterProcessor]
  void call(BuildContext context, PARAMETER_TYPE parameter);

  /// Returns a reflection class that contains information on
  /// the [ActionMethod]s result type.
  /// It:
  /// * is null when there the [ActionMethod] has no result (void)
  /// * it could contain information on a [DomainClass] or [Enum].
  ClassReflection? get resultType;

  ActionMethodResultProcessor get resultProcessor;
}




// /// [ServiceObjectActionMethod]s are displayed on the main menu of an [ReflectGuiApplication] or are commands that can be accessed from the outside world in other type of [ReflectApplications]
// abstract class ServiceObjectActionMethodInfo extends ActionMethodInfo {
//   ServiceClassInfo get serviceObjectInfo;
// }

/// TODO explain what it does
class ActionMethodParameterFactory {}
