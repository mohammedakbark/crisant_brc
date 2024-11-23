import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/controller/camera_controller.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/model/reposrts%20models/test_report_add_model.dart';

class OfflineTestEntityDb with ChangeNotifier {
  static const testEntityOfflineCollection = 'test_entity_offline_collection';
  static const testEntityParameterCollection =
      'test_entity_parameter_collection';

  List<AddNewTestModel>? _listOfflineEntitites;
  List<AddNewTestModel>? get listOfflineEntitites =>
      _listOfflineEntitites ?? [];
  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(testEntityOfflineCollection, today);
    await _getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future _getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(testEntityOfflineCollection) ?? '-';
  }

  Future<void> storeTestEntityOffline(AddNewTestModel model) async {
    try {
      final db = await LocalDatabaseService().initOfflinTestEntityDb;
      final entityjson = {
        "entityId": model.entityId,
        "sectionInchargeId": model.sectionInchargeId,
        "sectionId": model.sectionId,
        "blockSectionId": model.blockSectionId,
        "stationId": model.stationId,
        "entityProfileId": model.entityProfileId,
        "testLatt": model.testLatt,
        "testLong": model.testLong,
        "testMode": model.testMode, //MANUAL
        "connectivityMode": model.connectivityMode,
        "picture": CameraController.base64ToBlob(model.picture)
      };

      final primaryKey = await db.insert(
          testEntityOfflineCollection, entityjson,
          conflictAlgorithm: ConflictAlgorithm.replace);
      for (var i in model.parameters) {
        final json = {
          'parameterId': i.parameterId,
          'parameterValue': i.parameterValue,
          'parameterReasonId': i.parameterReasonId,
          'testEntityId': primaryKey
        };
        await db.insert(testEntityParameterCollection, json,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      showMessage('Entity Test added successfully (OFFLINE)');
    } catch (e) {
      showMessage('Entity Test Adding Failed (OFFLINE)', isWarning: true);
      log('exception on adding test entity OFFLINE ${e.toString()}');
    }
  }

  Future _clearEntityTable() async {
    final db = await LocalDatabaseService().initOfflinTestEntityDb;

    try {
      await db.delete(testEntityOfflineCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }

  Future getAllPendingOfflineTest({bool? dontListen}) async {
    try {
      _listOfflineEntitites = [];

      _isDownloading = true;
      if (dontListen == null) {
        notifyListeners();
      }
      final db = await LocalDatabaseService().initOfflinTestEntityDb;
      final dataOfEntitiesEntryd =
          await db.rawQuery('SELECT * FROM $testEntityOfflineCollection');

      if (dataOfEntitiesEntryd.isNotEmpty) {
        for (var json in dataOfEntitiesEntryd) {
          int testEntityId = json['id'] as int;
          String entityId = json["entityId"] as String;
          String sectionInchargeId = json["sectionInchargeId"] as String;
          String sectionId = json["sectionId"] as String;
          Object? blockSectionId = json["blockSectionId"];
          Object? stationId = json['stationId'];
          String entityProfileId = json["entityProfileId"] as String;
          String testLatt = json["testLatt"] as String;
          String testLong = json["testLong"] as String;
          String testMode = json["testMode"] as String;
          String connectivityMode = json["connectivityMode"] as String;
          String picture =
              CameraController.blobToBase64(json["picture"] as Uint8List);
          List<TestParametersModel> testParametersModel = [];

          final dataOfParametes = await db.rawQuery(
              'SELECT * FROM $testEntityParameterCollection  WHERE $testEntityId ==testEntityId');
          if (dataOfParametes.isNotEmpty) {
            for (var i in dataOfParametes) {
              String parameterId = i['parameterId'] as String;
              String parameterValue = i['parameterValue'] as String;
              String parameterReasonId = i['parameterReasonId'] as String;
              testParametersModel.add(TestParametersModel(
                  parameterId: parameterId,
                  parameterValue: parameterValue,
                  parameterReasonId: parameterReasonId));
            }
          }
          _listOfflineEntitites?.add(AddNewTestModel(
              connectivityMode: connectivityMode,
              entityId: entityId,
              entityProfileId: entityProfileId,
              picture: picture,
              sectionId: sectionId,
              sectionInchargeId: sectionInchargeId,
              testLatt: testLatt,
              testLong: testLong,
              testMode: testMode,
              blockSectionId: blockSectionId.toString(),
              stationId: stationId.toString(),
              parameters: testParametersModel));
        }
      } else {
        log('No Offline File');
      }

      //-------------------------
      log('Offline Enitity Test Fetched');
      await setlastSync();
      _isDownloading = false;
      if (dontListen == null) {
        notifyListeners();
      }
    } catch (e) {
      _isDownloading = false;
      if (dontListen == null) {
        notifyListeners();
      }
      log('exception on ftething pending offline test data from table ${e.toString()}');
    }
  }

  Future<void> storeAllOfflineDataToServer(
    BuildContext context,
  ) async {
    try {
      if (listOfflineEntitites != null) {
        if (listOfflineEntitites!.isNotEmpty) {
          for (var i in listOfflineEntitites!) {
            await ApiService.addNewTest(context, i);
            showMessage('Storing Offline Test to server');
          }
          await _clearEntityTable();
          await getAllPendingOfflineTest();
        }
      }
    } catch (e) {
      log('exception on storing offline Test Data to server   ${e.toString()}');
    }
  }
}
