import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseController with ChangeNotifier {
  late Database _database;

  initLocal() async {
    const String _entities = 'entities';
    const String _sectionIncharge = 'section_incharge';
    const String _section = 'section';
    const String _blockSection = 'block_section';
    const String _station = 'station';
    const String _parameters = 'parameters';
    const String _parametersValue = 'parameters_value';
    const String _parametersReason = 'parameters_reason';
    const String _entityProfile = 'entity_profile';

    final path = await getDatabasesPath();
    _database = await openDatabase(
      path,
      onCreate: (db, version) {
         db.execute(
        'CREATE TABLE $_entities (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, occ INTEGER)');
      },
    );
  }
}
