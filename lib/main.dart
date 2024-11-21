import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_managment/core/controller/add_asset_controller.dart';
import 'package:test_managment/core/controller/parameter_controller.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/offline_db.dart';
import 'package:test_managment/core/database/parameters_db.dart';
import 'package:test_managment/core/database/parameters_reason_db.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';

import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/controller/test_asset_controller.dart';
import 'package:test_managment/core/controller/camera_controller.dart';
import 'package:test_managment/core/controller/dashboard_controller.dart';
import 'package:test_managment/core/controller/floating_bar_controller.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/services/network_service.dart';

import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/presentation/screens/spash_screen.dart';

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
      ChangeNotifierProvider<LocationService>(
        create: (context) => LocationService(),
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
      ChangeNotifierProvider<AddAssetController>(
        create: (context) => AddAssetController(),
      ),

      //  db Poviders
      ChangeNotifierProvider<EntiteDb>(
        create: (context) => EntiteDb(),
      ),
      ChangeNotifierProvider<AuthDb>(
        create: (context) => AuthDb(),
      ),
      ChangeNotifierProvider<SectionInchargeDb>(
        create: (context) => SectionInchargeDb(),
      ),
      ChangeNotifierProvider<SectionDb>(
        create: (context) => SectionDb(),
      ),
      ChangeNotifierProvider<BlockSectionDb>(
        create: (context) => BlockSectionDb(),
      ),
      ChangeNotifierProvider<StationDb>(
        create: (context) => StationDb(),
      ),
      ChangeNotifierProvider<ParametersDb>(
        create: (context) => ParametersDb(),
      ),
      ChangeNotifierProvider<ParametersValueDb>(
        create: (context) => ParametersValueDb(),
      ),
      ChangeNotifierProvider<ParametersReasonDb>(
        create: (context) => ParametersReasonDb(),
      ),
      ChangeNotifierProvider<EnitityProfileDb>(
        create: (context) => EnitityProfileDb(),
      ),
      ChangeNotifierProvider<ParameterController>(
        create: (context) => ParameterController(),
      ),
      ChangeNotifierProvider<NetworkService>(
        create: (context) => NetworkService(),
      ),
       ChangeNotifierProvider<OfflineDb>(
        create: (context) => OfflineDb(),
      ),
    ], child: const MyApp()),
  ));

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

LocationService _locationProvider = LocationService();

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _locationProvider.handleLocationPermission();
    Provider.of<NetworkService>(context, listen: false)
        .checkInitialConnection();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BRC',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.kWhite,
              surfaceTintColor: AppColors.kWhite),
          scaffoldBackgroundColor: AppColors.kBgColor,
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kPrimaryColor),
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: SpashScreen());
  }
}
// StreamBuilder<List<ConnectivityResult>>(
//         stream: Connectivity().onConnectivityChanged,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SizedBox();
//           } else {
//             if (snapshot.hasData || snapshot.data!.isNotEmpty) {
//               if (snapshot.data!.first == ConnectivityResult.mobile ||
//                   snapshot.data!.first == ConnectivityResult.wifi) {
//                 return const MyApp();
//               } else if (snapshot.data!.first != ConnectivityResult.mobile ||
//                   snapshot.data!.first != ConnectivityResult.wifi) {
//                 log('Data is off');
//                 return const NetworkConnectivityPage();
//               } else {
//                 return const NetworkConnectivityPage();
//               }
//             } else {
//               return const NetworkConnectivityPage();
//             }
//           }
//         }),
//   ));