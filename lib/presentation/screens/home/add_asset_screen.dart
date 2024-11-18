import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/controller/add_asset_controller.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/components/custom_dropdown_field.dart';
import 'package:test_managment/core/components/custom_form_field.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

class AddAssetScreen extends StatefulWidget {
  AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
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

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AddAssetController>(context, listen: false).clearAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppPageHeadText(title: 'Add Asset'),
            AppMargin(
              child: Column(
                children: [
                  Consumer<AddAssetController>(builder: (context, ctlr, child) {
                    return CustomDropdownField(
                      hintText: 'Asset Group',
                      items: assetsGroup,
                      onChanged: ctlr.onChangeAsetGroup,
                    );
                  }),
                  Consumer<AddAssetController>(builder: (context, ctlr, child) {
                    return CustomDropdownField(
                      hintText: 'Section Incharge',
                      items:
                          ctlr.selectedAssetGroup == null ? [] : inchargeList,
                      onChanged: ctlr.onChangedSectionIncharge,
                    );
                  }),
                  Consumer<AddAssetController>(builder: (context, ctlr, child) {
                    return CustomDropdownField(
                      hintText: 'Section',
                      items:
                          ctlr.selectedSectonIncharge == null ? [] : sections,
                      onChanged: ctlr.onChangedSection,
                    );
                  }),
                  Consumer<AddAssetController>(builder: (context, ctlr, child) {
                    return CustomDropdownField(
                      hintText: 'Asset Type',
                      items: ctlr.selectedSection == null
                          ? []
                          : ['Block', 'Station'],
                      onChanged: (value) => ctlr.onchangeTheAssetType(value),
                    );
                  }),
                  Consumer<AddAssetController>(builder: (context, ctlr, child) {
                    return ctlr.isTheAssetisBlock
                        ? CustomDropdownField(
                            hintText: 'Block',
                            items: ctlr.selectedStationType == null
                                ? []
                                : ['Pathapnagar'],
                            onChanged: ctlr.onChangedStations,
                          )
                        : CustomDropdownField(
                            hintText: 'Station',
                            items: ctlr.selectedStationType == null
                                ? []
                                : ['Pathapnagar'],
                            onChanged: ctlr.onChangedStations,
                          );
                  }),
                  CustomFormField(
                      isRequiredField: true,
                      controller: assetIdController,
                      hintText: 'Asset ID / SL#'),
                  const AppSpacer(
                    heightPortion: .05,
                  ),
                  CustomButton(
                    title: 'SUBMIT',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
