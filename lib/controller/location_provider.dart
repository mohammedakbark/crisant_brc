import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Future<bool> handleLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    } else {}
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openLocationSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
    return Geolocator.isLocationServiceEnabled();
  }

  //----Current Location
  double? currentLat;
  double? currentLon;

  _streamCurrentLocation() {
    return Geolocator.getCurrentPosition().then((value) {
      currentLat = value.latitude;
      currentLon = value.longitude;
    });
  }

  //-----Location Settings

  bool _isLocationEnabled = false;
  bool get isLocationEnabled => _isLocationEnabled;
  Timer? _locationCheckTimer;

  void startMonitoring() {
    _checkLocationStatus();
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkLocationStatus();
    });
  }

  Future<void> _checkLocationStatus() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (locationEnabled != _isLocationEnabled) {
      _isLocationEnabled = locationEnabled;
    }
    if (locationEnabled) {
      _streamCurrentLocation();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    super.dispose();
  }
}
