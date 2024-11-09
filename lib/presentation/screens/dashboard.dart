import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/components/overlay_location_banner.dart';
import 'package:test_managment/presentation/screens/page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LocationProvider>(builder: (context, controller, _) {
        if (controller.currentLat != null || controller.currentLon != null) {
          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
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
                      target: LatLng(
                          controller.currentLat!, controller.currentLon!)),
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
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
