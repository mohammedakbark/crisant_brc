import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_block_section_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/block_station_model.dart';

class BlockSectionDb with ChangeNotifier {
  static const blockSectionCollection = 'block_section';
  List<BlockSectionModel> _listOfBlockSections = [];
  List<BlockSectionModel> get listOfBlockSections => _listOfBlockSections;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  void storeBlockSections(BuildContext context) async {
    try {
      _isDownloading = true;
      notifyListeners();
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result = await FetchBlockSectionRepo().fetchBlockSection(context);
      List data = result!.data as List;
      List<BlockSectionModel> listOfBockSection =
          data.map((e) => BlockSectionModel.fromJson(e)).toList();

      for (var blockSection in listOfBockSection) {
        await db.insert(
          blockSectionCollection,
          blockSection.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // await db.rawInsert(
        //     'INSERT INTO $blockSectionCollection(blockSectionId,blockSectionName,sectionId) VALUES(?,?,?)',
        //     [
        //       blockSection.blockSectionId,
        //       blockSection.blockSectionName,
        //       blockSection.sectionId
        //     ]);
      }

      log('Block Section Downloaded Successful');
      await getAllBlockSections();
      _isDownloading = false;
    } catch (e) {
      _isDownloading = false;
      log('exception on adding data in to table ${e.toString()}');
    }
      notifyListeners();
  }

  Future getAllBlockSections() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data = await db.rawQuery('SELECT * FROM $blockSectionCollection');
      _listOfBlockSections =
          data.map((e) => BlockSectionModel.fromJson(e)).toList();
      notifyListeners();
      log('Block Section Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(blockSectionCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
