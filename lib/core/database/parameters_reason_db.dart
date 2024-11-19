import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_parameter_reason_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/parameter_reson_model.dart';

class ParametersReasonDb with ChangeNotifier {
  static const parametersReasonCollection = 'parameters_reason';
  List<ParameterReasonModel> _listOfParametersResons = [];
  List<ParameterReasonModel> get listOfParametersResons =>
      _listOfParametersResons;

  void storeParameterReson(BuildContext context) async {
    try {
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
        // await db.rawInsert(
        //     'INSERT INTO $parametersReasonCollection(parameterReasonId,parameterValueId,reason) VALUES(?,?,?)',
        //     [
        //       parametersReason.parameterReasonId,
        //       parametersReason.parameterValueId,
        //       parametersReason.reason
        //     ]);
      }

      log('Parameter Reson Downloaded Successful');
      await getAllParameterReson();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
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
