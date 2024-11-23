import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/controller/camera_controller.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/offline_test_entity_db.dart';
import 'package:test_managment/core/database/parameters_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/components/custom_dropdown_field.dart';
import 'package:test_managment/core/controller/test_asset_controller.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';
import 'package:test_managment/model/reposrts%20models/test_report_add_model.dart';
import 'package:test_managment/presentation/screens/home/widgets/additional_question_view.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/presentation/screens/home/widgets/floating_location_bar.dart';
import 'package:test_managment/presentation/screens/home/widgets/app_drawer.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';

class TestAssetScreen extends StatefulWidget {
  TestAssetScreen({super.key});

  @override
  State<TestAssetScreen> createState() => _TestAssetScreenState();
}

class _TestAssetScreenState extends State<TestAssetScreen> {
  final entityIdController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Provider.of<TestAssetsController>(context, listen: false).clearAllData();
    Provider.of<TestAssetsController>(context, listen: false).clearAutoMode();

    LocalDatabaseService().fetchAllDatabases(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const HomeDrawer(),
        appBar: AppBar(
          leading: const DrawerButton(
            color: AppColors.kBlack,
          ),
          centerTitle: true,
          leadingWidth: 70,
          title: AppPageHeadText(title: 'testAsset'.tr()),
          actions: [
            Consumer<TestAssetsController>(builder: (context, cntr, _) {
              return FlutterSwitch(
                  // toggleColor: AppColors.kPrimaryColor,
                  activeColor: AppColors.kGrey,
                  inactiveColor: AppColors.kPrimaryColor,
                  activeText: "manual".tr(),
                  inactiveText: 'auto'.tr(),
                  value: cntr.isManual!,
                  valueFontSize: AppDimensions.fontSize10(context),
                  width: 50.0,
                  height: 30.0,

                  // toggleSize: 80.0,
                  borderRadius: AppDimensions.radiusSize50,
                  padding: 0,
                  toggleSize: 30,
                  showOnOff: false,
                  activeIcon: Text(
                    "manual".tr(),
                    textAlign: TextAlign.center,
                  ),
                  inactiveIcon: Text(
                    'auto'.tr(),
                    textAlign: TextAlign.center,
                  ),
                  onToggle: cntr.onChangeType);
            }),
            const AppSpacer(
              widthPortion: .04,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppMargin(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const AppSpacer(
                        heightPortion: .01,
                      ),
                      Consumer2<TestAssetsController, EntiteDb>(
                          builder: (context, ctlr, ctrl2, _) {
                        List<Map<String, dynamic>> sortedItems =
                            ctrl2.listOfEntityData
                                .map((e) => {
                                      'title': e.entityName,
                                      'id': e.entityId,
                                      'data': e.toJson(),
                                    })
                                .toList();

                        // Ensure sorting works as expected
                        sortedItems.sort((a, b) =>
                            (a['title'] ?? '').compareTo(b['title'] ?? ''));
                        return CustomDropdownField(
                            onCallBack: ctlr.onChangedAssetGroup,
                            hintText: 'assetType'.tr(),
                            items: sortedItems);
                      }),
                      Consumer2<TestAssetsController, SectionInchargeDb>(
                          builder: (context, ctlr, ctrl2, _) {
                        List<Map<String, dynamic>> sortedItems = ctrl2
                            .listOfSectionIncharge
                            .map((e) => {
                                  'title': e.sectionInchargeName,
                                  'id': e.sectionInchargeId,
                                  'data': e.toJson()
                                })
                            .toList();

                        // Ensure sorting works as expected
                        sortedItems.sort((a, b) =>
                            (a['title'] ?? '').compareTo(b['title'] ?? ''));

                        return CustomDropdownField(
                          hintText: 'sectionIncharge'.tr(),
                          items:
                              ctlr.selectedEntityId == null ? [] : sortedItems,
                          onCallBack: (value) {
                            final sectionList =
                                Provider.of<SectionDb>(context, listen: false)
                                    .listOfSection;
                            ctlr.onChangedSectionIncharge(value, sectionList);
                          },
                        );
                      }),
                      Consumer2<TestAssetsController, SectionDb>(
                          builder: (context, ctlr, ctrl2, _) {
                        List<Map<String, dynamic>> sortedItems = [];
                        if (ctlr.filterdSectionList != null) {
                          sortedItems = ctlr.filterdSectionList!
                              .map((e) => {
                                    'title': e.sectionName,
                                    'id': e.sectionId,
                                    'data': e.toJson()
                                  })
                              .toList();
                        }

                        // Ensure sorting works as expected
                        sortedItems.sort((a, b) =>
                            (a['title'] ?? '').compareTo(b['title'] ?? ''));
                        return CustomDropdownField(
                            hintText: 'section'.tr(),
                            items: ctlr.selectedSectonInchargeId == null
                                ? []
                                : sortedItems,
                            onCallBack: (value) {
                              if (ctlr.selectedEntityType == 'BLOCK') {
                                final blockList = Provider.of<BlockSectionDb>(
                                        context,
                                        listen: false)
                                    .listOfBlockSections;
                                ctlr.onChangedSection(value,
                                    blockList: blockList);
                              } else {
                                final stationList = Provider.of<StationDb>(
                                        context,
                                        listen: false)
                                    .listOfStationModel;
                                ctlr.onChangedSection(value,
                                    stationList: stationList);
                              }
                            });
                      }),
                      Consumer<TestAssetsController>(
                          builder: (context, ctlr, _) {
                        return ctlr.selectedEntityType != null
                            ? Column(
                                children: [
                                  if (ctlr.selectedEntityType == 'BLOCK')
                                    Consumer<BlockSectionDb>(
                                        builder: (context, ctrl2, _) {
                                      List<Map<String, dynamic>> sortedItems =
                                          [];
                                      if (ctlr.filterdBlockSectionList !=
                                          null) {
                                        sortedItems = ctlr
                                            .filterdBlockSectionList!
                                            .map((e) => {
                                                  'title': e.blockSectionName,
                                                  'id': e.blockSectionId,
                                                  'data': e.toJson()
                                                })
                                            .toList();
                                      }

                                      // Ensure sorting works as expected
                                      sortedItems.sort((a, b) =>
                                          (a['title'] ?? '')
                                              .compareTo(b['title'] ?? ''));
                                      return CustomDropdownField(
                                          hintText: 'block'.tr(),
                                          items: ctlr.selectedSectionId == null
                                              ? []
                                              : sortedItems,
                                          onCallBack: (value) {
                                            final list =
                                                Provider.of<EnitityProfileDb>(
                                                        context,
                                                        listen: false)
                                                    .listOfEnitityProfiles;
                                            ctlr.onChangedBlock(
                                                context, value, list);
                                          });
                                    }),
                                  if (ctlr.selectedEntityType == 'STATION')
                                    Consumer<StationDb>(
                                        builder: (context, ctrl2, _) {
                                      List<Map<String, dynamic>> sortedItems =
                                          [];
                                      if (ctlr.filteredStationList != null) {
                                        sortedItems = ctlr.filteredStationList!
                                            .map((e) => {
                                                  'title': e.stationName,
                                                  'id': e.stationId,
                                                  'data': e.toJson()
                                                })
                                            .toList();
                                      }

                                      // Ensure sorting works as expected
                                      sortedItems.sort((a, b) =>
                                          (a['title'] ?? '')
                                              .compareTo(b['title'] ?? ''));
                                      return CustomDropdownField(
                                          hintText: 'Station'.tr(),
                                          items: ctlr.selectedSectionId == null
                                              ? []
                                              : sortedItems,
                                          onCallBack: (value) {
                                            final list =
                                                Provider.of<EnitityProfileDb>(
                                                        context,
                                                        listen: false)
                                                    .listOfEnitityProfiles;
                                            ctlr.onChangedStations(
                                                context, value, list);
                                          });
                                    })
                                ],
                              )
                            : const SizedBox();
                      }),
                      Consumer2<TestAssetsController, EnitityProfileDb>(
                          builder: (context, ctlr, ctrl2, _) {
                        List<Map<String, dynamic>> sortedItems = [];
                        if (ctlr.filteredEntityProfiles != null) {
                          sortedItems = ctlr.filteredEntityProfiles!
                              .map((e) => {
                                    'title': e.entityIdentifier,
                                    'id': e.entityProfileId,
                                    'data': e.toJson()
                                  })
                              .toList();
                        }
                        // Ensure sorting works as expected
                        sortedItems.sort((a, b) =>
                            (a['title'] ?? '').compareTo(b['title'] ?? ''));
                        // return Stack(
                        //   children: [
                        //     Container(
                        //       width: w(context),
                        //       height: 56,
                        //       margin: const EdgeInsets.symmetric(
                        //           vertical: AppDimensions.paddingSize5),
                        //       decoration: BoxDecoration(
                        //         borderRadius: const BorderRadius.all(
                        //           Radius.circular(AppDimensions.radiusSize5),
                        //         ),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             spreadRadius: 1,
                        //             color: AppColors.kBlack.withOpacity(0.2),
                        //             blurRadius: 2,
                        //             offset: const Offset(0, 1),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: AppDimensions.paddingSize5),
                        //       child: TextFormField(
                        //         style: TextStyle(
                        //           fontSize: AppDimensions.fontSize16(context),
                        //         ),
                        //         controller: entityIdController,
                        //         decoration: InputDecoration(
                        //             hintText: 'Search Entity Profile',
                        //             hintStyle: TextStyle(
                        //               fontSize:
                        //                   AppDimensions.fontSize16(context),
                        //               color: AppColors.kGrey,
                        //             ),
                        //             fillColor: AppColors.kWhite,
                        //             filled: true,
                        //             errorStyle:
                        //                 const TextStyle(color: AppColors.kRed),
                        //             focusedErrorBorder:
                        //                 const OutlineInputBorder(
                        //               borderSide:
                        //                   BorderSide(color: AppColors.kRed),
                        //               borderRadius: BorderRadius.all(
                        //                 Radius.circular(
                        //                     AppDimensions.radiusSize5),
                        //               ),
                        //             ),
                        //             errorBorder: const OutlineInputBorder(
                        //               borderSide:
                        //                   BorderSide(color: AppColors.kRed),
                        //               borderRadius: BorderRadius.all(
                        //                 Radius.circular(
                        //                     AppDimensions.radiusSize5),
                        //               ),
                        //             ),
                        //             border: const OutlineInputBorder(
                        //               borderSide: BorderSide.none,
                        //               borderRadius: BorderRadius.all(
                        //                 Radius.circular(
                        //                     AppDimensions.radiusSize5),
                        //               ),
                        //             ),
                        //             suffixIcon: PopupMenuButton(
                        //                 shadowColor: AppColors.kWhite,
                        //                 surfaceTintColor: AppColors.kWhite,
                        //                 color: AppColors.kWhite,
                        //                 onSelected: (value) {
                        //                   Map daata = value as Map;
                        //                   entityIdController.text =
                        //                       daata['title'];

                        //                   final list =
                        //                       Provider.of<ParametersDb>(context,
                        //                               listen: false)
                        //                           .listOfParameters;
                        //                   ctlr.onChangedEntityProfile(
                        //                       value, list, context);
                        //                 },
                        //                 icon: Icon(
                        //                   Icons.keyboard_arrow_down_rounded,
                        //                   color: (ctlr.selectedStationId ==
                        //                               null) &&
                        //                           (ctlr.selectedBlockId == null)
                        //                       ? Colors.grey.shade400
                        //                       : null,
                        //                 ),
                        //                 itemBuilder: (context) => (ctlr
                        //                                 .selectedStationId ==
                        //                             null) &&
                        //                         (ctlr.selectedBlockId == null)
                        //                     ? []
                        //                     : sortedItems
                        //                         .asMap()
                        //                         .entries
                        //                         .map(
                        //                           (e) => PopupMenuItem(
                        //                             value: e.value,
                        //                             child: Text(
                        //                               e.value['title'],
                        //                               style: TextStyle(
                        //                                 fontSize: AppDimensions
                        //                                     .fontSize16(
                        //                                         context),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         )
                        //                         .toList())),
                        //       ),
                        //     ),
                        //   ],
                        // );
                        return CustomDropdownField(
                          hintText: 'assetProfile'.tr(),
                          items: (ctlr.selectedStationId == null) &&
                                  (ctlr.selectedBlockId == null)
                              ? []
                              : sortedItems,
                          onCallBack: (value) {
                            final list = Provider.of<ParametersDb>(context,
                                    listen: false)
                                .listOfParameters;
                            ctlr.onChangedEntityProfile(value, list, context);
                          },
                        );
                      }),

                      Consumer2<TestAssetsController, LocationService>(
                        builder: (context, ctrl, loc, child) {
                          if (ctrl.selectedEntityProfileData != null) {
                            loc.showFlaotingLocation(ctrl.showDistance,
                                targetLat: double.parse(
                                    ctrl.selectedEntityProfileData!.entityLatt),
                                targetLon: double.parse(ctrl
                                    .selectedEntityProfileData!.entityLong));
                          }
                          return Visibility(
                              visible: loc.showFloatingLocation,
                              child: const Column(
                                children: [
                                  AppSpacer(
                                    heightPortion: .02,
                                  ),
                                  FloatingDirectionBar(),
                                ],
                              ));
                        },
                      ),
                      // Provider.of<LocationService>(context).showFlaotingLocation(true)
                      const AppSpacer(
                        heightPortion: .02,
                      ),
                      imagePicker(context),
                      const AppSpacer(
                        heightPortion: .015,
                      ),
                      Consumer<TestAssetsController>(
                          builder: (context, ctlr, _) {
                        return ctlr.filterdParameters == null
                            ? const SizedBox()
                            : const AdditionalQuestionView();
                      }),
                      const AppSpacer(
                        heightPortion: .04,
                      ),
                      Consumer<LocationService>(builder: (context, loc, _) {
                        return CustomButton(
                          // butonColor: loc.isNearTarget ? null : AppColors.kGrey,
                          // textColor: loc.isNearTarget
                          //     ? null
                          //     : AppColors.kWhite.withOpacity(.7),
                          title: 'submitTestReport'.tr(),
                          onTap: handleSubmit,
                        );
                      }),
                      const AppSpacer(
                        heightPortion: .025,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> handleSubmit() async {
    // if (Provider.of<LocationService>(context, listen: false).isNearTarget) {
    if (_formkey.currentState!.validate()) {
      final cameraController =
          Provider.of<CameraController>(context, listen: false);
      final ctr = Provider.of<TestAssetsController>(context, listen: false);
      final locationProvider =
          Provider.of<LocationService>(context, listen: false);
      if (ctr.pictureIsMandatory) {
        if (cameraController.convertedImageFile != null) {
          storeData(locationProvider, ctr, cameraController);
        } else {
          showMessage('Picture is required', isWarning: true);
        }
      } else {
        storeData(locationProvider, ctr, cameraController);
      }
    }
    // }
  }

  bool isLoading = false;
  void storeData(LocationService locationProvider, TestAssetsController ctr,
      CameraController cameraController) async {
    showLoaingIndicator(context);
    await locationProvider.getCurrentLocation();
    final isOnline =
        Provider.of<NetworkService>(context, listen: false).netisConnected;

    await ctr.onSubmitTextfield();
    List<TestParametersModel> listOfParameters =
        ctr.infinityHelperData!.map((element) {
      return TestParametersModel(
          parameterId: element['parameterId'] ?? '',
          parameterValue: element['parameterValue'] ?? '',
          parameterReasonId: element['parameterReasonId'] ?? '');
    }).toList();
    final model = AddNewTestModel(
        stationId: ctr.selectedStationId,
        entityId: ctr.selectedEntityId!,
        sectionInchargeId: ctr.selectedSectonInchargeId!,
        sectionId: ctr.selectedSectionId!,
        blockSectionId: ctr.selectedBlockId,
        entityProfileId: ctr.selectedEntityProfileId!,
        testLatt: locationProvider.currentLat.toString(),
        testLong: locationProvider.currentLon.toString(),
        testMode: ctr.isManual == true ? "MANUAL" : 'AUTO',
        connectivityMode: isOnline == true ? 'ONLINE' : "OFFLINE",
        picture: cameraController.convertedImageFile?['file'],
        parameters: listOfParameters);
    if (isOnline == true) {
      await onlineSubmit(model);
    } else {
      await offlineSubmit(model);
    }
    await ctr.clearAllData();
    await cameraController.clearCameraData();
    closeLoadingIndicator(context);
    setState(() {
      isLoading = false;
    });
  }

  Future onlineSubmit(AddNewTestModel model) async {
    await ApiService.addNewTest(context, model);
  }

  Future offlineSubmit(AddNewTestModel model) async {
    await Provider.of<OfflineTestEntityDb>(context, listen: false)
        .storeTestEntityOffline(model);
  }

  Widget imagePicker(BuildContext context) {
    return Consumer<CameraController>(builder: (context, controller, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<TestAssetsController>(builder: (context, ctrl, _) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingSize5),
                child: RichText(
                    text: TextSpan(
                        text: 'picture'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.kBlack),
                        children: (!ctrl.pictureIsMandatory)
                            ? []
                            : [
                                const TextSpan(
                                    text: " *",
                                    style: TextStyle(color: AppColors.kRed))
                              ])));
          }),
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
                              'addPhoto'.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppDimensions.fontSize24(context)),
                            ),
                            _diologueButton(context, () async {
                              await controller.onPickImage();
                              Navigator.pop(context);
                            }, 'takePhoto'.tr()),
                            _diologueButton(context, () {
                              Navigator.pop(context);
                            }, 'cancel'.tr(), color: AppColors.kRed)
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
                    child: Text(
                      'capture'.tr(),
                      style: const TextStyle(
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
                          ? 'imageCaptured'.tr()
                          : 'nofileSecledted'.tr(),
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
