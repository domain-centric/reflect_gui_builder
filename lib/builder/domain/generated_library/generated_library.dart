import 'package:build/build.dart';
import 'package:dart_code/dart_code.dart';
import 'package:reflect_gui_builder/builder/reflect_presentation_library_builder.dart';

class GeneratedLibraries {
  final Map<String, Library> inputUrisAndLibraries = {};
  // final PresentationOutputPathFactory outputPathFactory;

  // GeneratedLibraries(this.outputPathFactory);

  bool get isEmpty => inputUrisAndLibraries.isEmpty;

  String _normalize(String path) => path.toLowerCase();

  addFunction(String librarySourceUri, DartFunction function) {
    var lib = library(librarySourceUri);
    lib.functions!.add(function);
  }

  addClass(String librarySourceUri, Class classToAdd) {
    var lib = library(librarySourceUri);
    lib.classes!.add(classToAdd);
  }

  void addClasses(String librarySourceUri, List<Class> classes) {
    for (var classToAdd in classes) {
      addClass(librarySourceUri, classToAdd);
    }
  }

  Library library(String inputUri) {
    var normalizedPath = _normalize(inputUri);
    var library = inputUrisAndLibraries[normalizedPath];
    if (library == null) {
      library = _createLibrary(inputUri);
      inputUrisAndLibraries[normalizedPath] = library;
    }
    return library;
  }

  Library _createLibrary(String inputUris) {
    return Library(
      classes: [],
      functions: [],
      docComments: _createComments(inputUris),
    );
  }

  List<DocComment> _createComments(String inputUri) => [
        DocComment.fromList([
          'Do not make changes to this file!',
          'This file is generated by: $ReflectPresentationLibraryBuilder',
          'On: ${DateTime.now()}',
          'From: $inputUri',
          'Generate command: '
              'dart run build_runner build --delete-conflicting-outputs',
          'For more information see: TODO',

          ///TODO]
        ])
      ];

  // Map<AssetId, String> get outputAssetIdsAndLibraries =>
  //     inputUrisAndLibraries.map((inputUri, library) =>
  //         MapEntry(_createOutputUri(inputUri), library.toString()));

  // AssetId _createOutputUri(String inputUri) =>
  //     outputPathFactory.createOutputAssetId(Uri.parse(inputUri));
}

final resource = Resource(() => GeneratedLibraries());
