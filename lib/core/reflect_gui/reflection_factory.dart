import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

extension ElementExtension on Element {
  String get asLibraryMemberPath =>
      library == null ? memberPath : '${library!.source.uri}/$memberPath';

  String get memberPath {
    var parentPath = _parentPath;
    if (parentPath.isEmpty) {
      return name ?? '';
    } else {
      return '$parentPath.${name ?? ''}';
    }
  }

  String get _parentPath {
    if (enclosingElement == null) {
      return '';
    }
    if (enclosingElement is PropertyInducingElement) {
      return (enclosingElement! as PropertyInducingElement).memberPath;
    } else {
      return enclosingElement!.name ?? '';
    }
  }
}

/// TODO all subclasses exceptions with reference to a class mus show the [FieldElementExtension.asLibraryMemberPath]



/// Class to create objects that contain information on source code.
/// It contains methods to analyze source code [Element]s
/// from the analyzer package
abstract class SourceFactory {

  bool hasSuperClass(ClassElement classElement, String libraryUriToFind,
      String nameToFind) {
    var superTypes = classElement.allSupertypes;
    for (var superType in superTypes) {
      String name = superType
          .getDisplayString(withNullability: false)
          .replaceFirst(RegExp('<.*>'), '');

      String libraryUri = superType.element.library.source.uri.toString();
      if (name == nameToFind && libraryUri == libraryUriToFind) {
        return true;
      }
    }
    return false;
  }

  InterfaceType? findSuperClass(InterfaceElement element,
      String libraryUriToFind, String nameToFind) {
    var superTypes = element.allSupertypes;
    for (var superType in superTypes) {
      String name = superType
          .getDisplayString(withNullability: false)
          .replaceFirst(RegExp('<.*>'), '');
      String libraryUri = superType.element.library.source.uri.toString();
      if (name == nameToFind && libraryUri == libraryUriToFind) {
        return superType;
      }
    }
    return null;
  }

  bool hasNamelessConstructorWithoutParameters(ClassElement classElement) {
    var constructors = classElement.constructors;
    for (var constructor in constructors) {
      if (constructor.name.isEmpty && constructor.parameters.isEmpty) {
        return true;
      }
    }
    // log.info(
    //     'A default constructor or a nameless constructor without parameters was expected for $classElement in library ${classElement.library.source.uri}');
    return false;
  }

  bool hasConstNamelessConstructorWithoutParameters(ClassElement classElement) {
    var constructors = classElement.constructors;
    for (var constructor in constructors) {
      if (constructor.name.isEmpty &&
          constructor.parameters.isEmpty &&
          constructor.isConst) {
        return true;
      }
    }
    // log.info(
    //     'A default constructor or a nameless constructor without parameters was expected for $classElement in library ${classElement.library.source.uri}');
    return false;
  }

  FieldElement findField(ClassElement reflectGuiConfigClass,
      String fieldNameToFind) {
    for (var field in reflectGuiConfigClass.fields) {
      if (field.name == fieldNameToFind) {
        return field;
      }
    }
    throw Exception(
        'Could not find field: $fieldNameToFind in $reflectGuiConfigClass');
  }

  List<Element> findInitializerElements(FieldElement field) {
    var foundElements = <Element>[];
    var declaration = _declarationOfElement(field).node;
    var expression = (declaration as VariableDeclaration).initializer;
    if (expression.runtimeType.toString() != 'ListLiteralImpl') {
      throw Exception(
          '${field
              .asLibraryMemberPath}: Must return a literal list, e.g. [ProductService, ShoppingCartService]');
    }
    var listLiteral = expression as ListLiteral;
    for (var listElement in listLiteral.elements) {
      if (!['SimpleIdentifierImpl', 'PrefixedIdentifierImpl']
          .contains(listElement.runtimeType.toString())) {
        throw Exception(
            '${field
                .asLibraryMemberPath}: The list must contain identifiers, e.g. [ProductService, ShoppingCartService]');
      }
      var identifier = listElement as Identifier;
      var element = _findElementInLibraryOrImportedLibraries(
          field.library, identifier.name);
      if (element == null) {
        throw Exception(
            '${field
                .asLibraryMemberPath}: Could not find the type of $identifier');
      }
      foundElements.add(element);
    }

    return foundElements;
  }

  ElementDeclarationResult _declarationOfElement(
      PropertyInducingElement element) {
    var session = element.session!;
    var parsedLibrary = (session.getParsedLibraryByElement(element.library)
    as ParsedLibraryResult);
    return parsedLibrary.getElementDeclaration(element)!;
  }

  Element? _findElementInLibrary(LibraryElement library,
      String elementNameToFind,
      [String libraryPreFix = '']) {
    var topLevelElements = library.topLevelElements;
    if (elementNameToFind.startsWith(libraryPreFix)) {
      elementNameToFind = elementNameToFind.substring(libraryPreFix.length);
    }
    for (var topLevelElement in topLevelElements) {
      if (topLevelElement.name == elementNameToFind) {
        return topLevelElement;
      }
    }
    return null;
  }

  Element? _findElementInLibraryOrImportedLibraries(LibraryElement library,
      String elementNameToFind) {
    var foundElement = _findElementInLibrary(library, elementNameToFind);
    if (foundElement != null) {
      return foundElement;
    }
    for (var libraryImport in library.libraryImports) {
      String importPrefix = _importPrefix(libraryImport);
      var foundElement = _findElementInLibrary(
          libraryImport.importedLibrary!, elementNameToFind, importPrefix);
      if (foundElement != null) {
        return foundElement;
      }
    }
    return null;
  }

  String _importPrefix(LibraryImportElement libraryImport) {
    var prefix = libraryImport.prefix;
    if (prefix is ImportElementPrefix) {
      return '${prefix.element.name}.';
    } else {
      return "";
    }
  }

  /// Finds all fields within the object, its super types and all its mixins.
  List<FieldElement> findAllFields(ClassElement classElement) {
    var fieldElements = <FieldElement>[];
    fieldElements.addAll(classElement.fields);
    for (var superType in classElement.allSupertypes) {
      fieldElements.addAll(superType.element.fields);
    }
    for (var mixin in classElement.mixins) {
      fieldElements.addAll(mixin.element.fields);
    }
    return fieldElements;
  }
}
