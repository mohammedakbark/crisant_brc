import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_managment/controller/dashboard_controller.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/components/overlay_location_banner.dart';
import 'package:test_managment/presentation/screens/home/add_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/download_data.dart';
import 'package:test_managment/presentation/screens/home/home_screen.dart';
import 'package:test_managment/presentation/screens/home/test_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/view_assets_screen.dart';
import 'package:test_managment/presentation/screens/home/widgets/floating_location_bar.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/route.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late LocationProvider _locationProvider;
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _locationProvider.addListener(_handleLocationStatusChange);
    _locationProvider.startMonitoring();
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
    _locationProvider.dispose();
    _removeLocationBanner();
    super.dispose();
  }

  List<Widget> pages = [
    HomeScreen(),
    AddAssetScreen(),
    TestAssetScreen(),
    const ViewAssetsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DashboardController>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            pages[controller.currentScreenIndex],
            Consumer<LocationProvider>(builder: (context, controller, _) {
              return Visibility(
                  visible: controller.showFloatingLocation,
                  child: FloatingDirectionBar());
            }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.kWhite,
            onTap: controller.onChagePageIndex,
            currentIndex: controller.currentScreenIndex,
            selectedLabelStyle: TextStyle(
              fontSize: AppDimensions.fontSize10(context),
            ),
            unselectedLabelStyle: TextStyle(
                fontSize: AppDimensions.fontSize10(context),
                fontWeight: FontWeight.bold),
            selectedItemColor: AppColors.kPrimaryColor,
            unselectedItemColor: AppColors.kGrey,
            items: const [
              BottomNavigationBarItem(
                  label: 'HOME',
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  activeIcon: CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.home_outlined,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'ADD ASSET',
                  icon: Icon(
                    Icons.playlist_add_sharp,
                  ),
                  activeIcon: CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.playlist_add_sharp,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'TEST ASSET',
                  icon: Icon(
                    Icons.playlist_add_check_outlined,
                  ),
                  activeIcon: CircleAvatar(
                      backgroundColor: AppColors.kPrimaryColor,
                      child: Icon(
                        Icons.playlist_add_check_outlined,
                        color: AppColors.kWhite,
                      ))),
              BottomNavigationBarItem(
                  label: 'VIEW TEST ASSET',
                  icon: Icon(
                    Icons.file_open_outlined,
                  ),
                  activeIcon: CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor,
                    child: Icon(
                      Icons.file_open_outlined,
                      color: AppColors.kWhite,
                    ),
                  ))
            ]),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          tooltip: 'Download Data',
          backgroundColor: AppColors.kPrimaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(AppRoutes.createRoute(DownloadDataScreen()));
          },
          child: const Icon(color: AppColors.kWhite, Icons.sync),
        ),
      ),
    );
  }
}
