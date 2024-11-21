import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/services/location_service.dart';
import 'package:test_managment/model/db%20models/block_station_model.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';
import 'package:test_managment/model/db%20models/parameters_model.dart';
import 'package:test_managment/model/db%20models/section_model.dart';
import 'package:test_managment/model/db%20models/station_model.dart';

class TestAssetsController with ChangeNotifier {
  bool? _isManual;
  bool? get isManual => _isManual ?? true;

  void onChangeType(bool value) {
    _isManual = value;
    showMessage(_isManual == true ? 'MANUAL MODE' : 'AUTO MODE');
    clearAllData();
    notifyListeners();
  }

  String? _selectedEntityId;
  String? get selectedEntityId => _selectedEntityId;

  String? _selectedEntityType;
  String? get selectedEntityType => _selectedEntityType;

  bool? _showDistance;
  bool get showDistance => _showDistance ?? false;

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

  String? _selectedEntityProfileId;
  String? get selectedEntityProfileId => _selectedEntityProfileId;

  Future<void> clearAllData() async {
    _selectedEntityId = null;
    _selectedSectonInchargeId = null;
    _pictureIsMandatory = false;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedEntityProfileId = null;
    //----------
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;
  }

  Future<void> clearAutoMode() async {
    _isManual = null;
  }

  List<Map<String, TextEditingController>>? _textedEditionControllers;
  List<Map<String, TextEditingController>> get textedEditionControllers =>
      _textedEditionControllers ?? [];

  void onChangedAssetGroup(dynamic value) {
    _selectedEntityId = value['id'];
    _selectedEntityType = value['data']['entityType'];
    if (value['data']['pictureRequired'] == 'YES') {
      _pictureIsMandatory = true;
    } else {
      _pictureIsMandatory = false;
    }

    _selectedSectonInchargeId = null;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedEntityProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;

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
    _selectedEntityProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;

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
    _selectedEntityProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;

    notifyListeners();
  }

  List<EntityProfileModel>? _filteredEntityProfiles;
  List<EntityProfileModel>? get filteredEntityProfiles =>
      _filteredEntityProfiles;
  void onChangedStations(
      context, dynamic value, List<EntityProfileModel> list) async {
    _selectedStationId = value['id'];
    if (isManual == true) {
      _filteredEntityProfiles = list
          .where((element) =>
              element.entityId == _selectedEntityId &&
              element.sectionInchargeId == _selectedSectonInchargeId &&
              element.sectionId == _selectedSectionID &&
              element.stationId == _selectedStationId)
          .toList();
    } else {
      _filteredEntityProfiles = [];
      final ref = Provider.of<EnitityProfileDb>(context, listen: false);
      final nearData = await ref.getNearestEntityProfiles(context);
      final listOfAuto = nearData
          .map(
            (e) => EntityProfileModel.fromJson(e),
          )
          .toList();
      _filteredEntityProfiles = listOfAuto
          .where((element) =>
              element.entityId == _selectedEntityId &&
              element.sectionInchargeId == _selectedSectonInchargeId &&
              element.sectionId == _selectedSectionID &&
              element.stationId == _selectedStationId)
          .toList();
    }
    _selectedEntityProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;

    notifyListeners();
  }

  void onChangedBlock(
      context, dynamic value, List<EntityProfileModel> list) async {
    _selectedBlockId = value['id'];

    if (isManual == true) {
      _filteredEntityProfiles = list
          .where((element) =>
              element.entityId == _selectedEntityId &&
              element.sectionInchargeId == _selectedSectonInchargeId &&
              element.sectionId == _selectedSectionID &&
              element.blockSectionId == _selectedBlockId)
          .toList();
    } else {
      final ref = Provider.of<EnitityProfileDb>(context, listen: false);
      final nearData = await ref.getNearestEntityProfiles(context);
      final listOfAuto = nearData
          .map(
            (e) => EntityProfileModel.fromJson(e),
          )
          .toList();
      _filteredEntityProfiles = listOfAuto
          .where((element) =>
              element.entityId == _selectedEntityId &&
              element.sectionInchargeId == _selectedSectonInchargeId &&
              element.sectionId == _selectedSectionID &&
              element.blockSectionId == _selectedBlockId)
          .toList();
    }
    _selectedEntityProfileId = null;
    _filterdParameters = null;
    _infinityhelperData = null;
    _infinityControllers = null;
    _showDistance = null;

    notifyListeners();
  }

  List<ParametersModel>? _filterdParameters;
  List<ParametersModel>? get filterdParameters => _filterdParameters;

  EntityProfileModel? _selectedEntityProfileData;
  EntityProfileModel? get selectedEntityProfileData =>
      _selectedEntityProfileData;

  void onChangedEntityProfile(
      dynamic value, List<ParametersModel> list, BuildContext context) {
    _selectedEntityProfileId = value['id'];

    _selectedEntityProfileData = EntityProfileModel.fromJson(value['data']);
    // String entityLat = _selectedEntityProfileData!.entityLatt;
    // String entityLon = _selectedEntityProfileData!.entityLong;
    _showDistance = true;

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
    log('parameters Lenght ${_infinityhelperData!.length.toString()}');
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
    for (var index = 0; index < _filterdParameters!.length; index++) {
      final parammeter = _filterdParameters![index];
      if (parammeter.parameterType == 'INPUT') {
        log(index.toString());
        _infinityhelperData?[index]['parameterId'] = parammeter.parameterId;
        _infinityhelperData?[index]['parameterValue'] =
            _infinityControllers![index]['$index']!.text;

        _infinityhelperData?[index]['parameterReasonId'] =
            _infinityControllers![index]['$index']!.text;

        log('text field  parameter ID ${_infinityhelperData![index]['parameterId']}');
        log('text field  parameter Value ID ${_infinityhelperData![index]['parameterValue']}');
        log('text field  parameterReason ID ${_infinityhelperData![index]['parameterReasonId']}');
      }
    }
  }
}
