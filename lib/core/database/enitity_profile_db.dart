import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/fetch_entity_profile_repo.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';

class EnitityProfileDb with ChangeNotifier {
  static const entityProfileCollection = 'entity_profile';
  List<EntityProfileModel> _listOfEnitityProfiles = [];
  List<EntityProfileModel> get listOfEnitityProfiles => _listOfEnitityProfiles;
  bool? _isDownloading;
  bool? get isDownloading => _isDownloading;
  static Future<String> getValueById(dynamic id) async {
    final db = await LocalDatabaseService().initDb;
    final List<Map<String, dynamic>> result = await db.query(
      entityProfileCollection, // Table name
      where: 'entityProfileId = ?', // WHERE clause
      whereArgs: [id], // Value for the placeholder
    );
    return result[0]['entityIdentifier'];
  }

  Future<void> setlastSync() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";
    await pre.setString(entityProfileCollection, today);
    await getLastSyncData();
  }

  String? _lastSyncData;
  String get lastSyncData => _lastSyncData ?? '-';
  Future getLastSyncData() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    _lastSyncData = pre.getString(entityProfileCollection) ?? '-';
  }

  Future<void> storeEnitityProfile(BuildContext context,
      {bool? dontList, bool? dontehckNet}) async {
    try {
      if (dontehckNet == null) {
        if (Provider.of<NetworkService>(context, listen: false)
                .netisConnected ==
            true) {
          await _storeProfile(dontList, context);
        } else {
          showMessage(
            'Please Check Your Internet Connection',
          );
        }
      } else {
        await _storeProfile(dontList, context);
      }
    } catch (e) {
      _isDownloading = false;

      print('exception on adding data in to table ${e.toString()}');
    }
    notifyListeners();
  }

  _storeProfile(bool? dontList, context) async {
    _isDownloading = true;
    if (dontList == null) {
      notifyListeners();
    }
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
    }

    print('Enitity Profile  Downloaded Successful');
    await setlastSync();
    await getAllEnitityProfile();
    _isDownloading = false;
  }

  Future getAllEnitityProfile() async {
    final db = await LocalDatabaseService().initDb;
    try {
      final data = await db.rawQuery('SELECT * FROM $entityProfileCollection');
      _listOfEnitityProfiles =
          data.map((e) => EntityProfileModel.fromJson(e)).toList();
      notifyListeners();
      print('Enitity Profile Fetched');
    } catch (e) {
      print('exception on getting data from table ${e.toString()}');
    }
  }

  Future _clearTable() async {
    final db = await LocalDatabaseService().initDb;

    try {
      await db.delete(entityProfileCollection);
      print('---table is cleared');
    } catch (e) {
      print('exception on deleting  table  ${e.toString()}');
    }
  }

//--------------------------------AUTO MODE------------------------------------------------------
  double calculateDistance(
      double userLat, double userLon, double entityLat, double EntityLon) {
    const earthRadius = 6371000; // Earth's radius in meters
    final dLat = _degreesToRadians(entityLat - userLat);
    final dLon = _degreesToRadians(EntityLon - userLon);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(entityLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;

  Future<List<Map<String, dynamic>>> getNearbyLocations(
      double userLat, double userLon, double radius) async {
    final db = await LocalDatabaseService().initDb;

    final allRows = await db.query(entityProfileCollection);

    return allRows.where((row) {
      final entityLat = double.parse(row['entityLatt'].toString());
      final entityLon = double.parse(row['entityLong'].toString());
      final distance =
          calculateDistance(userLat, userLon, entityLat, entityLon);
      return distance <= radius;
    }).toList();
  }

// Example usage
  Future<List<Map<String, dynamic>>> getNearestEntityProfiles(
      BuildContext context) async {
    final controller = Provider.of<LocationService>(context, listen: false);

    final userLat = controller.currentLat;
    final userLon = controller.currentLon;
    const radius = 100.0; // Radius in meters

    List<Map<String, dynamic>> locations =
        await getNearbyLocations(userLat, userLon, radius);

    // for (var location in locations) {
    //   print(
    //       'Entity Name: ${location['entityName']}, Latitude: ${location['entityLatt']}, Longitude: ${location['entityLong']}');
    // }
    return locations;
  }
}
