import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/controller/dashboard_controller.dart';
import 'package:test_managment/core/services/lang_service.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/components/overlay_location_banner.dart';
import 'package:test_managment/core/services/shared_pre_service.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/presentation/screens/home/add_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/home_screen.dart';
import 'package:test_managment/presentation/screens/home/test_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/view_assets_screen.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late LocationService _locationProvider;
  bool isDataDowloaded = false;
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    _locationProvider = Provider.of<LocationService>(context, listen: false);
    _locationProvider.addListener(_handleLocationStatusChange);
    _locationProvider.startMonitoring();
    //
  }

  void _handleLocationStatusChange() {
    if (!_locationProvider.isLocationEnabled) {
      _showLocationBanner();
    } else {
      _removeLocationBanner();
    }
  }

  void _showLocationBanner() {
    _removeLocationBanner();
    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: LocationBanner(),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeLocationBanner() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    // _locationProvider.dispose();
    _removeLocationBanner();
    super.dispose();
  }

  List<Widget> pages = [
    HomeScreen(),
    const AddAssetScreen(),
    TestAssetScreen(),
    const ViewAssetsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DashboardController>(context);

    return Consumer<SharedPreService>(builder: (context, contro, child) {
      return FutureBuilder<bool>(
          future: contro.dataisUpdated,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Consumer<LanguageService>(builder: (context, serive, _) {
                  return Scaffold(
                      // appBar: AppBar(
                      //   title: TextButton(
                      //       onPressed: () async {
                      //         // log(bs.toString());
                      //         contro.deletedData();
                      //       },
                      //       child: Text('data')),
                      // ),
                      body: pages[controller.currentScreenIndex],
                      bottomNavigationBar: bottomNav(controller));
                });
              } else {
                LocalDatabaseService()
                    .dowloadAllData(context, dontListen: true);
                return Scaffold(
                  appBar: const HomeAppBar(),
                  body:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'pleaseWaitDashboard'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const AppSpacer(
                          heightPortion: .06,
                        ),
                        const AppLoadingIndicator(),
                      ],
                    ),
                  ),
                  bottomNavigationBar: bottomNav(controller, functioning: true),
                );
              }
            } else {
              return const SizedBox();
            }
          });
    });
  }

  Widget bottomNav(DashboardController controller, {bool? functioning}) =>
      SizedBox(
        height: h(context) * .09,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.kWhite,
            onTap: functioning == null ? controller.onChagePageIndex : null,
            currentIndex: controller.currentScreenIndex,
            selectedLabelStyle: TextStyle(
              fontSize: AppDimensions.fontSize13(context),
            ),
            unselectedLabelStyle: TextStyle(
                fontSize: AppDimensions.fontSize12(context),
                fontWeight: FontWeight.bold),
            selectedItemColor: AppColors.kPrimaryColor,
            unselectedItemColor: AppColors.kGrey,
            items: [
              BottomNavigationBarItem(
                  label: 'homeLarge'.tr(),
                  icon: const Icon(
                    Icons.home_outlined,
                  ),
                  activeIcon: const CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.home_outlined,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'addAssetCap'.tr(),
                  icon: const Icon(
                    Icons.playlist_add_sharp,
                  ),
                  activeIcon: const CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.playlist_add_sharp,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'testAssetCap'.tr(),
                  icon: const Icon(
                    Icons.playlist_add_check_outlined,
                  ),
                  activeIcon: const CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.playlist_add_check_outlined,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'viewReposrCap'.tr(),
                  icon: const Icon(
                    Icons.auto_graph_sharp,
                  ),
                  activeIcon: const CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor,
                    child: Icon(
                      Icons.file_open_outlined,
                      color: AppColors.kWhite,
                    ),
                  ))
            ]),
      );
}
