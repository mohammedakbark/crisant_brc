import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class AppMargin extends StatelessWidget {
  final Widget child;
  const AppMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize10),
      child: child,
    );
  }
}
