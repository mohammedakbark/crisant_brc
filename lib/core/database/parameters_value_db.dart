import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_parameter_value_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/parameter_values_model.dart';

class ParametersValueDb with ChangeNotifier {
  static const parametersValueCollection = 'parameters_value';
  List<ParameterValuesModel> _listOfParametersValues = [];
  List<ParameterValuesModel> get listOfParametersValues =>
      _listOfParametersValues;

  void storeParametersValues(BuildContext context) async {
    try {
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
        // await db.rawInsert(
        //     'INSERT INTO $parametersValueCollection(parameterValueId,parameterId,parameterValue,parameterStatus) VALUES(?,?,?,?)',
        //     [
        //       parametersValues.parameterValueId,
        //       parametersValues.parameterId,
        //       parametersValues.parameterValue,
        //       parametersValues.parameterStatus
        //     ]);
      }

      log('Parameters Values  Downloaded Successful');
      await getAllParametersValues();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
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
