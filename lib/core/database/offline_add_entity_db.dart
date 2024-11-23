import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/model/add_new_asset_model.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';

class OfflineAddEntityDb with ChangeNotifier {
  static const offlineCollectionTable = 'offline_collection';

  List<AddNewAssetModel>? _listOfflineEntitites;
  List<AddNewAssetModel>? get listOfflineEntitites =>
      _listOfflineEntitites ?? [];
  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(offlineCollectionTable, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(offlineCollectionTable) ?? '-';
  }

  Future<void> addToOfflineAddEntityDb(AddNewAssetModel model) async {
    try {
      final db = await LocalDatabaseService().initOfflineAddEntityDb;

      await db.insert(offlineCollectionTable, model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      await getAllOfflineAddEntityDb();
      showMessage('Entity added successfully (OFFLINE)');
    } catch (e) {
      showMessage('Entity added Failed (OFFLINE)', isWarning: true);
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllOfflineAddEntityDb({bool? dontList}) async {
    final db = await LocalDatabaseService().initOfflineAddEntityDb;

    try {
      _isDownloading = true;
      if (dontList == null) {
        notifyListeners();
      }
      final dataofPentitles =
          await db.rawQuery('SELECT * FROM $offlineCollectionTable');

      // if (dataofPentitles.isNotEmpty) {
      _listOfflineEntitites =
          dataofPentitles.map((e) => AddNewAssetModel.fromJson(e)).toList();
      // }
      await setlastSync();
      _isDownloading = false;
      if (dontList == null) {
        notifyListeners();
      }
      log('Parameters Fetched');
    } catch (e) {
      _isDownloading = false;
      if (dontList == null) {
        notifyListeners();
      }
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initOfflineAddEntityDb;

    try {
      await db.delete(offlineCollectionTable);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }

  Future<void> storeAllOfflineDataToServer(
    BuildContext context,
  ) async {
    try {
      if (listOfflineEntitites != null) {
        if (listOfflineEntitites!.isNotEmpty) {
          for (var i in listOfflineEntitites!) {
            await ApiService.addNewAsset(context, i);
            showMessage('Storing offline assets to server');
          }
          await _clearTable();
          await Provider.of<EnitityProfileDb>(context, listen: false)
              .storeEnitityProfile(context);
          await getAllOfflineAddEntityDb();
        }
      }
    } catch (e) {
      log('exception on storing offline data to server   ${e.toString()}');
    }
  }
}
