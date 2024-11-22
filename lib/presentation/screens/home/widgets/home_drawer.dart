import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/controller/dashboard_controller.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/core/services/shared_pre_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/presentation/screens/home/download_data.dart';
import 'package:test_managment/presentation/screens/spash_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: w(context) * .6,
      shape: const BeveledRectangleBorder(),
      backgroundColor: AppColors.kBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: w(context),
            child: DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.kWhite),
              child: Text(
                textAlign: TextAlign.center,
                'Welcome\n${Provider.of<AuthDb>(context, listen: false).userName}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlack,
                    fontSize: AppDimensions.fontSize18(context)),
              ),
            ),
          ),
          _buildButton('HOME', Icons.home_outlined, 0),
          _buildButton('ADD ASSET', Icons.playlist_add_sharp, 1),
          _buildButton('TEST ASSET', Icons.playlist_add_check_outlined, 2),
          _buildButton('VIEW REPORT', Icons.auto_graph_sharp, 3),
          _buildButton('DATA', Icons.storage, 4),
          // InkWell(
          //   onTap: () {
          //     Provider.of<SharedPreService>(context, listen: false)
          //         .deletedData();
          //   },
          //   child: const Text('data'),
          // ),
          const AppSpacer(
            heightPortion: .05,
          ),
          Builder(builder: (context) {
            return Consumer<NetworkService>(builder: (context, net, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    net.netisConnected == true ? "ONLINE MODE" : "OFFLINE MODE",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            });
          }),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              } else if (snapshot.hasError) {
                return Text("Error loading version info");
              } else if (snapshot.hasData) {
                final packageInfo = snapshot.data!;
                final version = packageInfo.version;
                final buildNumber = packageInfo.buildNumber;

                return Text(
                  "App version: $version",
                  style: TextStyle(fontSize: 16),
                );
              } else {
                return Text("No version info available");
              }
            },
          ),
          const AppSpacer(
            heightPortion: .05,
          ),
          CustomButton(
              butonColor: AppColors.kRed,
              title: 'LOGOUT',
              onTap: () async {
                await Provider.of<AuthDb>(context, listen: false)
                    .clearAuthtable();
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(const SpashScreen()),
                  (route) => false,
                );
              }),
        ],
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, int index) {
    return Consumer<DashboardController>(builder: (context, controller, _) {
      return ListTile(
        onTap: () {
          if (index == 4) {
            Navigator.of(context)
                .push(AppRoutes.createRoute(DownloadDataScreen()));
          } else {
            controller.onChagePageIndex(index);
          }
        },
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(
              fontSize: AppDimensions.fontSize15(context),
              fontWeight: FontWeight.bold),
        ),
      );
    });
  }
}
