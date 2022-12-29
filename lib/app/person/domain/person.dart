class Person {
  String name = '';
  Gender gender = Gender.unknown;
  int id = 0;

  List<EmailAddress> get eMailAddresses => [];
}

class EmailAddress {}

enum Gender { male, female, other, unknown }
