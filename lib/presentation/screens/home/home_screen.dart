import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:test_managment/presentation/screens/home/widgets/app_drawer.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

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
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),
      body: Consumer<LocationService>(builder: (context, controller, _) {
        if (controller.currentLat != 0 || controller.currentLon != 0) {
          return GoogleMap(
            onMapCreated: (gMapController) async {
              try {
                await controller
                    .getCurrentLocation(); // gMapController.getLatLng(ScreenCoordinate(x: x, y: y))
                await gMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target:
                          LatLng(controller.currentLat, controller.currentLon),
                      zoom: 15.0, // Adjust zoom level as needed
                    ),
                  ),
                );
              } catch (e) {
                log('- gMap - ${e.toString()}');
              }
            },
            minMaxZoomPreference: const MinMaxZoomPreference(15, 15),
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
                target: LatLng(controller.currentLat, controller.currentLon)),
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
          );
        } else {
          return const AppLoadingIndicator();
        }
      }),
    );
  }
}
