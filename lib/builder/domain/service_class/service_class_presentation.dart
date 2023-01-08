import 'package:reflect_gui_builder/builder/domain/action_method/action_method_presentation2.dart';
import 'package:reflect_gui_builder/builder/domain/item/item.dart';

abstract class ServiceClassPresentation<SERVICE_CLASS> implements DynamicItem {

  SERVICE_CLASS get serviceObject;

  List<ActionMethodPresentation> get actionMethods;
}
