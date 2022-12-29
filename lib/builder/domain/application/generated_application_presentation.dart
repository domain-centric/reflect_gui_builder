import 'package:reflect_gui_builder/builder/domain/application/application_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/generic/presentation.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_presentation.dart';
import 'package:reflect_gui_builder/builder/domain/translation/translatable.dart';


/// Implementations of [GeneratedApplicationPresentation] are generated from the
/// projects source code. It contains all the needed presentation information.
///
/// See [PresentationClass]
abstract class GeneratedApplicationPresentation {
  /// The applications launch icon is set in pubspec.yaml using:
  /// [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

  /// The application [name]/title comes from [ApplicationPresentation.name],
  /// or when it is null: it is derived from the name of the class that
  /// implements [ApplicationPresentation]
  Translatable get name;

  /// The application [description]: is read from pubspec.yaml file, or when
  /// it is empty: is derived from the name of the class that
  /// implements [ApplicationPresentation]
  Translatable get description;

  /// The [titleImagePath] is displayed when no tabs are opened.
  /// * You have added a title image as assets\my_first_application.png
  ///   * Note that the file name is your Application class name
  ///     in snake_case format.
  ///   * Note that you can use any accessible folder in your project,
  ///     except the project root folder
  ///   * Note that you can use the following image
  ///     file extensions: jpeg, webp, gif, png, bmp, wbmp
  ///   * Note that you can have add multiple image files for different
  ///     resolutions and dark or light themes,
  ///     see https://flutter.dev/docs/development/ui/assets-and-images
  /// * You have defined an asset with the path to your title image file in
  ///   the flutter section of the pubspec.yaml file:
  ///     assets:
  ///     - assets/my_first_app.png
  String? get titleImagePath;

  /// A URI to the developers or applications home page
  /// is read from pubspec.yaml file.
  Uri? get homePage;

  /// A URI to the applications documentation is read from pubspec.yaml file.
  Uri? get documentation;

  /// The applications version is read from the pubspec.yaml file.
  String? get version;

  List<ServiceClassPresentation> get serviceClasses;
}
