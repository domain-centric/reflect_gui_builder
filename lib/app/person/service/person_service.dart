import '../domain/person.dart';

class PersonService {
  const PersonService();

  List<Person> allCustomers() => [
        Person()
          ..name = 'James'
          ..gender = Gender.male,
        Person()
          ..name = 'Mary'
          ..gender = Gender.female,
        Person()
          ..name = 'Robert'
          ..gender = Gender.male,
        Person()
          ..name = 'Patricia'
          ..gender = Gender.female,
        Person()
          ..name = 'John'
          ..gender = Gender.male,
        Person()
          ..name = 'Jenifer'
          ..gender = Gender.female,
      ];

  List<Person> customersByGender(Gender genderToFind) =>
      allCustomers().where((person) => person.gender == genderToFind).toList();
}
