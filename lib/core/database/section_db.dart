import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_section_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/section_model.dart';

class SectionDb with ChangeNotifier {
  static const sectionCollection = 'section';
  List<SectionModel> _listOfSection = [];
  List<SectionModel> get listOfSection => _listOfSection;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(sectionCollection, today);
    await _getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future _getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(sectionCollection) ?? '-';
  }

  Future storeSection(BuildContext context, {bool? dontList}) async {
    try {
      if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
          true) {
        _isDownloading = true;
        if (dontList == null) {
          notifyListeners();
        }
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
        }

        log('Section  Downloaded Successful');
        await setlastSync();
        await getAllSections();
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

  Future getAllSections() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data = await db.rawQuery('SELECT * FROM $sectionCollection');
      _listOfSection = data.map((e) => SectionModel.fromJson(e)).toList();
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
