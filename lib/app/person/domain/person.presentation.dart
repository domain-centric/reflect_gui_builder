import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart'
    as i1;
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart'
    as i2;
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart'
    as i3;

/// Do not make changes to this file!
/// This file is generated by: ReflectPresentationLibraryBuilder
/// On: 2023-01-08 16:32:45.448347
/// From: package:reflect_gui_builder/app/person/domain/person.dart
/// Generate command: dart run build_runner build --delete-conflicting-outputs
/// For more information see: TODO
class $PersonPresentation extends i1.DomainClassPresentation {
  @override
  final name = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.name',
      englishText: 'Person');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.description',
      englishText: 'Person');
  var name;
  var gender;
  var id;
  var eMailAddresses;
  @override
  List<i3.PropertyPresentation> get properties =>
      [name, gender, id, eMailAddresses];
}
