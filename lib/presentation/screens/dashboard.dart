import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/controller/dashboard_controller.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/components/overlay_location_banner.dart';
import 'package:test_managment/core/services/shared_pre_service.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/presentation/screens/home/add_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/download_data.dart';
import 'package:test_managment/presentation/screens/home/home_screen.dart';
import 'package:test_managment/presentation/screens/home/test_asset_screen.dart';
import 'package:test_managment/presentation/screens/home/view_assets_screen.dart';
import 'package:test_managment/presentation/screens/home/widgets/floating_location_bar.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late LocationService _locationProvider;
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    _locationProvider = Provider.of<LocationService>(context, listen: false);
    _locationProvider.addListener(_handleLocationStatusChange);
    _locationProvider.startMonitoring();
    // final detailsareUpdated =
    //         await Provider.of<SharedPreService>(context, listen: false)
    //             .dataisUpdated;
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
    final c = Provider.of<SharedPreService>(
      context,
    );
    return FutureBuilder(
        future: c.dataisUpdated,
        builder: (context, snapshot) {
          // if (snapshot.data == null || snapshot.data == false) {
          //   return Scaffold(
          //     appBar: const HomeAppBar(),
          //     body: const Center(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           AppLoadingIndicator(),
          //           AppSpacer(
          //             widthPortion: .06,
          //           ),
          //           Text(
          //             'Please wait until Downloading complete',
          //             style: TextStyle(fontWeight: FontWeight.w500),
          //           ),
          //         ],
          //       ),
          //     ),
          //     bottomNavigationBar: bottomNav(controller, functioning: true),
          //   );
          // }
          return Scaffold(
              body: pages[controller.currentScreenIndex],
              bottomNavigationBar: bottomNav(controller)
              // floatingActionButton: FloatingActionButton(
              //   shape: const CircleBorder(),
              //   tooltip: 'Download Data',
              //   backgroundColor: AppColors.kPrimaryColor,
              //   onPressed: () {

              //   },
              //   child: const Icon(color: AppColors.kWhite, Icons.sync),
              // ),
              );
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
                  label: 'VIEW REPORT',
                  icon: Icon(
                    Icons.auto_graph_sharp,
                  ),
                  activeIcon: CircleAvatar(
                    backgroundColor: AppColors.kPrimaryColor,
                    child: Icon(
                      Icons.file_open_outlined,
                      color: AppColors.kWhite,
                    ),
                  ))
            ]),
      );
}
