import 'package:reflect_gui_builder/builder/domain/application/generated_application_presentation.dart'
    as i1;
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart'
    as i2;
import 'package:reflect_gui_builder/app/person/service/person_service_presentation.dart'
    as i3;

/// Do not make changes to this file!
/// This file is generated by: ReflectPresentationLibraryBuilder
/// On: 2023-01-03 12:29:37.781549
/// From: package:reflect_gui_builder/app/my_first_app.dart
/// Generate command: dart run build_runner build --delete-conflicting-outputs
/// For more information see: TODO
class $MyFirstAppPresentation extends i1.GeneratedApplicationPresentation {
  @override
  final name = i2.Translatable(
      key: 'package:reflect_gui_builder/app/my_first_app.dart/MyFirstApp.name',
      englishText: 'My First App');
  @override
  final description = i2.Translatable(
      key:
          'package:reflect_gui_builder/app/my_first_app.dart/MyFirstApp.description',
      englishText: 'Generates Reflect Graphical User Interface Code');
  @override
  final version = '1.0.0+1';
  @override
  final titleImagePath = 'assets/my_first_app.png';
  @override
  final documentation = null;
  @override
  final homePage = null;
  @override
  final serviceClasses = [i3.$PersonServicePresentation()];
}
