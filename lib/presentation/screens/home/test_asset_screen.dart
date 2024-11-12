import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/camera_controller.dart';
import 'package:test_managment/presentation/components/app_margin.dart';
import 'package:test_managment/presentation/components/app_page_head_text.dart';
import 'package:test_managment/presentation/components/app_spacer.dart';
import 'package:test_managment/presentation/components/custom_button.dart';
import 'package:test_managment/presentation/components/custom_dropdown_field.dart';
import 'package:test_managment/presentation/components/custom_form_field.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/responsive_helper.dart';

class TestAssetScreen extends StatelessWidget {
  TestAssetScreen({super.key});
  final List<String> assetsGroup = [
    'Way Station Equip',
    '4W Repeater',
    'LC Gate Phone',
    'EC Socket',
    'Battery Charger'
  ];
  final List<String> inchargeList = [
    'SSE/TELE/PRTN',
    'SSE/TELE/DB',
    'JE/TELE/CTE',
    'DUMMY/INCHARGE',
  ];
  final List<String> sections = [
    'VISHVAMITRI - DABHOLI',
  ];
  final assetIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppPageHeadText(title: 'Test Asset'),
            CustomDropdownField(
              hintText: 'Asset Group',
              items: assetsGroup,
              onChanged: (value) {},
            ),
            CustomDropdownField(
              hintText: 'Section Incharge',
              items: inchargeList,
              onChanged: (value) {},
            ),
            CustomDropdownField(
              hintText: 'Section',
              items: sections,
              onChanged: (value) {},
            ),
            CustomDropdownField(
              hintText: 'Select',
              items: sections,
              onChanged: (value) {},
            ),
            CustomDropdownField(
              hintText: 'Asset Profile',
              items: sections,
              onChanged: (value) {},
            ),
            const AppSpacer(
              heightPortion: .03,
            ),
            imagePicker(context),
            const AppSpacer(
              heightPortion: .05,
            ),
            const CustomButton(title: 'SUBMIT')
          ],
        ),
      ),
    );
  }

  Widget imagePicker(BuildContext context) {
    return Consumer<CameraController>(builder: (context, controller, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Picture',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const AppSpacer(
            heightPortion: .015,
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 1,
                    color: AppColors.kBlack.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1)),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        titlePadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingSize5,
                            horizontal: AppDimensions.paddingSize20),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingSize10,
                            horizontal: AppDimensions.paddingSize20),
                        shape: const BeveledRectangleBorder(),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add photo',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppDimensions.fontSize24(context)),
                            ),
                            _diologueButton(context, () {
                              controller.onPickImage();
                              
                            }, 'Take Photo'),
                            _diologueButton(context, () {}, 'Cancel',
                                color: AppColors.kRed)
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: w(context) * .25,
                    height: h(context) * .07,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text(
                      'Capture',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.kWhite),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSize5),
                    alignment: Alignment.centerLeft,
                    height: h(context) * .07,
                    width: w(context),
                    decoration: const BoxDecoration(color: AppColors.kWhite),
                    child: Text(
                      controller.fileImage != null
                          ? 'Image Captured'
                          : 'No File Selected',
                      style: const TextStyle(color: AppColors.kGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _diologueButton(
      BuildContext context, void Function()? onTap, String title,
      {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingSize10),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
