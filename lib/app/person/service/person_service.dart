import '../domain/person.dart';

class PersonService {

  const PersonService();

  List<Person> allCustomers() =>
      [
        Person('James'),
        Person('Mary'),
        Person('Robert'),
        Person('Patricia'),
        Person('John'),
        Person('Jenifer'),
      ];
}