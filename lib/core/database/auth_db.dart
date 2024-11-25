import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:test_managment/core/services/local_db_service.dart';

class AuthDb with ChangeNotifier {
  String? _userName;
  int? _divisionId;
  String? _divisionName;
  String? _token;
  String get userName => _userName ?? '';
  String get token => _token ?? '';
  String? get divisionName => _divisionName ?? "";
  int? get divisionId => _divisionId;
  static const authtableCollection = 'auth_table';

  Future<void> storeUserData(String name, String password, int id, String token,
      String divisioNname) async {
    final db = await LocalDatabaseService().initAuthDb;
    // if (await checkUserTableExist()) {

    // }
    try {
          await clearAuthtable();
      await db.rawInsert(
          'INSERT INTO $authtableCollection(userName,divisionId,divisionName,userPassword,token) VALUES(?,?,?,?,?)',
          [name, id, divisioNname, password, token]);
      await getUserData();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future clearAuthtable() async {
    try {
      final db = await LocalDatabaseService().initAuthDb;

      await db.delete(authtableCollection);
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }

  Future<String> getUserData() async {
    try {
      final db = await LocalDatabaseService().initAuthDb;

      final datas = await db.rawQuery('SELECT * FROM $authtableCollection');
      final data = datas.first;
      _token = data['token'] as String;
      _userName = data['userName'] as String;
      _divisionId = data['divisionId'] as int;
      _divisionName = data['divisionName'] as String;
      log('user data fetched from local ');
      notifyListeners();
      return _token!;
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
      return '';
    }
  }

  // Future<void> deleteTable() async {
  //   try {
  //     final db = await LocalDatabaseService().initAuthDb;

  //     await db.execute('DROP TABLE IF EXISTS $authtableCollection');
  //     log('LOGOUT');
  //   } catch (e) {
  //     log('exception on deleting  table  ${e.toString()}');
  //   }
  // }

  Future<bool> checkUserTableExist() async {
    try {
      final db = await LocalDatabaseService().initAuthDb;
      final result = await db
          .rawQuery('SELECT COUNT(*) as count FROM $authtableCollection');
      int count = Sqflite.firstIntValue(result) ?? 0;
      if (count > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
