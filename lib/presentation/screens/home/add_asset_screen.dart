import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
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
import 'package:test_managment/core/database/offline_add_entity_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/model/add_new_asset_model.dart';
import 'package:test_managment/presentation/screens/home/widgets/app_drawer.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({Key? key}) : super(key: key);

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final TextEditingController assetIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AddAssetController>(context, listen: false).clearAllData();
    LocalDatabaseService().fetchAllDatabases(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const HomeDrawer(),
        appBar: AppBar(
          leadingWidth: 70,
          // leading: Builder(builder: (context) {
          //   return Consumer<NetworkService>(builder: (context, net, _) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           net.netisConnected == true ? "ONLINE" : "OFFLINE",
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     );
          //   });
          // }),
          leading: const DrawerButton(
            color: AppColors.kBlack,
          ),
          centerTitle: true,
          title: AppPageHeadText(title: 'addAsset'.tr()),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppMargin(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacer(
                        heightPortion: .01,
                      ),
                      _buildEntityDropdown(),
                      _buildSectionInchargeDropdown(),
                      _buildSectionDropdown(),
                      _buildBlockOrStationDropdown(),
                      Text(
                        'assetId'.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.kBlack),
                      ),
                      CustomFormField(
                        isRequiredField: true,
                        controller: assetIdController,
                        hintText: 'assetid/sl'.tr(),
                      ),
                      const AppSpacer(heightPortion: .05),
                      Center(
                        child: CustomButton(
                          title: 'addAssetCap'.tr(),
                          onTap: _handleSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildEntityDropdown() {
    return Consumer2<AddAssetController, EntiteDb>(
      builder: (context, assetCtrl, entityDb, _) {
        List<Map<String, dynamic>> sortedItems = [];
        if (entityDb.listOfEntityData != null) {
          sortedItems = entityDb.listOfEntityData.map((entity) {
            return {
              'title': entity.entityName,
              'id': entity.entityId,
              'entityType': entity.entityType,
            };
          }).toList();
        }

        sortedItems
            .sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        return CustomDropdownField(
            onCallBack: assetCtrl.onChangeEnitity,
            hintText: 'assetType'.tr(),
            items: sortedItems);
      },
    );
  }

  Widget _buildSectionInchargeDropdown() {
    return Consumer2<AddAssetController, SectionInchargeDb>(
      builder: (context, assetCtrl, sectionInchargeDb, _) {
        List<Map<String, dynamic>> sortedItems = [];
        if (sectionInchargeDb.listOfSectionIncharge != null) {
          sortedItems =
              sectionInchargeDb.listOfSectionIncharge.map((sectionIncharge) {
            return {
              'title': sectionIncharge.sectionInchargeName,
              'id': sectionIncharge.sectionInchargeId,
            };
          }).toList();
        }

        sortedItems
            .sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        return CustomDropdownField(
          onCallBack: (value) {
            final sectionList =
                Provider.of<SectionDb>(context, listen: false).listOfSection;
            assetCtrl.onChangedSectionIncharge(value, sectionList);
          },
          hintText: 'sectionIncharge'.tr(),
          items: assetCtrl.selectedEntityId == null ? [] : sortedItems,
        );
      },
    );
  }

  Widget _buildSectionDropdown() {
    return Consumer2<AddAssetController, SectionDb>(
      builder: (context, assetCtrl, sectionDb, _) {
        List<Map<String, dynamic>> sortedItems = [];
        if (assetCtrl.listOfDisplaySection != null) {
          sortedItems = assetCtrl.listOfDisplaySection!.map((section) {
            return {
              'title': section.sectionName,
              'id': section.sectionId,
              'data': section.toJson(),
            };
          }).toList();
        }
        sortedItems
            .sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        return CustomDropdownField(
          onCallBack: (value) {
            if (assetCtrl.selectedEntityType == 'BLOCK') {
              final blockList =
                  Provider.of<BlockSectionDb>(context, listen: false)
                      .listOfBlockSections;
              assetCtrl.onChangedSection(value, blockList: blockList);
            } else {
              final stationList = Provider.of<StationDb>(context, listen: false)
                  .listOfStationModel;
              assetCtrl.onChangedSection(value, stationList: stationList);
            }
          },
          hintText: 'section'.tr(),
          items: assetCtrl.selectedSectonInchargeId == null ? [] : sortedItems,
        );
      },
    );
  }

  Widget _buildBlockOrStationDropdown() {
    return Consumer<AddAssetController>(
      builder: (context, assetCtrl, _) {
        if (assetCtrl.selectedEntityType == null) {
          return const SizedBox();
        }
        if (assetCtrl.selectedEntityType == 'BLOCK') {
          List<Map<String, dynamic>> sortedItems = [];
          if (assetCtrl.listOfBlockStation != null) {
            sortedItems = assetCtrl.listOfBlockStation!.map((block) {
              return {
                'title': block.blockSectionName,
                'id': block.blockSectionId,
                'data': block.toJson(),
              };
            }).toList();
          }

          sortedItems
              .sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
          return Consumer<BlockSectionDb>(
            builder: (context, blockDb, _) {
              return CustomDropdownField(
                onCallBack: assetCtrl.onChangedBlocks,
                hintText: 'block'.tr(),
                items: assetCtrl.selectedSectionId == null ? [] : sortedItems,
              );
            },
          );
        }
        return Consumer<StationDb>(
          builder: (context, stationDb, _) {
            List<Map<String, dynamic>> sortedItems = [];
            if (assetCtrl.listOfDispalySation != null) {
              sortedItems = assetCtrl.listOfDispalySation!.map((station) {
                return {
                  'title': station.stationName,
                  'id': station.stationId,
                  'data': station.toJson(),
                };
              }).toList();
            }
            sortedItems
                .sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
            return CustomDropdownField(
              onCallBack: assetCtrl.onChangedStations,
              hintText: 'station'.tr(),
              items: assetCtrl.selectedSectionId == null ? [] : sortedItems,
            );
          },
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    showLoaingIndicator(context);
    final locationProvider =
        Provider.of<LocationService>(context, listen: false);
    final assetCtrl = Provider.of<AddAssetController>(context, listen: false);
    final isOnline =
        Provider.of<NetworkService>(context, listen: false).netisConnected;
    await locationProvider.getCurrentLocation();

    final assetModel = AddNewAssetModel(
      entityId: assetCtrl.selectedEntityId!,
      sectionInchargeId: assetCtrl.selectedSectonInchargeId!,
      sectionId: assetCtrl.selectedSectionId!,
      entityIdentifier: assetIdController.text,
      entityLatt: locationProvider.currentLat.toString(),
      entityLong: locationProvider.currentLon.toString(),
      stationId: assetCtrl.selectedStationId,
      blockSectionId: assetCtrl.selectedBlockId,
    );
// ignore: use_build_context_synchronously
    if (isOnline == true) {
      onlineDataEntry(assetModel);
    } else {
      offlineDataEntry(assetModel);
    }

    await assetCtrl.clearAllData();
    assetIdController.clear();
    closeLoadingIndicator(context);
    setState(() {});
  }

  Future onlineDataEntry(AddNewAssetModel assetModel) async {
    await ApiService.addNewAsset(context, assetModel);
    await Provider.of<EnitityProfileDb>(context, listen: false)
        .storeEnitityProfile(context);
  }

  Future offlineDataEntry(AddNewAssetModel assetModel) async {
    await Provider.of<OfflineAddEntityDb>(context, listen: false)
        .addToOfflineAddEntityDb(assetModel);
  }
}
