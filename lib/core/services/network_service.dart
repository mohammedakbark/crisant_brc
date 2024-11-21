import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkService with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  NetworkService() {
    _connectivity.onConnectivityChanged.listen((result) {
      log('checking internet');
      _connectionController.add(isNetworkAvailable(result[0]));
      notifyListeners();
    });
  }

  bool isNetworkAvailable(ConnectivityResult result) {
    final connection = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;
    if (connection) {
      // _netisConnected = true;
      try {
        InternetAddress.lookup('example.com').then(
          (result) {
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              _netisConnected = true; // Internet is available
            } else {
              _netisConnected = false;
            }
            notifyListeners();
          },
        ); // Test with a simple domain
      } catch (e) {
        _netisConnected = false; // No internet access
      }
    } else {
      _netisConnected = false;
    }
    notifyListeners();
    return _netisConnected??false;
  }

  bool? _netisConnected;
  bool? get netisConnected => _netisConnected;
  Future<bool> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    return isNetworkAvailable(result[0]);
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
