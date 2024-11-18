import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/components/common_widgets.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_drawer.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController gMapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        leading: const DrawerButton(
          color: AppColors.kBlack,
        ),
        title: Text(
          'Hi Crisant',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.kBlack,
              fontSize: AppDimensions.fontSize18(context)),
        ),
        actions: [
          PopupMenuButton(
            color: AppColors.kBgColor,
            initialValue: 'English',
            tooltip: 'Language',
            icon: Row(
              children: [
                Text(
                  context.locale.languageCode == 'en' ? 'English' : 'हिन्दी',
                  style: const TextStyle(color: AppColors.kBlack),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.kBlack,
                )
              ],
            ),
            onSelected: (value) {
              context.setLocale(Locale(value));
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(value: 'en', child: Text('English')),
                const PopupMenuItem(value: 'hi', child: Text('हिन्दी'))
              ];
            },
          ),
        ],
      ),
      drawer: const HomeDrawer(),
      body: Consumer<LocationProvider>(builder: (context, controller, _) {
        if (controller.currentLat != null || controller.currentLon != null) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (gMapController) async {
                  try {
                    await controller
                        .getCurrentLocation(); // gMapController.getLatLng(ScreenCoordinate(x: x, y: y))
                    await gMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                              controller.currentLat, controller.currentLon),
                          zoom: 15.0, // Adjust zoom level as needed
                        ),
                      ),
                    );
                  } catch (e) {
                    log('- gMap - ${e.toString()}');
                  }
                },
                minMaxZoomPreference:const  MinMaxZoomPreference(15, 15),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                buildingsEnabled: false,
                compassEnabled: true,
                liteModeEnabled: false, // rediretion to google map
                mapToolbarEnabled: true,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: true,
                indoorViewEnabled: true,
                fortyFiveDegreeImageryEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                trafficEnabled: true,

                initialCameraPosition: CameraPosition(
                    target:
                        LatLng(controller.currentLat, controller.currentLon)),
                mapType: MapType.normal,
                myLocationEnabled: true,

                // markers: {
                //   Marker(
                //       icon: BitmapDescriptor.defaultMarkerWithHue(
                //           BitmapDescriptor.hueAzure),
                //       position: LatLng(
                //           controller.currentLat!, controller.currentLon!),
                //       markerId: MarkerId('1'))
                // },
              ),
            ],
          );
        } else {
          return const AppLoadingIndicator();
        }
      }),
    );
  }
}
