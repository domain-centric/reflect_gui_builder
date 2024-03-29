import 'package:flutter/material.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';
import 'package:reflect_gui_builder/builder/domain/action_method_result_processor/action_method_result_processor.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class.dart';

import '../generic/type_presentation.dart';
import '../item/item.dart';

/// Implementations of a [ActionMethodPresentation] class are
/// generated classes that contain [ActionMethod] information for the
/// graphical user interface.
///
/// [PARAMETER_TYPE] or [RESULT_TYPE] examples:
/// * void: when there is none
/// * int: when it is a [Dart] [int] type
/// * Person: when it is a [DomainClass]
/// * List<Person>: a [Collection] of [DomainClass]es
abstract class ActionMethodPresentation<RESULT_TYPE, PARAMETER_TYPE>
    extends DynamicItem {
  IconData get icon;

  /// Returns information on the [ActionMethod]s parameter type.
  /// It:
  /// * is null when the [ActionMethod] has no parameter
  /// * otherwise it is a [ClassPresentation] representing the type,
  ///   potentially with presentation information on a [DomainClass] or [Enum].
  ClassPresentation? get parameterType => null;

  ActionMethodParameterProcessor<PARAMETER_TYPE> get parameterProcessor;

  /// returns a optional function that can create a parameter
  PARAMETER_TYPE Function()? parameterFactory;

  // /// Starts the [ActionMethod] process (e.g. when clicking on a menu button)
  // /// It:
  // /// * calls the _createParameter() method (if it exists)
  // /// * and then calls the [actionMethodParameterProcessor]
  // void call(BuildContext context, PARAMETER_TYPE parameter);

  /// Returns information on the [ActionMethod]s result type.
  /// It:
  /// * is null when the [ActionMethod] has no result (void)
  /// * otherwise it is a [ClassPresentation] representing the type,
  ///   potentially with presentation information on a [DomainClass] or [Enum].
  ClassPresentation? get resultType => null;

  ActionMethodResultProcessor<RESULT_TYPE> get resultProcessor;

  /// parameterType    parameterFactory  parameter needed
  ///   null              null                false
  ///   null              !null               false
  ///   !null             null                true
  ///   !null             !null               false
  bool get parameterNeeded => parameterType != null && parameterFactory == null;

  /// TODO final ExecutionMode executionMode

  /// TODO final PARAMETER_TYPE? Function() parameterFactoryFunction
}
