import 'package:flutter/cupertino.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';

/// See [PresentationClass]
abstract class ApplicationPresentation2 {
  Translatable get name;
  Translatable get description;
  IconData get icon;
  Image get titleImage;

  //List<ServiceClassPresentation> get serviceClasses;
}
