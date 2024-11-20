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
import 'package:test_managment/core/services/local_service.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/model/add_new_asset_model.dart';

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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppPageHeadText(title: 'Add Asset'),
            AppMargin(
              child: Column(
                children: [
                  _buildEntityDropdown(),
                  _buildSectionInchargeDropdown(),
                  _buildSectionDropdown(),
                  _buildBlockOrStationDropdown(),
                  CustomFormField(
                    isRequiredField: true,
                    controller: assetIdController,
                    hintText: 'Asset ID / SL#',
                  ),
                  const AppSpacer(heightPortion: .05),
                  CustomButton(
                    title: 'SUBMIT',
                    onTap: _handleSubmit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityDropdown() {
    return Consumer2<AddAssetController, EntiteDb>(
      builder: (context, assetCtrl, entityDb, _) {
        return CustomDropdownField(
          onCallBack: assetCtrl.onChangeEnitity,
          hintText: 'Asset Group',
          items: entityDb.listOfEntityData.map((entity) {
            return {
              'title': entity.entityName,
              'id': entity.entityId,
              'entityType': entity.entityType,
            };
          }).toList(),
        );
      },
    );
  }

  Widget _buildSectionInchargeDropdown() {
    return Consumer2<AddAssetController, SectionInchargeDb>(
      builder: (context, assetCtrl, sectionInchargeDb, _) {
        return CustomDropdownField(
          onCallBack: (value) {
            final sectionList =
                Provider.of<SectionDb>(context, listen: false).listOfSection;
            assetCtrl.onChangedSectionIncharge(value, sectionList);
          },
          hintText: 'Section Incharge',
          items: assetCtrl.selectedEntityId == null
              ? []
              : sectionInchargeDb.listOfSectionIncharge.map((sectionIncharge) {
                  return {
                    'title': sectionIncharge.sectionInchargeName,
                    'id': sectionIncharge.sectionInchargeId,
                  };
                }).toList(),
        );
      },
    );
  }

  Widget _buildSectionDropdown() {
    return Consumer2<AddAssetController, SectionDb>(
      builder: (context, assetCtrl, sectionDb, _) {
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
          hintText: 'Section',
          items: assetCtrl.selectedSectonInchargeId == null
              ? []
              : assetCtrl.listOfDisplaySection!.map((section) {
                  return {
                    'title': section.sectionName,
                    'id': section.sectionId,
                    'data': section.toJson(),
                  };
                }).toList(),
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
          return Consumer<BlockSectionDb>(
            builder: (context, blockDb, _) {
              return CustomDropdownField(
                onCallBack: assetCtrl.onChangedBlocks,
                hintText: 'Block',
                items: assetCtrl.selectedSectionId == null
                    ? []
                    : assetCtrl.listOfBlockStation!.map((block) {
                        return {
                          'title': block.blockSectionName,
                          'id': block.blockSectionId,
                          'data': block.toJson(),
                        };
                      }).toList(),
              );
            },
          );
        }
        return Consumer<StationDb>(
          builder: (context, stationDb, _) {
            return CustomDropdownField(
              onCallBack: assetCtrl.onChangedStations,
              hintText: 'Station',
              items: assetCtrl.selectedSectionId == null
                  ? []
                  : assetCtrl.listOfDispalySation!.map((station) {
                      return {
                        'title': station.stationName,
                        'id': station.stationId,
                        'data': station.toJson(),
                      };
                    }).toList(),
            );
          },
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final locationProvider =
        Provider.of<LocationService>(context, listen: false);
    final assetCtrl = Provider.of<AddAssetController>(context, listen: false);

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

    await ApiService.addNewAsset(context, assetModel);
    await Provider.of<EnitityProfileDb>(context, listen: false)
        .storeEnitityProfile(context);
    await assetCtrl.clearAllData();
    assetIdController.clear();
    setState(() {});
  }
}
