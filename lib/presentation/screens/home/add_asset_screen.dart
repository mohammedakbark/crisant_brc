import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/presentation/components/app_margin.dart';
import 'package:test_managment/presentation/components/app_page_head_text.dart';
import 'package:test_managment/presentation/components/app_spacer.dart';
import 'package:test_managment/presentation/components/custom_button.dart';
import 'package:test_managment/presentation/components/custom_dropdown_field.dart';
import 'package:test_managment/presentation/components/custom_form_field.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class AddAssetScreen extends StatelessWidget {
  AddAssetScreen({super.key});
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
      child: Column(
        children: [
          const AppPageHeadText(title: 'Add Asset'),
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
          CustomFormField(
              controller: assetIdController, hintText: 'Asset ID / SL#'),
          const AppSpacer(
            heightPortion: .05,
          ),
           CustomButton(title: 'SUBMIT',onTap: () {
            
          },)
        ],
      ),
    );
  }
}
