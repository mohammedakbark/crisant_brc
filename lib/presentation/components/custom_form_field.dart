import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/responsive_helper.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final bool? isRequiredField;
  final TextEditingController controller;

  const CustomFormField(
      {super.key,
      required this.controller,
      required this.hintText,    
      this.isRequiredField});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: w(context),
          height: 53,
          margin:
              const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimensions.radiusSize5)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  color: AppColors.kBlack.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1)),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
          child: TextFormField(
            validator: (value) {
              if (isRequiredField == true) {
                if (value!.isEmpty) {
                  return 'This field is required';
                } else {
                  return null;
                }
              } else {
                return null;
              }
            },
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
                errorStyle: const TextStyle(color: AppColors.kRed),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: AppColors.kRed),
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5))),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: AppColors.kRed),
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5))),
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5)))),
          ),
        ),
      ],
    );
  }
}
