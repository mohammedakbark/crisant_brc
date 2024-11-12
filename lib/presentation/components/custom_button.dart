import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class CustomButton extends StatelessWidget {
  final String title;
  const CustomButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSize18)),
      padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSize10 + 2,
          horizontal: AppDimensions.paddingSize30),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.kWhite, fontWeight: FontWeight.bold),
      ),
    );
  }
}
