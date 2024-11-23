import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_station_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/station_model.dart';

class StationDb with ChangeNotifier {
  static const stationCollection = 'station';
  List<StationModel> _listOfStationModel = [];
  List<StationModel> get listOfStationModel => _listOfStationModel;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;
static Future<String> getValueById(dynamic id) async {
    final db = await LocalDatabaseService().initDb;
    final List<Map<String, dynamic>> result = await db.query(
      stationCollection, // Table name
      where: 'stationId = ?', // WHERE clause
      whereArgs: [id], // Value for the placeholder
    );
    return result[0]['stationName']??"N/A";
  }
  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(stationCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(stationCollection) ?? '-';
  }

  Future storeStations(BuildContext context, {bool? dontList}) async {
    try {
      if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
          true) {
        _isDownloading = true;
        if (dontList == null) {
          notifyListeners();
        }
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
        await setlastSync();
        await getAllSectionIncharges();
        _isDownloading = false;
      } else {
        showMessage('Please Check Your Internet Connection');
      }
    } catch (e) {
      _isDownloading = false;
      log('exception on adding data in to table ${e.toString()}');
    }
    if (dontList == null) {
      notifyListeners();
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
