import 'package:floor/floor.dart';
import 'dart:async';
import '../models/person.dart';
import '../dao/person_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
}


