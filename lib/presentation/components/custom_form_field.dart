import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomFormField(
      {super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(AppDimensions.radiusSize5)),
        boxShadow: [
          BoxShadow(
              spreadRadius: 1,
              color: AppColors.kBlack.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1)),
        ],
      ),
      child: TextFormField(
        style: TextStyle(
          fontSize: AppDimensions.fontSize16(context),
        ),
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: AppDimensions.fontSize16(context),
                color: AppColors.kGrey),
            fillColor: AppColors.kWhite,
            filled: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                    Radius.circular(AppDimensions.radiusSize5)))),
      ),
    );
  }
}
