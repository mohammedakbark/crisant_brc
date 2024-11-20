import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/repositories/fetch_entity_profile_repo.dart';
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';

class EnitityProfileDb with ChangeNotifier {
  static const entityProfileCollection = 'entity_profile';
  List<EntityProfileModel> _listOfEnitityProfiles = [];
  List<EntityProfileModel> get listOfEnitityProfiles => _listOfEnitityProfiles;

  Future<void> storeEnitityProfile(BuildContext context) async {
    try {
      final db = await LocalDatabaseService().initDb;

      await _clearTable();
      final result = await FetchEntityProfileRepo().fetchEntityProfile(context);
      List data = result!.data as List;
      List<EntityProfileModel> listOfEnitityProfile =
          data.map((e) => EntityProfileModel.fromJson(e)).toList();

      for (var enitityProfile in listOfEnitityProfile) {
        await db.insert(
          entityProfileCollection,
          enitityProfile.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // await db.rawInsert(
        //     'INSERT INTO $entityProfileCollection(entityProfileId,divisionId,sectionInchargeId,sectionId,blockSectionId,stationId,entityId,entityIdentifier,entityLatt,entityLong,entityStatus,entityConfirmed,status,userId,modifiedDate) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        //     [
        //       enitityProfile.entityProfileId,
        //       enitityProfile.divisionId,
        //       enitityProfile.sectionInchargeId,
        //       enitityProfile.sectionId,
        //       enitityProfile.blockSectionId,
        //       enitityProfile.stationId,
        //       enitityProfile.entityId,
        //       enitityProfile.entityIdentifier,
        //       enitityProfile.entityLatt,
        //       enitityProfile.entityLong,
        //       enitityProfile.entityStatus,
        //       enitityProfile.entityConfirmed,
        //       enitityProfile.status,
        //       enitityProfile.userId,
        //       enitityProfile.modifiedDate
        //     ]);
      }

      log('Enitity Profile  Downloaded Successful');
      await getAllEnitityProfile();
    } catch (e) {
      log('exception on adding data in to table ${e.toString()}');
    }
  }

  Future getAllEnitityProfile() async {
    final db = await LocalDatabaseService().initDb;

    try {
      final data = await db.rawQuery('SELECT * FROM $entityProfileCollection');
      _listOfEnitityProfiles =
          data.map((e) => EntityProfileModel.fromJson(e)).toList();
      notifyListeners();
      log('Enitity Profile Fetched');
    } catch (e) {
      log('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(entityProfileCollection);
      log('---table is cleared');
    } catch (e) {
      log('exception on deleting  table  ${e.toString()}');
    }
  }
}
