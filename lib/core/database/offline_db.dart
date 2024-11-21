import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/services/local_service.dart';

class OfflineDb with ChangeNotifier {
  static const offlineCollectionTable = 'offline_collection';

  addToOfflineDb() async {
    try {
      final db = await LocalDatabaseService().initOfflineDb;
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }
}
