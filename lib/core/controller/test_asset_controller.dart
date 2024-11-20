import 'package:flutter/material.dart';
import 'package:test_managment/model/block_station_model.dart';
import 'package:test_managment/model/entity_profile_model.dart';
import 'package:test_managment/model/parameters_model.dart';
import 'package:test_managment/model/section_model.dart';
import 'package:test_managment/model/station_model.dart';

class TestAssetsController with ChangeNotifier {
  String? _selectedEntityId;
  String? get selectedEntityId => _selectedEntityId;

  String? _selectedEntityType;
  String? get selectedEntityType => _selectedEntityType;

  bool _pictureIsMandatory = false;
  bool get pictureIsMandatory => _pictureIsMandatory;

  String? _selectedSectonInchargeId;
  String? get selectedSectonInchargeId => _selectedSectonInchargeId;

  String? _selectedSectionID;
  String? get selectedSectionId => _selectedSectionID;

  String? _selectedStationId;
  String? get selectedStationId => _selectedStationId;

  String? _selectedBlockId;
  String? get selectedBlockId => _selectedBlockId;

  String? _selectedAssetProfileId;
  String? get selectedAssetProfileId => _selectedAssetProfileId;

  clearAllData() {
    _selectedEntityId = null;
    _selectedSectonInchargeId = null;
    _pictureIsMandatory = false;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    //----------
    _filterdParameters = null;
  }

  List<Map<String, TextEditingController>>? _textedEditionControllers;
  List<Map<String, TextEditingController>> get textedEditionControllers =>
      _textedEditionControllers ?? [];

  void onChangedAssetGroup(dynamic value) {
    _selectedEntityId = value['id'];
    _selectedEntityType = value['data']['entityType'];
    if (value['pictureRequired'] == 'YES') {
      _pictureIsMandatory = true;
    } else {
      _pictureIsMandatory = false;
    }

    // switch (value['title']) {
    //   case 'Way Station Equip':
    //     {
    //       TextEditingController remarkController = TextEditingController();

    //       _textedEditionControllers = [
    //         {'0': remarkController}
    //       ];
    //     }
    //   case '4W Repeater':
    //     {
    //       TextEditingController remarkController = TextEditingController();
    //       TextEditingController ampCardController = TextEditingController();

    //       TextEditingController trfCardController = TextEditingController();

    //       TextEditingController batteryVoltageLoadController =
    //           TextEditingController();
    //       _textedEditionControllers = [
    //         {'0': ampCardController},
    //         {'1': trfCardController},
    //         {'2': batteryVoltageLoadController},
    //         {'3': remarkController}
    //       ];
    //     }
    //   case 'LC Gate Phone':
    //     {}

    //     TextEditingController remarkController = TextEditingController();
    //     TextEditingController batteryVoltageController =
    //         TextEditingController();

    //     TextEditingController ipRingVoltageController = TextEditingController();

    //     TextEditingController opRingVotageController = TextEditingController();
    //     _textedEditionControllers = [
    //       {'0': batteryVoltageController},
    //       {'1': ipRingVoltageController},
    //       {'2': opRingVotageController},
    //       {'3': remarkController}
    //     ];
    //   case 'EC Socket':
    //     {
    //       TextEditingController remarkController = TextEditingController();
    //       _textedEditionControllers = [
    //         {'0': remarkController}
    //       ];
    //     }
    //   case 'Battery Charger':
    //     {
    //       TextEditingController remarkController = TextEditingController();
    //       TextEditingController outputVolateController =
    //           TextEditingController();

    //       TextEditingController batteryVoltageController =
    //           TextEditingController();

    //       _textedEditionControllers = [
    //         {'0': outputVolateController},
    //         {'1': batteryVoltageController},
    //         {'2': remarkController},
    //       ];
    //     }
    // }

    _selectedSectonInchargeId = null;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    notifyListeners();
  }

  List<SectionModel>? _filterdSectionList;
  List<SectionModel>? get filterdSectionList => _filterdSectionList;
  void onChangedSectionIncharge(dynamic value, List<SectionModel> list) {
    _selectedSectonInchargeId = value['id'];
    _filterdSectionList = list
        .where(
            (element) => element.sectionInchargeId == _selectedSectonInchargeId)
        .toList();

    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    notifyListeners();
  }

  List<BlockSectionModel>? _filterdBlockSectionList;
  List<BlockSectionModel>? get filterdBlockSectionList =>
      _filterdBlockSectionList;
  List<StationModel>? _filteredStationList;
  List<StationModel>? get filteredStationList => _filteredStationList;
  void onChangedSection(
    dynamic value, {
    List<BlockSectionModel>? blockList,
    List<StationModel>? stationList,
  }) {
    _selectedSectionID = value['id'];
    if (_selectedEntityType == 'BLOCK') {
      if (blockList != null) {
        _filterdBlockSectionList = blockList
            .where((element) => element.sectionId == _selectedSectionID)
            .toList();
      } else {
        _filterdBlockSectionList = [];
      }
    } else {
      if (stationList != null) {
        _filteredStationList = stationList
            .where((element) => element.sectionId == _selectedSectionID)
            .toList();
      } else {
        _filteredStationList = [];
      }
    }

    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    notifyListeners();
  }

  List<EntityProfileModel>? _filteredEntityProfiles;
  List<EntityProfileModel>? get filteredEntityProfiles =>
      _filteredEntityProfiles;
  void onChangedStations(dynamic value, List<EntityProfileModel> list) {
    _selectedStationId = value['id'];
    _filteredEntityProfiles = list
        .where((element) => element.stationId == _selectedStationId)
        .toList();
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    notifyListeners();
  }

  void onChangedBlock(dynamic value, List<EntityProfileModel> list) {
    _selectedBlockId = value['id'];
    _filteredEntityProfiles = list
        .where((element) => element.blockSectionId == _selectedBlockId)
        .toList();
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    notifyListeners();
  }

  List<ParametersModel>? _filterdParameters;
  List<ParametersModel>? get filterdParameters => _filterdParameters;
  void onChangedAssetsProfile(dynamic value, List<ParametersModel> list) {
    _selectedAssetProfileId = value['id'];
    _filterdParameters =
        list.where((element) => element.entityId == _selectedEntityId).toList();
    notifyListeners();
  }

  //-----------
}
