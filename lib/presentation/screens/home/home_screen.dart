import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/components/common_widgets.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_drawer.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: Consumer<LocationProvider>(builder: (context, controller, _) {
        if (controller.currentLat != null || controller.currentLon != null) {
          return Stack(
            children: [
              GoogleMap(
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                buildingsEnabled: true,
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
              HomeAppBar()
            ],
          );
        } else {
          return const AppLoadingIndicator();
        }
      }),
    );
  }
}
