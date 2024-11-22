import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_parameters_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/parameters_model.dart';

class ParametersDb with ChangeNotifier {
  static const parametersCollection = 'parameters';
  // static const valuesCollection = 'values';

  List<ParametersModel> _listOfParameters = [];
  List<ParametersModel> get listOfParameters => _listOfParameters;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  void storeParameters(BuildContext context) async {
    try {
      _isDownloading = true;
      notifyListeners();
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result = await FetchParametersRepo().fetchParameter(context);
      List data = result!.data as List;
      List<ParametersModel> listOfParameters =
          data.map((e) => ParametersModel.fromJson(e)).toList();
      for (var parameters in listOfParameters) {
        await db.insert(parametersCollection, parameters.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      log('Parameters  Downloaded Successful');
      _isDownloading = false;
      await getAllParameters();
    } catch (e) {
      _isDownloading = false;
      log('exception on adding data in to table ${e.toString()}');
    }
      notifyListeners();
  }

  Future getAllParameters() async {
    final db = await LocalDatabaseService().initDb;

    try {
      _isDownloading = true;
      notifyListeners();
      final dataofParameters =
          await db.rawQuery('SELECT * FROM $parametersCollection');

      _listOfParameters =
          dataofParameters.map((e) => ParametersModel.fromJson(e)).toList();
      notifyListeners();
      _isDownloading = false;
      log('Parameters Fetched');
    } catch (e) {
      _isDownloading = false;
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(parametersCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
