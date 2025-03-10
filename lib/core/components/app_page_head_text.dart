import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class AppPageHeadText extends StatelessWidget {
  final String title;
  const AppPageHeadText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.fontSize18(context)),
    );
  }
}
