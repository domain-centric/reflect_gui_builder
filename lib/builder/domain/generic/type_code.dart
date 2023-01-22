import 'package:dart_code/dart_code.dart';
import 'package:recase/recase.dart';
import 'package:reflect_gui_builder/builder/domain/domain_class/domain_class_source.dart';
import 'package:reflect_gui_builder/builder/domain/enum_class/enum_source.dart';
import 'package:reflect_gui_builder/builder/domain/generic/type_source.dart';
import 'package:reflect_gui_builder/builder/domain/presentation_output_path/presentation_output_path.dart';
import 'package:reflect_gui_builder/builder/domain/service_class/service_class_source.dart';

class TypeFactory {
  Type create(ClassSource classSource) => Type(
        classSource.className,
        libraryUri: classSource.libraryUri,
      );
}

class ClassPresentationFactory {
  final PresentationOutputPathFactory outputPathFactory;

  ClassPresentationFactory(this.outputPathFactory);

  /// creates an [Expression] to create a ClassPresentation implementation
  Expression create(ClassSource source) {
    if (source.libraryUri == 'dart:core') {
      return _createDartCoreClassPresentation(source);
    } else if (source is ServiceClassSource ||
        source is DomainClassSource ||
        source is EnumSource) {
      return _createGeneratedClassPresentation(source);
    } else {
      return _createClassPresentation(source);
    }
  }

  Expression _createDartCoreClassPresentation(ClassSource source) {
    var genericTypes = _createGenericTypes(source);

    if ([
      'bool',
      'int',
      'BigInt',
      'double',
      'num',
      'DateTime',
      'Duration',
      'String',
      'Symbol',
      'Uri',
      'Object',
    ].contains(source.className)) {
      return Expression.callConstructor(DartCoreType(),
          name: source.className.camelCase);
    } else if ([
      'Iterable',
      'Iterator',
      'List',
      'Set',
    ].contains(source.className)) {
      return Expression.callConstructor(DartCoreType(),
          name: source.className.camelCase,
          parameterValues: ParameterValues(
            [ParameterValue.named('genericType', genericTypes.first)],
          ));
    } else {
      return Expression.callConstructor(DartCoreType(),
          parameterValues: ParameterValues([
            ParameterValue(Expression.ofString(source.className)),
            if (genericTypes.isNotEmpty)
              ParameterValue.named(
                  'genericTypes', Expression.ofList(genericTypes)),
          ]));
    }
  }

  List<Expression> _createGenericTypes(ClassSource source) =>
      source.genericTypes.map((source) => create(source)).toList();

  Expression _createClassPresentation(ClassSource source) {
    var genericTypes = _createGenericTypes(source);

    return Expression.callConstructor(ClassPresentationType(),
        parameterValues: ParameterValues([
          ParameterValue(Expression.ofString(source.className)),
          if (genericTypes.isNotEmpty)
            ParameterValue.named(
                'genericTypes', Expression.ofList(genericTypes)),
        ]));
  }

  Expression _createGeneratedClassPresentation(ClassSource source) {
    var genericTypes = _createGenericTypes(source);

    return Expression.callConstructor(
        _createGeneratedClassPresentationType(source),
        parameterValues: ParameterValues([
          if (genericTypes.isNotEmpty)
            ParameterValue.named(
                'genericTypes', Expression.ofList(genericTypes)),
        ]));
  }

  Type _createGeneratedClassPresentationType(ClassSource source) =>
      Type(outputPathFactory.createOutputClassName(source.className),
          libraryUri:
              outputPathFactory.createOutputUri(source.libraryUri).toString());
}

class DartCoreType extends Type {
  DartCoreType()
      : super('DartCore',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart');
}

class ClassPresentationType extends Type {
  ClassPresentationType()
      : super('ClassPresentation',
            libraryUri:
                'package:reflect_gui_builder/builder/domain/generic/type_presentation.dart');
}
