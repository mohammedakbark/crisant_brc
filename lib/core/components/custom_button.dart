import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const CustomButton({super.key, required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap ,
      child: Container(
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
      ),
    );
  }
}
