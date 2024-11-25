import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/database/offline_add_entity_db.dart';
import 'package:test_managment/core/database/offline_test_entity_db.dart';

class NetworkService with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  NetworkService(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((result) {
      log('checking internet');
      _connectionController.add(isNetworkAvailable(result[0], context));
      notifyListeners();
    });
  }

  bool isNetworkAvailable(ConnectivityResult result, BuildContext context) {
    final connection = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
    if (connection) {
      // _netisConnected = true;
      try {
        InternetAddress.lookup('example.com').then(
          (result) {
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              _netisConnected = true;
              showMessage('onlineModeCap'.tr());

              // Internet is available
              // Provider.of<OfflineAddEntityDb>(context, listen: false)
              //     .offlineAddAssetToServer(context, dontehckNet: true);
              // Provider.of<OfflineTestEntityDb>(context, listen: false)
              //     .offlineSyncTestToServer(context, fontCheckNet: true);
            } else {
              _netisConnected = false;
              showMessage('offlineModeCap'.tr());
            }
            notifyListeners();
          },
        ); // Test with a simple domain
      } catch (e) {
        _netisConnected = false; // No internet access
        showMessage('offlineModeCap'.tr());
      }
    } else {
      _netisConnected = false;
      showMessage('offlineModeCap'.tr());
    }
    notifyListeners();
    return _netisConnected ?? false;
  }

  bool? _netisConnected;
  bool? get netisConnected => _netisConnected ?? false;
  Future<bool> checkInitialConnection(BuildContext context) async {
    final result = await _connectivity.checkConnectivity();
    return isNetworkAvailable(result[0], context);
  }

  void dispose() {
    _connectionController.close();
  }

  // Future<bool> isNetworkAvailable(ConnectivityResult connection) async {
  //   // Check connectivity type
  //   // var connectivityResult = await Connectivity().checkConnectivity();
  //   // if (connectivityResult == ConnectivityResult.none) {
  //   //   return false; // Not connected to any network
  //   // }

  //   // Verify actual internet access
  //   try {
  //     final result = await InternetAddress.lookup(
  //         'example.com'); // Test with a simple domain
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       return true; // Internet is available
  //     }
  //   } catch (e) {
  //     return false; // No internet access
  //   }
  //   return false; // Default case
  // }
}
