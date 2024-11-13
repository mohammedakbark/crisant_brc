import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  double? _currentLat;
  double? _currentLon;
  double get currentLat => _currentLat!;
  double get currentLon => _currentLon!;
  _streamCurrentLocation() {
    return Geolocator.getCurrentPosition().then((value) {
      _currentLat = value.latitude;
      _currentLon = value.longitude;
      if (showFloatingLocation) {
        _updateLocation();
      }
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

  // location finder

  final locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 3, // Update every 10 meters
  );
  double distance = double.infinity;
  bool isNearTarget = false;
  double? _targetLat;
  double? _targetLon;

  bool _showFloatingLocation = false;
  bool get showFloatingLocation => _showFloatingLocation;

  showFlaotingLocation(bool show, {double? targetLat, double? targetLon}) {
    _showFloatingLocation = show;
    _targetLat = targetLat;
    _targetLon = targetLon;
    notifyListeners();
  }

  _updateLocation() {
    distance = Geolocator.distanceBetween(
        currentLat, currentLon, _targetLat!, _targetLon!);
    isNearTarget = distance <= 5;
    _getDirectionGuidance();
    notifyListeners(); // Within 5 meters is Nearest
  }

  // bearing

  double bearing = 0;
  String _direction = 'Unknown';
  String get direction => _direction;
  String _getDirectionGuidance() {
    bearing = Geolocator.bearingBetween(
        currentLat, currentLon, _targetLat!, _targetLon!);

    if (bearing >= -22.5 && bearing < 22.5) {
      _direction = 'North';
    } else if (bearing >= 22.5 && bearing < 67.5) {
      _direction = 'Northeast';
    } else if (bearing >= 67.5 && bearing < 112.5) {
      _direction = 'East';
    } else if (bearing >= 112.5 && bearing < 157.5) {
      _direction = 'Southeast';
    } else if (bearing >= 157.5 || bearing < -157.5) {
      _direction = 'South';
    } else if (bearing >= -157.5 && bearing < -112.5) {
      _direction = 'Southwest';
    } else if (bearing >= -112.5 && bearing < -67.5) {
      _direction = 'West';
    } else if (bearing >= -67.5 && bearing < -22.5) {
      _direction = 'Northwest';
    }

    return 'Head $direction for ${(distance / 1000).toStringAsFixed(4)} Km';
  }
}
