import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/controller/camera_controller.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/components/custom_dropdown_field.dart';
import 'package:test_managment/core/controller/test_asset_controller.dart';
import 'package:test_managment/model/entity_profile_model.dart';
import 'package:test_managment/presentation/screens/home/widgets/additional_question_view.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class TestAssetScreen extends StatefulWidget {
  TestAssetScreen({super.key});

  @override
  State<TestAssetScreen> createState() => _TestAssetScreenState();
}

class _TestAssetScreenState extends State<TestAssetScreen> {
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

  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Provider.of<TestAssetsController>(context, listen: false).clearAllData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AppPageHeadText(title: 'Test Asset'),
          AppMargin(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Consumer<LocationService>(builder: (context, controller, _) {
                    return Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              if (controller.showFloatingLocation) {
                                controller.showFlaotingLocation(false,
                                    targetLat: null, targetLon: null);
                              } else {
                                controller.showFlaotingLocation(true,
                                    targetLat: 12.306598756316292,
                                    targetLon: 76.64572844249811);
                              }
                            },
                            child: const Text('Show')),
                      ],
                    );
                  }),
                  Consumer2<TestAssetsController, EntiteDb>(
                      builder: (context, ctlr, ctrl2, _) {
                    return CustomDropdownField(
                      onCallBack: ctlr.onChangedAssetGroup,
                      hintText: 'Asset Group',
                      items: ctrl2.listOfEntityData
                          .map((e) => {
                                'title': e.entityName,
                                'id': e.entityId,
                                'data': e.toJson()
                              })
                          .toList(),
                    );
                  }),
                  Consumer2<TestAssetsController, SectionInchargeDb>(
                      builder: (context, ctlr, ctrl2, _) {
                    return CustomDropdownField(
                      hintText: 'Section Incharge',
                      items: ctlr.selectedEntityId == null
                          ? []
                          : ctrl2.listOfSectionIncharge
                              .map((e) => {
                                    'title': e.sectionInchargeName,
                                    'id': e.sectionInchargeId,
                                    'data': e.toJson()
                                  })
                              .toList(),
                      onCallBack: ctlr.onChangedSectionIncharge,
                    );
                  }),
                  Consumer2<TestAssetsController, SectionDb>(
                      builder: (context, ctlr, ctrl2, _) {
                    return CustomDropdownField(
                        hintText: 'Section',
                        items: ctlr.selectedSectonInchargeId == null
                            ? []
                            : ctrl2.listOfSection
                                .map((e) => {
                                      'title': e.sectionName,
                                      'id': e.sectionId,
                                      'data': e.toJson()
                                    })
                                .toList(),
                        onCallBack: ctlr.onChangedSection);
                  }),
                  Consumer<TestAssetsController>(builder: (context, ctlr, _) {
                    return ctlr.selectedEntityType != null
                        ? Column(
                            children: [
                              if (ctlr.selectedEntityType == 'BLOCK')
                                Consumer<BlockSectionDb>(
                                    builder: (context, ctrl2, _) {
                                  return CustomDropdownField(
                                      hintText: 'Block',
                                      items: ctlr.selectedSectionId == null
                                          ? []
                                          : ctrl2.listOfBlockSections
                                              .map((e) => {
                                                    'title': e.blockSectionName,
                                                    'id': e.blockSectionId,
                                                    'data': e.toJson()
                                                  })
                                              .toList(),
                                      onCallBack: ctlr.onChangedBlock);
                                }),
                              if (ctlr.selectedEntityType == 'STATION')
                                Consumer<StationDb>(
                                    builder: (context, ctrl2, _) {
                                  return CustomDropdownField(
                                      hintText: 'Station',
                                      items: ctlr.selectedSectionId == null
                                          ? []
                                          : ctrl2.listOfStationModel
                                              .map((e) => {
                                                    'title': e.stationName,
                                                    'id': e.sectionId,
                                                    'data': e.toJson()
                                                  })
                                              .toList(),
                                      onCallBack: ctlr.onChangedStations);
                                })
                            ],
                          )
                        : SizedBox();
                  }),
                  Consumer2<TestAssetsController, EnitityProfileDb>(
                      builder: (context, ctlr, ctrl2, _) {
                    return CustomDropdownField(
                      hintText: 'Asset Profile',
                      items: (ctlr.selectedStationId == null) &&
                              (ctlr.selectedBlockId == null)
                          ? []
                          : ctrl2.listOfEnitityProfiles
                              .map((e) => {
                                    'title': e.entityIdentifier,
                                    'id': e.entityProfileId,
                                    'data': e.toJson()
                                  })
                              .toList(),
                      onCallBack: ctlr.onChangedAssetsProfile,
                    );
                  }),
                  const AppSpacer(
                    heightPortion: .03,
                  ),
                  imagePicker(context),
                  const AppSpacer(
                    heightPortion: .015,
                  ),
                  const AdditionalQuestionView(),
                  const AppSpacer(
                    heightPortion: .04,
                  ),
                  CustomButton(
                    title: 'SUBMIT',
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        final controller = Provider.of<TestAssetsController>(
                            context,
                            listen: false);
                        switch (controller.selectedEntityId) {
                          case 'Way Station Equip':
                            {
                              log('Ramrks : ${controller.textedEditionControllers[0]['0']!.text}');
                            }
                          case '4W Repeater':
                            {
                              log('1 : ${controller.textedEditionControllers[0]['0']!.text}');
                              log('2 : ${controller.textedEditionControllers[1]['1']!.text}');
                              log('3 : ${controller.textedEditionControllers[2]['2']!.text}');
                              log('Ramrks : ${controller.textedEditionControllers[3]['3']!.text}');
                            }
                          case 'LC Gate Phone':
                            {}
                          case 'EC Socket':
                            {}
                          case 'Battery Charger':
                            {}
                        }
                      }
                    },
                  ),
                  const AppSpacer(
                    heightPortion: .025,
                  ),
                ],
              ),
            ),
          ),
        ],
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
        padding:
            const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize10),
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
