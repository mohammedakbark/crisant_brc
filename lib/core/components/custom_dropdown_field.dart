import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class CustomDropdownField extends StatelessWidget {
  final List<dynamic> items;
  final String hintText;
  final void Function(dynamic)? onChanged;

  const CustomDropdownField(
      {super.key,
      required this.items,
      required this.onChanged,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: w(context),
          height: 56,
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
          child: DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Select the option';
              } else {
                return null;
              }
            },
            dropdownColor: AppColors.kWhite,
            elevation: 1,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: const InputDecoration(
                fillColor: AppColors.kWhite,
                filled: true,
                errorStyle: TextStyle(color: AppColors.kRed),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: AppColors.kRed),
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5))),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: AppColors.kRed),
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5))),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.radiusSize5)))),
            items: items
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSize16(context),
                      ),
                    )))
                .toList(),
            onChanged: onChanged,
            hint: Text(
              hintText,
              style: TextStyle(
                  fontSize: AppDimensions.fontSize16(context),
                  color: AppColors.kGrey),
            ),
          ),
        ),
      ],
    );
  }
}
