import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_parameter_value_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/parameter_values_model.dart';

class ParametersValueDb with ChangeNotifier {
  static const parametersValueCollection = 'parameters_value';
  List<ParameterValuesModel> _listOfParametersValues = [];
  List<ParameterValuesModel> get listOfParametersValues =>
      _listOfParametersValues;
  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(parametersValueCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(parametersValueCollection) ?? '-';
  }

  Future storeParametersValues(BuildContext context, {bool? dontList}) async {
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
            await FetchParameterValueRepo().fetchParameterValues(context);
        List data = result!.data as List;
        List<ParameterValuesModel> listOfParametersValues =
            data.map((e) => ParameterValuesModel.fromJson(e)).toList();

        for (var parametersValues in listOfParametersValues) {
          await db.insert(
            parametersValueCollection,
            parametersValues.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        log('Parameters Values  Downloaded Successful');
        await setlastSync();
        await getAllParametersValues();
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

  Future getAllParametersValues() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data =
          await db.rawQuery('SELECT * FROM $parametersValueCollection');
      _listOfParametersValues =
          data.map((e) => ParameterValuesModel.fromJson(e)).toList();
      notifyListeners();
      log('ParametersValues Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(parametersValueCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
