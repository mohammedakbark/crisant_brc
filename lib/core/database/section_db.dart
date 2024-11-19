import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_section_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/section_model.dart';

class SectionDb with ChangeNotifier {
  static const sectionCollection = 'section';
  List<SectionModel> _listOfSection = [];
  List<SectionModel> get listOfSection => _listOfSection;

  void storeSection(BuildContext context) async {
    try {
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result = await FetchSectionRepo().fetchSection(context);
      List data = result!.data as List;
      List<SectionModel> listOfSection =
          data.map((e) => SectionModel.fromJson(e)).toList();

      for (var section in listOfSection) {
        await db.insert(
          sectionCollection,
          section.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // await db.rawInsert(
        //     'INSERT INTO $sectionCollection(sectionId,sectionName,sectionInchargeId) VALUES(?,?,?)',
        //     [
        //       section.sectionId,
        //       section.sectionName,
        //       section.sectionInchargeId
        //     ]);
      }

      log('Section  Downloaded Successful');
      await getAllSections();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllSections() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data =
          await db.rawQuery('SELECT * FROM $sectionCollection');
      _listOfSection =
          data.map((e) => SectionModel.fromJson(e)).toList();
      notifyListeners();
      log('Section Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(sectionCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
