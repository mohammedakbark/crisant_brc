import 'package:flutter/material.dart';

class TestAssetsController with ChangeNotifier {
  String? _selectedEntityId;
  String? get selectedEntityId => _selectedEntityId;

  String? _selectedEntityType;
  String? get selectedEntityType => _selectedEntityType;

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
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
  }

  List<Map<String, TextEditingController>>? _textedEditionControllers = null;
  List<Map<String, TextEditingController>> get textedEditionControllers =>
      _textedEditionControllers ?? [];

  void onChangedAssetGroup(dynamic value) {
    switch (value['title']) {
      case 'Way Station Equip':
        {
          TextEditingController remarkController = TextEditingController();

          _textedEditionControllers = [
            {'0': remarkController}
          ];
        }
      case '4W Repeater':
        {
          TextEditingController remarkController = TextEditingController();
          TextEditingController ampCardController = TextEditingController();

          TextEditingController trfCardController = TextEditingController();

          TextEditingController batteryVoltageLoadController =
              TextEditingController();
          _textedEditionControllers = [
            {'0': ampCardController},
            {'1': trfCardController},
            {'2': batteryVoltageLoadController},
            {'3': remarkController}
          ];
        }
      case 'LC Gate Phone':
        {}

        TextEditingController remarkController = TextEditingController();
        TextEditingController batteryVoltageController =
            TextEditingController();

        TextEditingController ipRingVoltageController = TextEditingController();

        TextEditingController opRingVotageController = TextEditingController();
        _textedEditionControllers = [
          {'0': batteryVoltageController},
          {'1': ipRingVoltageController},
          {'2': opRingVotageController},
          {'3': remarkController}
        ];
      case 'EC Socket':
        {
          TextEditingController remarkController = TextEditingController();
          _textedEditionControllers = [
            {'0': remarkController}
          ];
        }
      case 'Battery Charger':
        {
          TextEditingController remarkController = TextEditingController();
          TextEditingController outputVolateController =
              TextEditingController();

          TextEditingController batteryVoltageController =
              TextEditingController();

          _textedEditionControllers = [
            {'0': outputVolateController},
            {'1': batteryVoltageController},
            {'2': remarkController},
          ];
        }
    }
    _selectedEntityId = value['id'];
    _selectedEntityType = value['data']['entityType'];
    _selectedSectonInchargeId = null;
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _selectedAssetProfileId = null;
    notifyListeners();
  }

  void onChangedSectionIncharge(dynamic value) {
    _selectedSectonInchargeId = value['id'];
    _selectedSectionID = null;
    _selectedStationId = null;
    _selectedBlockId = null;

    _selectedAssetProfileId = null;
    notifyListeners();
  }

  void onChangedSection(dynamic value) {
    _selectedSectionID = value['id'];
    _selectedStationId = null;
    _selectedBlockId = null;

    _selectedAssetProfileId = null;
    notifyListeners();
  }

  void onChangedStations(dynamic value) {
    _selectedStationId = value['id'];
    _selectedAssetProfileId = null;
    notifyListeners();
  }

  void onChangedBlock(dynamic value) {
    _selectedBlockId = value['id'];
    _selectedAssetProfileId = null;
    notifyListeners();
  }

  void onChangedAssetsProfile(dynamic value) {
    _selectedAssetProfileId = value['id'];
    notifyListeners();
  }

  //-----------
}
