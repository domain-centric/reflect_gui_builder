import '../domain/person.dart';

class PersonService {

  const PersonService();

  List<Person> allCustomers() =>
      [
        Person()..name='James',
        Person()..name='Mary',
        Person()..name='Robert',
        Person()..name='Patricia',
        Person()..name='John',
        Person()..name='Jenifer',
      ];
}