import 'package:flutter/material.dart';
import '../dao/person_dao.dart';
import '../models/person.dart';

class PersonViewModel extends ChangeNotifier {
  final PersonDao _personDao;

  PersonViewModel(this._personDao);

  Stream<List<Person>> get persons => _personDao.findAllPersons();

  Future<void> addPerson(String name, int age) async {
    final person = Person(name: name, age: age);
    await _personDao.insertPerson(person);
    notifyListeners();
  }
}

