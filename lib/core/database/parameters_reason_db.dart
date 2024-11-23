import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_parameter_reason_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/parameter_reson_model.dart';

class ParametersReasonDb with ChangeNotifier {
  static const parametersReasonCollection = 'parameters_reason';
  List<ParameterReasonModel> _listOfParametersResons = [];
  List<ParameterReasonModel> get listOfParametersResons =>
      _listOfParametersResons;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(parametersReasonCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(parametersReasonCollection) ?? '-';
  }

  Future storeParameterReson(BuildContext context, {bool? dontList}) async {
    try {
      if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
          true) {
        _isDownloading = true;
        if (dontList == null) {
          notifyListeners();
        }
        final db = await LocalDatabaseService().initDb;

        await _clearTable();
        final result =
            await FetchParameterReasonRepo().fetchParameterReson(context);
        List data = result!.data as List;
        List<ParameterReasonModel> listOfParameterResons =
            data.map((e) => ParameterReasonModel.fromJson(e)).toList();

        for (var parametersReason in listOfParameterResons) {
          await db.insert(
            parametersReasonCollection,
            parametersReason.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        log('Parameter Reson Downloaded Successful');
        await setlastSync();
        await getAllParameterReson();
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

  Future getAllParameterReson() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data =
          await db.rawQuery('SELECT * FROM $parametersReasonCollection');
      _listOfParametersResons =
          data.map((e) => ParameterReasonModel.fromJson(e)).toList();
      notifyListeners();
      log('Parameter Reson Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(parametersReasonCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
