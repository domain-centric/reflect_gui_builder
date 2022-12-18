import 'package:reflect_gui_builder/app/person/service/person_service.dart'
    as i1;

import '../builder/domain/action_method_parameter_processor/action_method_parameter_processor.dart';
import '../builder/domain/action_method_result_processor/action_method_result_processor.dart';
import '../builder/domain/property_factory/property_widget_factory.dart';
import '../builder/domain/application/application_presentation.dart';

class AcmePresentation extends ApplicationPresentation {
  @override
  List<Type> propertyWidgetFactories = [
    // TODO: Move to [ApplicationPresentation]
    StringWidgetFactory,
    IntWidgetFactory,
  ];

  @override
  List<Type> actionMethodParameterProcessors = [
    // TODO: Move to [ApplicationPresentation]
    ProcessResultDirectlyWhenThereIsNoParameter,
    EditEnumInDialog,
    EditDomainObjectParameterInForm,
    EditStringParameterInDialog,
  ];

  @override
  List<Type> actionMethodResultProcessors = [
    // TODO: Move to [ApplicationPresentation]
    ShowMethodExecutedSnackBar,
    ShowStringInDialog,
    ShowDomainObjectInReadonlyFormTab,
    ShowListInTableTab,
  ];

  @override
  List<Type> serviceClasses = [
    i1.PersonService,
  ];
}
