import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/auth_db.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  // Database get database => _database;
  static const _sectionInchargeCollection = 'section_incharge';
  static const _sectionCollection = 'section';
  static const _blockSectionCollection = 'block_section';
  static const _stationCollection = 'station';
  static const _parametersCollection = 'parameters';
  static const _parametersValueCollection = 'parameters_value';
  static const _parametersReasonCollection = 'parameters_reason';
  static const _entityProfileCollection = 'entity_profile';

  //-------
  Database? _initDb;
  Future<Database> get initDb async {
    if (_initDb != null) return _initDb!;
    _initDb = await _inittestAssetsDatabase();
    return _initDb!;
  }
  //---------

  Database? _initAuthDb;
  Future<Database> get initAuthDb async {
    if (_initAuthDb != null) return _initAuthDb!;
    _initAuthDb = await _initAuthService();
    return _initAuthDb!;
  }

  Future<Database?> _inittestAssetsDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'testAssetsDatabase.db');
      log('!----------------test asset database initialization is done---------------!');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          // Entity Table
          db.execute(
              'CREATE TABLE ${EntiteDb.entitiesCollection} (entityId TEXT PRIMARY KEY, entityName TEXT, pictureRequired TEXT, periodicity TEXT,entityType TEXT)');

          // Section Incharge Table
          db.execute(
              'CREATE TABLE $_sectionInchargeCollection (sectionInchargeId TEXT PRIMARY KEY, sectionInchargeName TEXT, divisionId TEXT)');

          //Section Table
          db.execute(
              'CREATE TABLE $_sectionCollection (sectionId TEXT PRIMARY KEY, sectionName TEXT, sectionInchargeId TEXT)');

          //Block station Table
          db.execute(
              'CREATE TABLE $_blockSectionCollection (blockSectionId TEXT PRIMARY KEY, blockSectionName TEXT, sectionId TEXT)');

          //Station Table
          db.execute(
              'CREATE TABLE $_stationCollection (stationId TEXT PRIMARY KEY, stationName TEXT, sectionId TEXT)');

          //Parameters Table
          // db.execute(
          //     'CREATE TABLE $_parametersCollection (parameterId TEXT PRIMARY KEY, entityId TEXT, parameterName TEXT, parameterType TEXT,mandatory TEXT,values )');

          // //Parameters Value Table
          // db.execute(
          //     'CREATE TABLE $_parametersValueCollection (entityId TEXT PRIMARY KEY, entityName TEXT, pictureRequired TEXT, periodicity TEXT,entityType TEXT)');

          // //Parameters Reason Table
          // db.execute(
          //     'CREATE TABLE $_parametersReasonCollection (entityId TEXT PRIMARY KEY, entityName TEXT, pictureRequired TEXT, periodicity TEXT,entityType TEXT)');

          // // Entity Profile Table
          // db.execute(
          //     'CREATE TABLE $_entityProfileCollection (entityId TEXT PRIMARY KEY, entityName TEXT, pictureRequired TEXT, periodicity TEXT,entityType TEXT)');
        },
      );
    } catch (e) {
      log('exception on initializing table ${e.toString()}');
      return null;
    }
  }

  Future<Database?> _initAuthService() async {
    log('!---------------- auth database initialized ---------------!');

    try {
      final path = join(await getDatabasesPath(), 'authdatabase.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE ${AuthDb.authtableCollection} (userName TEXT PRIMARY KEY, divisionId INTEGER,userPassword TEXT,token TEXT)');

          log('local ');
        },
      );
    } catch (e) {
      log('exception on initializing AUTH table ${e.toString()}');
      return null;
    }
  }
}
