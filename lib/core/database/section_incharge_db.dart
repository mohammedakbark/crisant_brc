import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_section_incharge_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/section_incharge_model.dart';

class SectionInchargeDb with ChangeNotifier {
  static const sectionInchargeCollection = 'sectionIncharge';
  List<SectionInchargeModel> _listOfSectionIncharge = [];
  List<SectionInchargeModel> get listOfSectionIncharge =>
      _listOfSectionIncharge;

  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;

  static Future<String?> getValueById(dynamic id) async {
    // log(id.toString());

    try {
      final db = await LocalDatabaseService().initDb;
      final List<Map<String, dynamic>> result = await db.query(
        sectionInchargeCollection, // Table name
        where: 'sectionInchargeId = ?', // WHERE clause
        whereArgs: [id], // Value for the placeholder
      );
      if (result.isEmpty) {
        return null;
      } else {
        return result[0]['sectionInchargeName'];
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(sectionInchargeCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(sectionInchargeCollection) ?? '-';
  }

  Future storeSectionIncharges(BuildContext context, {bool? dontList}) async {
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
        }

        log('Section Incharge Downloaded Successful');
        await setlastSync();
        await getAllSectionIncharges();

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
