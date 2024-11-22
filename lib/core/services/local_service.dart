// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/database/offline_add_entity_db.dart';
import 'package:test_managment/core/database/offline_test_entity_db.dart';
import 'package:test_managment/core/database/parameters_db.dart';
import 'package:test_managment/core/database/parameters_reason_db.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  // Database get database => _database;

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
  //--------------

  Database? _initOfflineAddEntityDb;
  Future<Database> get initOfflineAddEntityDb async {
    if (_initOfflineAddEntityDb != null) return _initOfflineAddEntityDb!;
    _initOfflineAddEntityDb = await _initOfflineAddEntityDatabase();
    return _initOfflineAddEntityDb!;
  }

  //---------------
  Database? _initOfflinTestEntityDb;
  Future<Database> get initOfflinTestEntityDb async {
    if (_initOfflinTestEntityDb != null) return _initOfflinTestEntityDb!;
    _initOfflinTestEntityDb = await _initOfflineTestEntityDatabase();
    return _initOfflinTestEntityDb!;
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
              'CREATE TABLE IF NOT EXISTS ${EntiteDb.entitiesCollection} (entityId TEXT PRIMARY KEY, entityName TEXT, pictureRequired TEXT, periodicity TEXT,entityType TEXT)');

          // Section Incharge Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${SectionInchargeDb.sectionInchargeCollection} (sectionInchargeId TEXT PRIMARY KEY, sectionInchargeName TEXT, divisionId TEXT)');

          //Section Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${SectionDb.sectionCollection} (sectionId TEXT PRIMARY KEY, sectionName TEXT, sectionInchargeId TEXT)');

          //Block station Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${BlockSectionDb.blockSectionCollection} (blockSectionId TEXT PRIMARY KEY, blockSectionName TEXT, sectionId TEXT)');

          //Station Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${StationDb.stationCollection} (stationId TEXT PRIMARY KEY, stationName TEXT, sectionId TEXT)');

          // Parameters Table
          db.execute(
              '''CREATE TABLE IF NOT EXISTS ${ParametersDb.parametersCollection} ( parameterId TEXT PRIMARY KEY,
          entityId TEXT,
          parameterName TEXT,
          parameterType TEXT,
          mandatory TEXT)''');

          //Parameters Value Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${ParametersValueDb.parametersValueCollection} (parameterValueId TEXT PRIMARY KEY, parameterId TEXT, parameterValue TEXT, parameterStatus TEXT)');

          //Parameters Reason Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${ParametersReasonDb.parametersReasonCollection} (parameterReasonId TEXT PRIMARY KEY, parameterValueId TEXT, reason TEXT)');

          // Entity Profile Table
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${EnitityProfileDb.entityProfileCollection} (entityProfileId TEXT PRIMARY KEY, divisionId TEXT, sectionInchargeId TEXT, sectionId TEXT,blockSectionId TEXT,stationId TEXT,entityId TEXT,entityIdentifier TEXT,entityLatt TEXT,entityLong TEXT,entityStatus TEXT,entityConfirmed TEXT,status TEXT,userId TEXT,modifiedDate TEXT)');
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
              'CREATE TABLE IF NOT EXISTS ${AuthDb.authtableCollection} (userName TEXT PRIMARY KEY, divisionId INTEGER,userPassword TEXT,token TEXT)');

          log('local ');
        },
      );
    } catch (e) {
      log('exception on initializing AUTH table ${e.toString()}');
      return null;
    }
  }

  Future<Database?> _initOfflineAddEntityDatabase() async {
    log('!---------------- OFFLINE Add Entity database initialized ---------------!');
    try {
      final path = join(await getDatabasesPath(), 'offlineDatabase.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE IF NOT EXISTS ${OfflineAddEntityDb.offlineCollectionTable} (id INTEGER PRIMARY KEY AUTOINCREMENT,entityIdentifier TEXT , sectionInchargeId TEXT,sectionId TEXT,blockSectionId TEXT,stationId TEXT,entityId TEXT,entityLatt TEXT,entityLong TEXT)');
        },
      );
    } catch (e) {
      log('exception on initializing offline table ${e.toString()}');
      return null;
    }
  }

  Future<Database?> _initOfflineTestEntityDatabase() async {
  log('!---------------- OFFLINE Test Entity database initialized ---------------!');
  try {
    final path = join(await getDatabasesPath(), 'offlineTestEntityDatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Enable foreign key constraints
        db.execute('PRAGMA foreign_keys = ON');

        // Create Table 1
        db.execute('''
          CREATE TABLE IF NOT EXISTS ${OfflineTestEntityDb.testEntityOfflineCollection} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            entityId TEXT,
            sectionInchargeId TEXT,
            sectionId TEXT,
            blockSectionId TEXT,
            stationId TEXT,
            entityProfileId TEXT,
            testLatt TEXT,
            testLong TEXT,
            testMode TEXT,
            connectivityMode TEXT,
            picture blob
          )
        ''');

        // Create Table 2 with a Foreign Key
        db.execute('''
          CREATE TABLE IF NOT EXISTS ${OfflineTestEntityDb.testEntityParameterCollection} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parameterId TEXT,
            parameterValue TEXT,
            parameterReasonId TEXT,
            testEntityId INTEGER,
            FOREIGN KEY (testEntityId) REFERENCES ${OfflineTestEntityDb.testEntityOfflineCollection}(id) ON DELETE CASCADE ON UPDATE NO ACTION
          )
        ''');
      },
    );
  } catch (e) {
    log('Exception on initializing offline for Test Entity table: ${e.toString()}');
    return null;
  }
}

  void fetchAllDatabases(BuildContext context) async {
    await Provider.of<EntiteDb>(context, listen: false).getAllEntities();
    await Provider.of<SectionInchargeDb>(context, listen: false)
        .getAllSectionIncharges();
    await Provider.of<SectionDb>(context, listen: false).getAllSections();
    await Provider.of<BlockSectionDb>(context, listen: false)
        .getAllBlockSections();
    await Provider.of<StationDb>(context, listen: false)
        .getAllSectionIncharges();
    await Provider.of<ParametersDb>(context, listen: false).getAllParameters();
    await Provider.of<ParametersValueDb>(context, listen: false)
        .getAllParametersValues();
    await Provider.of<ParametersReasonDb>(context, listen: false)
        .getAllParameterReson();
    await Provider.of<EnitityProfileDb>(context, listen: false)
        .getAllEnitityProfile();
    await Provider.of<OfflineAddEntityDb>(context, listen: false)
        .getAllOfflineAddEntityDb();
          await Provider.of<OfflineTestEntityDb>(context, listen: false)
        .getAllPendingOfflineTest();
  }
}
