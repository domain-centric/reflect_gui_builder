import 'package:flutter/cupertino.dart';
import 'package:reflect_gui_builder/core/item/item.dart';

import '../domain_class/domain_class_source.dart';

/// Implementations of a [ActionMethodReflection] class are
/// generated classes that contain [ActionMethod] information for the
/// graphical user interface.
abstract class ActionMethodReflection extends DynamicItem {
  Object get methodOwner;

  /// Returns a DomainClassReflection if the [ActionMethod] parameter type
  /// contains a [DomainClass]
  DomainClassSource? get parameterDomainReflection;

  /// Returns a DomainClassReflection if the [ActionMethod] result type
  /// contains a [DomainClass]
  DomainClassSource? get resultDomainReflection;
}

abstract class StartWithoutParameter implements ActionMethodReflection {
  /// Starts the ActionMethod process (e.g. when clicking on a menu button)
  /// This is implemented on a [ActionMethodInfoWithoutParameter] or
  /// [ActionMethodInfoWithParameter] and there is an parameter factory
  /// It:
  /// - calls the _createParameter() method (if it exists)
  /// - and then calls the _processParameter() method if it has a parameter
  /// - finally it will call invokeMethodAndProcessResult()
  void start(BuildContext context);
}

abstract class StartWithParameter<T> implements ActionMethodReflection {
  /// Starts the ActionMethod process (e.g. when clicking on a menu button)
  /// This is implemented on a ActionMethodInfoWithParameter
  /// It:
  /// - calls the _processParameter() method
  void start(BuildContext context, T parameter);
}

abstract class InvokeWithoutParameter implements ActionMethodReflection {
  /// This method is only called by [ActionMethodSource.start]
  void invokeMethodAndProcessResult(BuildContext context);
}

abstract class InvokeWithParameter<T> implements ActionMethodReflection {
  /// This method should only be called by a [ActionMethodParameterProcessor]
  /// (which might be delegated to a form ok or a dialog ok button)
  /// It:
  /// - invokes the method
  /// - and then calls the [ActionMethodResultProcessor] to process the results
  /// - it will handle any exceptions that could be thrown
  void invokeMethodAndProcessResult(BuildContext context, T parameter);
}

// /// [ServiceObjectActionMethod]s are displayed on the main menu of an [ReflectGuiApplication] or are commands that can be accessed from the outside world in other type of [ReflectApplications]
// abstract class ServiceObjectActionMethodInfo extends ActionMethodInfo {
//   ServiceClassInfo get serviceObjectInfo;
// }

/// TODO explain what it does
class ActionMethodParameterFactory {}
