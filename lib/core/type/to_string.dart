class ToStringBuilder {
  final indentation = '  ';
  final String name;
  final Map<String, dynamic> fieldsAndValues = {};

  ToStringBuilder(this.name);

  ToStringBuilder add(String fieldName, dynamic fieldValue) {
    if (fieldValue != null) {
      fieldsAndValues[fieldName] = fieldValue;
    }
    return this;
  }

  @override
  String toString() {
    if (fieldsAndValues.isEmpty) {
      return objectWithoutFieldsToString();
    } else {
      return objectWithFieldsToString();
    }
  }

  String objectWithoutFieldsToString() => name;

  String objectWithFieldsToString() {
    List<String> fieldLines = fieldsToStrings();
    if (fieldLines.length == 1) {
      return objectWithSingleFieldLineToString(fieldLines.first);
    } else {
      return objectWithMultipleFieldLinesToString(fieldLines);
    }
  }

  String objectWithSingleFieldLineToString(String fieldLine) =>
      '$name { $fieldLine }';

  String objectWithMultipleFieldLinesToString(List<String> fieldLines) {
    String result = '$name {\n';
    for (var fieldLine in fieldLines) {
      result += '$indentation$fieldLine\n';
    }
    result += '}';
    return result;
  }

  List<String> fieldsToStrings() {
    var fieldLines = <String>[];
    for (var fieldName in fieldsAndValues.keys) {
      fieldLines.addAll(fieldToStrings(fieldName));
    }
    return fieldLines;
  }

  List<String> fieldToStrings(String fieldName) {
    var fieldValue = fieldsAndValues[fieldName];
    var valueLines = valueToStrings(fieldValue);
    if (valueLines.length == 1) {
      return fieldOfOneLineToString(fieldName, valueLines.first);
    } else {
      return fieldsOfMultipleLinesToString(fieldName, valueLines);
    }
  }

  List<String> fieldsOfMultipleLinesToString(
      String fieldName, List<String> valueLines) {
    var results = <String>[];
    results.add('$fieldName:');
    for (var valueLine in valueLines) {
      results.add('$indentation$valueLine');
    }
    return results;
  }

  List<String> fieldOfOneLineToString(String fieldName, String fieldValue) =>
      ['$fieldName: $fieldValue'];

  List<String> valueToStrings(dynamic value) {
    if (value is Iterable) {
      return iterableToStrings(value);
    } else {
      return noneIterableToStrings(value);
    }
  }

  /// Examples:
  /// * ..[]
  /// * ..[12]
  /// * ..[First
  ///   ...Object
  ///   ..,Second
  ///   ...Object
  ///   ..]
  List<String> iterableToStrings(Iterable iterable) {
    var results = <String>[];
    var values = iterable.toList();
    if (values.isEmpty) {
      return ['[]'];
    }
    bool isFirstElement = true;
    for (var value in iterable.toList()) {
      var lines = valueToStrings(value);
      bool isFirstLineInElement = true;
      for (var line in lines) {
        if (isFirstLineInElement) {
          results.add("${isFirstElement ? '[ ' : ', '}$line");
        } else {
          results.add("$indentation$line");
        }
        isFirstElement = false;
        isFirstLineInElement = false;
      }
    }
    if (results.length == 1) {
      results.first = '${results.first}]';
    } else {
      results.add(']');
    }
    return results;
  }

  List<String> noneIterableToStrings(Object fieldValue) =>
      fieldValue.toString().split('\n');
}
