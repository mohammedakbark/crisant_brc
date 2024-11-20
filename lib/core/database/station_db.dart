import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_station_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/station_model.dart';

class StationDb with ChangeNotifier {
  static const stationCollection = 'station';
  List<StationModel> _listOfStationModel = [];
  List<StationModel> get listOfStationModel => _listOfStationModel;

  void storeStations(BuildContext context) async {
    try {
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result = await FetchStationRepo().fetchStation(context);
      List data = result!.data as List;
      List<StationModel> listOfStations =
          data.map((e) => StationModel.fromJson(e)).toList();

      for (var stations in listOfStations) {
        await db.insert(
          stationCollection,
          stations.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // await db.rawInsert(
        //     'INSERT INTO $stationCollection(stationId,stationName,sectionId) VALUES(?,?,?)',
        //     [stations.stationId, stations.stationName, stations.sectionId]);
      }

      log('Stations Downloaded Successful');
      await getAllSectionIncharges();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllSectionIncharges() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data = await db.rawQuery('SELECT * FROM $stationCollection');
      _listOfStationModel = data.map((e) => StationModel.fromJson(e)).toList();
      notifyListeners();
      log('Stations Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(stationCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
