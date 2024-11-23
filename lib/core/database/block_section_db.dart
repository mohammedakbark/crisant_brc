import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_block_section_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/block_station_model.dart';

class BlockSectionDb with ChangeNotifier {
  static const blockSectionCollection = 'block_section';
  List<BlockSectionModel> _listOfBlockSections = [];
  List<BlockSectionModel> get listOfBlockSections => _listOfBlockSections;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;
static Future<String> getValueById(dynamic id) async {
    final db = await LocalDatabaseService().initDb;
    final List<Map<String, dynamic>> result = await db.query(
      blockSectionCollection, // Table name
      where: 'blockSectionId = ?', // WHERE clause
      whereArgs: [id], // Value for the placeholder
    );
    return result[0]['blockSectionName'];
  }
  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(blockSectionCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(blockSectionCollection) ?? '-';
  }

  Future storeBlockSections(BuildContext context, {bool? dontList}) async {
    try {
      if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
          true) {
        _isDownloading = true;
        if (dontList == null) {
          notifyListeners();
        }
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
        }

        log('Block Section Downloaded Successful');
       await setlastSync();
        await getAllBlockSections();
        _isDownloading = false;
      } else {
        showMessage(
          'Please Check Your Internet Connection',
        );
      }
    } catch (e) {
      _isDownloading = false;
      log('exception on adding data in to table ${e.toString()}');
    }
    if (dontList == null) {
      notifyListeners();
    }
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
