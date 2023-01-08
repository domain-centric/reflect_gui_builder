import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_source.dart';

class PropertyPresentationFactory {
  Field create(PropertySource property, int order) =>Field(property.propertyName);//TODO
  
}


class PropertyPresentationType extends Type {
  PropertyPresentationType()
      : super('PropertyPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart');
}