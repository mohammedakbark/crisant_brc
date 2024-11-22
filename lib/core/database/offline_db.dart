import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/add_new_asset_model.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';



class OfflineDb with ChangeNotifier {
  static const offlineCollectionTable = 'offline_collection';

  List<AddNewAssetModel>? _listOfflineEntitites;
  List<AddNewAssetModel>? get listOfflineEntitites =>
      _listOfflineEntitites ?? [];
bool? _isDownloading;
bool? get isDownloading => _isDownloading;
  Future<void> addToOfflineDb(AddNewAssetModel model) async {
    try {
      _isDownloading = true;
      notifyListeners();
      final db = await LocalDatabaseService().initOfflineDb;

      await db.insert(offlineCollectionTable, model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      await getAllOFFlineDb();
      _isDownloading = false;
    } catch (e) {
      _isDownloading = false;
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllOFFlineDb() async {
    final db = await LocalDatabaseService().initOfflineDb;

    try {
      final dataofPentitles =
          await db.rawQuery('SELECT * FROM $offlineCollectionTable');

      _listOfflineEntitites =
          dataofPentitles.map((e) => AddNewAssetModel.fromJson(e)).toList();
      notifyListeners();
      log('Parameters Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initOfflineDb;

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
            showMessage('Storing Offline assessment to server');
          }
          _clearTable();
          getAllOFFlineDb();
        }
      }
    } catch (e) {
      log('exception on storing offline data to server   ${e.toString()}');
    }
  }
}
