import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_entity_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/entity_model.dart';

class EntiteDb with ChangeNotifier {
  static const entitiesCollection = 'entities';
  List<EntityModel> _listOfEntityData = [];
  List<EntityModel> get listOfEntityData => _listOfEntityData;
  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;
  Future storeEntity(BuildContext context, {bool? dontList}) async {
    try {
      if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
          true) {
        _isDownloading = true;
        if (dontList == null) {
          notifyListeners();
        }
        final db = await LocalDatabaseService().initDb;

        await _clearTable();
        final result = await FetchEntityRepo().fetchEntities(context);
        List data = result!.data as List;
        List<EntityModel> listOFEntity =
            data.map((e) => EntityModel.fromJson(e)).toList();

        for (var entity in listOFEntity) {
          await db.insert(
            entitiesCollection,
            entity.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          // await db.rawInsert(
          //     'INSERT INTO $entitiesCollection(entityId,entityName,pictureRequired,periodicity,entityType) VALUES(?,?,?,?,?)',
          //     [
          //       entity.entityId,
          //       entity.entityName,
          //       entity.pictureRequired,
          //       entity.periodicity,
          //       entity.entityType
          //     ]);
        }

        log('Entity Downloaded Successful');
        await getAllEntities();
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

  Future getAllEntities() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data = await db.rawQuery('SELECT * FROM $entitiesCollection');
      _listOfEntityData = data.map((e) => EntityModel.fromJson(e)).toList();
      notifyListeners();
      log('Entity Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(entitiesCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
