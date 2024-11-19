import 'dart:developer';

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
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/model/add_new_asset_model.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

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
    super.initState();
    Provider.of<AddAssetController>(context, listen: false).clearAllData();
    // getData();
  }

  // List<Map<String, dynamic>> listOfassetsGroup = [];
  // getData() async {
  //   final obj = Provider.of<EntiteDb>(context, listen: false);
  //   await obj.getAllEntities();
  //   listOfassetsGroup = obj.listOfEntityData.map((e) {
  //     log(e.entityId);
  //     return {'title ': e.entityName, 'id': e.entityId};
  //   }).toList();
  //   // await Provider.of<EntiteDb>(context, listen: false).get();
  // }

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
                  Consumer2<AddAssetController, EntiteDb>(
                      builder: (context, ctlr, ctrl2, child) {
                    return CustomDropdownField(
                      onCallBack: (p0) {
                        ctlr.onChangeEnitity(p0);
                      },
                      hintText: 'Asset Group',
                      items: ctrl2.listOfEntityData
                          .map((map) => {
                                'title': map.entityName,
                                'id': map.entityId,
                                'entityType': map.entityType
                              })
                          .toList(),
                      // onChanged:
                    );
                  }),
                  Consumer2<AddAssetController, SectionInchargeDb>(
                      builder: (context, ctlr, ctlr2, child) {
                    return CustomDropdownField(
                      onCallBack: ctlr.onChangedSectionIncharge,
                      hintText: 'Section Incharge',
                      items: ctlr.selectedEntityId == null
                          ? []
                          : ctlr2.listOfSectionIncharge
                              .map((map) => {
                                    'title': map.sectionInchargeName,
                                    'id': map.sectionInchargeId
                                  })
                              .toList(),
                      // onChanged: ctlr.onChangedSectionIncharge,
                    );
                  }),
                  Consumer2<AddAssetController, SectionDb>(
                      builder: (context, ctlr, ctrl2, child) {
                    return CustomDropdownField(
                      onCallBack: ctlr.onChangedSection,
                      hintText: 'Section',
                      items: ctlr.selectedSectonInchargeId == null
                          ? []
                          : ctrl2.listOfSection
                              .map((e) =>
                                  {'title': e.sectionName, 'id': e.sectionId})
                              .toList(),
                      // onChanged: ctlr.onChangedSection,
                    );
                  }),
                  // Consumer2<AddAssetController,>(
                  //     builder: (context, ctlr, child) {
                  //   return CustomDropdownField(
                  //     hintText: 'Asset Type',
                  //     items: ctlr.selectedSection == null
                  //         ? []
                  //         : ['Block', 'Station'],
                  // onChanged: (value) => ctlr.onchangeTheAssetType(value),
                  //   );
                  // }),
                  // ctlr.isTheAssetisBlock
                  //       ?
                  Consumer<AddAssetController>(
                    builder: (context, ctrl, _) {
                      return ctrl.selectedEntityType != null
                          ? Column(
                              children: [
                                if (ctrl.selectedEntityType == 'BLOCK')
                                  Consumer<BlockSectionDb>(
                                      builder: (context, ctlr2, child) {
                                    return CustomDropdownField(
                                      onCallBack: ctrl.onChangedBlocks,
                                      hintText: 'Block',
                                      items: ctrl.selectedSectionId == null
                                          ? []
                                          : ctlr2.listOfBlockSections
                                              .map((e) => {
                                                    'title': e.blockSectionName,
                                                    'id': e.blockSectionId
                                                  })
                                              .toList(),
                                      // onChanged: ctlr.onChangedStations,
                                    );
                                  }),
                                if (ctrl.selectedEntityType == 'STATION')
                                  Consumer<StationDb>(
                                      builder: (context, ctlr2, child) {
                                    return CustomDropdownField(
                                      onCallBack: ctrl.onChangedStations,
                                      hintText: 'Station',
                                      items: ctrl.selectedSectionId == null
                                          ? []
                                          : ctlr2.listOfStationModel
                                              .map((e) => {
                                                    'title': e.stationName,
                                                    'id': e.stationId
                                                  })
                                              .toList(),
                                      // onChanged: ctlr.onChangedStations,
                                    );
                                  })
                              ],
                            )
                          : const SizedBox();
                    },
                  ),
                  CustomFormField(
                      isRequiredField: true,
                      controller: assetIdController,
                      hintText: 'Asset ID / SL#'),
                  const AppSpacer(
                    heightPortion: .05,
                  ),
                  CustomButton(
                    title: 'SUBMIT',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final locationProvider = Provider.of<LocationService>(
                            context,
                            listen: false);
                        final cntroller = Provider.of<AddAssetController>(
                            context,
                            listen: false);
                        await locationProvider.getCurrentLocation();
                        final model = AddNewAssetModel(
                            entityId: cntroller.selectedEntityId!,
                            sectionInchargeId:
                                cntroller.selectedSectonInchargeId!,
                            sectionId: cntroller.selectedSectionId!,
                            entityIdentifier: assetIdController.text,
                            entityLatt: locationProvider.currentLat.toString(),
                            entityLong: locationProvider.currentLon.toString(),
                            stationId: cntroller.selectedStationId,
                            blockSectionId: cntroller.selectedBlockId);
                        await ApiService.addNewAsset(context, model);
                        Provider.of<EnitityProfileDb>(context, listen: false)
                            .storeEnitityProfile(context);

                        await cntroller.clearAllData();
                        assetIdController.clear();
                        setState(() {});
                      }
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
