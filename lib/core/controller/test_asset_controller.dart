import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_managment/model/db%20models/block_station_model.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';
import 'package:test_managment/model/db%20models/parameters_model.dart';
import 'package:test_managment/model/db%20models/section_model.dart';
import 'package:test_managment/model/db%20models/station_model.dart';

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

  Future<void> clearAllData() async {
    _selectedEntityId = null;
    _selectedSectonInchargeId = null;
    _pictureIsMandatory = false;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    //----------
    _filterdParameters = null;
    _infinityhelperData = null;
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

    _selectedSectonInchargeId = null;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
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
    _infinityhelperData = null;
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
    _infinityhelperData = null;
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
    _infinityhelperData = null;
    notifyListeners();
  }

  void onChangedBlock(dynamic value, List<EntityProfileModel> list) {
    _selectedBlockId = value['id'];
    _filteredEntityProfiles = list
        .where((element) => element.blockSectionId == _selectedBlockId)
        .toList();
    _selectedAssetProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    notifyListeners();
  }

  List<ParametersModel>? _filterdParameters;
  List<ParametersModel>? get filterdParameters => _filterdParameters;
  void onChangedAssetsProfile(dynamic value, List<ParametersModel> list) {
    _selectedAssetProfileId = value['id'];
    _filterdParameters =
        list.where((element) => element.entityId == _selectedEntityId).toList();

    _genarateAdditionalQuestionDataComponets();
    _genarateTextEditingController();
    notifyListeners();
  }

  //-----additional ------
  List<Map<String, dynamic>>? _infinityhelperData;
  List<Map<String, dynamic>>? get infinityHelperData => _infinityhelperData;

  _genarateAdditionalQuestionDataComponets() {
    // final finalList = _filterdParameters!
    //     .where((element) => element.parameterType == 'SELECT')
    //     .toList();
    _infinityhelperData = List.generate(
        _filterdParameters!.length,
        (index) => {
              'bool': true,
              'parameterId': null,
              'parameterValue': null,
              'parameterReasonId': null,
            });
    log(_infinityhelperData!.length.toString());
  }

  List<Map<String, TextEditingController>>? _infinityControllers;
  List<Map<String, TextEditingController>>? get infinityControllers =>
      _infinityControllers;
  _genarateTextEditingController() {
    _infinityControllers = List.generate(_filterdParameters!.length,
        (index) => {'$index': TextEditingController()}).toList();
  }

  void onChangeTheParameterValue(
      index, bool value, String? parameterValueId, String? parameterId) {
    _infinityhelperData?[index]['bool'] = value;
    _infinityhelperData?[index]['parameterId'] = parameterId;
    _infinityhelperData?[index]['parameterValue'] = parameterValueId;
    notifyListeners();
  }

  onChangeTheParameterReason(index, String? parameterReasonId) {
    _infinityhelperData?[index]['parameterReasonId'] = parameterReasonId;

    notifyListeners();
  }

  // getTextFieldData(index, String? parameterId) {
  //   _infinityhelperData?[index]['parameterId'] = parameterId;
  //   log('text field  parameter ID ${_infinityhelperData![index]['parameterId']}');
  // }

  Future onSubmitTextfield() async {
    for (var i in _filterdParameters!) {
      _infinityControllers!.asMap().entries.map(
        (e) {
          final index = e.key;
          final controller = e.value['$index'];
          if (i.parameterType == 'INPUT') {
            _infinityhelperData?[index]['parameterId'] = i.parameterId;
            _infinityhelperData?[index]['parameterValue'] = controller!.text;
            _infinityhelperData?[index]['parameterReasonId'] = controller!.text;
          }
        },
      );
    }
    log('text field  parameter ID ${_infinityhelperData![0]['parameterId']}');
    log('text field  parameter Value ID ${_infinityhelperData![0]['parameterValue']}');
    log('text field  parameterReason ID ${_infinityhelperData![0]['parameterReasonId']}');
  }
}
