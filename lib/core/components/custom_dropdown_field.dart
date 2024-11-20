import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class CustomDropdownField extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String hintText;
  final void Function(Map<String, dynamic>) onCallBack;

  const CustomDropdownField({
    super.key,
    required this.items,
    required this.onCallBack,
    required this.hintText,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    // Debugging items and selected value
    // log('Dropdown items: ${widget.items.map((e) => e['title'])}');
    // log('Selected value: $_selectedValue');

    return Stack(
      children: [
        Container(
          width: w(context),
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimensions.radiusSize5),
            ),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: AppColors.kBlack.withOpacity(0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
          child: DropdownButtonFormField<String>(
            value: widget.items.any((e) => e['title'] == _selectedValue)
                ? _selectedValue
                : null, // Reset if value doesn't match any item
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
            dropdownColor: AppColors.kWhite,
            elevation: 1,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: const InputDecoration(
              fillColor: AppColors.kWhite,
              filled: true,
              errorStyle: TextStyle(color: AppColors.kRed),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kRed),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize5),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kRed),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize5),
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusSize5),
                ),
              ),
            ),
            items: widget.items
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e['title'], // Ensure this matches the key used in the value
                    onTap: () {
                      try {
                        widget.onCallBack(e);
                      } catch (err) {
                        log('Error in dropdown onTap: ${err.toString()}');
                      }
                    },
                    child: Text(
                      e['title'],
                      style: TextStyle(
                        fontSize: AppDimensions.fontSize16(context),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
            hint: Text(
              widget.hintText,
              style: TextStyle(
                fontSize: AppDimensions.fontSize16(context),
                color: AppColors.kGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
