import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_section_incharge_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/section_incharge_model.dart';

class SectionInchargeDb with ChangeNotifier {
  static const sectionInchargeCollection = 'sectionIncharge';
  List<SectionInchargeModel> _listOfSectionIncharge = [];
  List<SectionInchargeModel> get listOfSectionIncharge =>
      _listOfSectionIncharge;

  void storeSectionIncharges(BuildContext context) async {
    try {
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result =
          await FetchSectionInchargeRepo().fetchSectionIncharge(context);
      List data = result!.data as List;
      List<SectionInchargeModel> listOfSectionIncharges =
          data.map((e) => SectionInchargeModel.fromJson(e)).toList();

      for (var sectionInharge in listOfSectionIncharges) {
        await db.insert(
          sectionInchargeCollection,
          sectionInharge.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // await db.rawInsert(
        //     'INSERT INTO $sectionInchargeCollection(sectionInchargeId,sectionInchargeName,divisionId) VALUES(?,?,?)',
        //     [
        //       sectionInharge.sectionInchargeId,
        //       sectionInharge.sectionInchargeName,
        //       sectionInharge.divisionId
        //     ]);
      }

      log('Section Incharge Downloaded Successful');
      await getAllSectionIncharges();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllSectionIncharges() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data =
          await db.rawQuery('SELECT * FROM $sectionInchargeCollection');
      _listOfSectionIncharge =
          data.map((e) => SectionInchargeModel.fromJson(e)).toList();
      notifyListeners();
      log('Section Incharge Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(sectionInchargeCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
