import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_presentation.dart'
    as i1;
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart'
    as i2;
import 'package:reflect_gui_builder/builder/domain/domain_class/property/property_presentation.dart'
    as i3;
import 'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart'
    as i4;

/// Do not make changes to this file!
/// This file is generated by: ReflectPresentationLibraryBuilder
/// On: 2023-01-11 13:05:59.914755
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
  @override
  List<i3.PropertyPresentation> get properties => [
        $PersonNamePresentation(),
        $PersonGenderPresentation(),
        $PersonIdPresentation(),
        $PersonEMailAddressesPresentation()
      ];
}

class $PersonNamePresentation extends i3.PropertyPresentation {
  @override
  final name = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.name.name',
      englishText: 'Name');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.name.description',
      englishText: 'Name');
  @override
  final order = 100;
  @override
  final visible = true;
  @override
  final type =
      i4.ClassPresentation(libraryUri: 'dart:core', className: 'String');
}

class $PersonGenderPresentation extends i3.PropertyPresentation {
  @override
  final name = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.gender.name',
      englishText: 'Gender');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.gender.description',
      englishText: 'Gender');
  @override
  final order = 200;
  @override
  final visible = true;
  @override
  final type =
      i4.ClassPresentation(libraryUri: 'dart:core', className: 'String');
}

class $PersonIdPresentation extends i3.PropertyPresentation {
  @override
  final name = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.id.name',
      englishText: 'Id');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.id.description',
      englishText: 'Id');
  @override
  final order = 300;
  @override
  final visible = true;
  @override
  final type =
      i4.ClassPresentation(libraryUri: 'dart:core', className: 'String');
}

class $PersonEMailAddressesPresentation extends i3.PropertyPresentation {
  @override
  final name = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.eMailAddresses.name',
      englishText: 'E mail addresses');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/person/domain/person.dart/Person.eMailAddresses.description',
      englishText: 'E mail addresses');
  @override
  final order = 400;
  @override
  final visible = true;
  @override
  final type =
      i4.ClassPresentation(libraryUri: 'dart:core', className: 'String');
}
