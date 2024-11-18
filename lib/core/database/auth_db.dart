import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:test_managment/core/services/local_service.dart';

class AuthDb with ChangeNotifier {
  String? _userName;
  String? _token;
  String get userName => _userName ?? '';
  String get token => _token ?? '';
  static const authtableCollection = 'auth_table';

  Future<void> storeUserData(
      String name, String password, int id, String token) async {
    final db = await LocalDatabaseService().initAuthDb;
   await clearAuthtable();
    try {
      await db.rawInsert(
          'INSERT INTO $authtableCollection(userName,divisionId,userPassword,token) VALUES(?,?,?,?)',
          [name, id, password, token]);
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

      final datas =
          await db!.rawQuery('SELECT * FROM $authtableCollection');
      final data = datas.first;
      _token = data['token'] as String;
      _userName = data['userName'] as String;
      log('user data fetched from local ');
      notifyListeners();
      return _token!;
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
      return '';
    }
  }
}