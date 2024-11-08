import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/screens/dashboard.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<LocationProvider>(
      create: (context) => LocationProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

LocationProvider _locationProvider = LocationProvider();

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _locationProvider.handleLocationPermission();
    // _locationProvider.streamCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BRC',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const DashboardScreen());
  }
}
