import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/text_asset_controller.dart';
import 'package:test_managment/controller/camera_controller.dart';
import 'package:test_managment/controller/dashboard_controller.dart';
import 'package:test_managment/controller/floating_bar_controller.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/screens/dashboard.dart';
import 'package:test_managment/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale(
        'hi',
      )
    ],

    fallbackLocale: const Locale(
      'en',
    ), // Default language,

    path: 'assets/language', // Path to your language files
    child: MultiProvider(providers: [
      ChangeNotifierProvider<LocationProvider>(
        create: (context) => LocationProvider(),
      ),
      ChangeNotifierProvider<DashboardController>(
        create: (context) => DashboardController(),
      ),
      ChangeNotifierProvider<CameraController>(
        create: (context) => CameraController(),
      ),
      ChangeNotifierProvider<FloatingBarController>(
        create: (context) => FloatingBarController(),
      ),
      ChangeNotifierProvider<TestAssetsController>(
        create: (context) => TestAssetsController(),
      ),
    ], child: const MyApp()),
  ));
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
          scaffoldBackgroundColor: AppColors.kBgColor,
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kPrimaryColor),
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale, // Automatically uses the selected locale
        home: const DashboardScreen());
  }
}
