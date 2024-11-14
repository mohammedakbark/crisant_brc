import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';

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
      child: DropdownButtonFormField(
        dropdownColor: AppColors.kWhite,
        elevation: 1,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: const InputDecoration(
            fillColor: AppColors.kWhite,
            filled: true,
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
        onChanged: (value) {},
        hint: Text(
          hintText,          style: TextStyle(
              fontSize: AppDimensions.fontSize16(context),
              color: AppColors.kGrey),
        ),
      ),
    );
  }
}
