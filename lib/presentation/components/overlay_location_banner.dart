import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class LocationBanner extends StatelessWidget {
  const LocationBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSize15,
            vertical: AppDimensions.paddingSize10),
        color: Colors.black87,
        child: SafeArea(
          child: Row(
            children: [
              const Icon(
                Icons.location_off_outlined,
                color: AppColours.kWhite,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Location services are disabled',
                  style: TextStyle(color: AppColours.kWhite),
                ),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                },
                child: const Text(
                  'ENABLE',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
