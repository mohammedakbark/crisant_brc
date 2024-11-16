import 'package:flutter/material.dart';
import 'package:test_managment/presentation/components/custom_form_field.dart';

class TestAssetsController with ChangeNotifier {
  String? _selectedAssetGroup;
  String? get selectedAssetGroup => _selectedAssetGroup;

  String? _selectedSectonIncharge;
  String? get selectedSectonIncharge => _selectedSectonIncharge;

  String? _selectedSection;
  String? get selectedSection => _selectedSection;

  String? _selectedStation;
  String? get selectedStation => _selectedStation;

  String? _selectedAssetProfile;
  String? get selectedAssetProfile => _selectedAssetProfile;

  List<Map<String, TextEditingController>>? _textedEditionControllers = null;
  List<Map<String, TextEditingController>> get textedEditionControllers =>
      _textedEditionControllers ?? [];

  void onChangedAssetGroup(dynamic value) {
    switch (value) {
      case 'Way Station Equip':
        {
          TextEditingController remarkController = TextEditingController();
          _selectedAssetGroup = value;
          _textedEditionControllers = [
            {'0': remarkController}
          ];
        }
      case '4W Repeater':
        {
          _selectedAssetGroup = value;
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
        _selectedAssetGroup = value;
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
          _selectedAssetGroup = value;
          TextEditingController remarkController = TextEditingController();
          _textedEditionControllers = [
            {'0': remarkController}
          ];
        }
      case 'Battery Charger':
        {
          _selectedAssetGroup = value;
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
    _selectedSectonIncharge = null;
    _selectedSection = null;
    _selectedStation = null;
    _selectedAssetProfile = null;
    notifyListeners();
  }

  void onChangedSectionIncharge(dynamic value) {
    _selectedSectonIncharge = value;
    _selectedSection = null;
    _selectedStation = null;
    _selectedAssetProfile = null;
    notifyListeners();
  }

  void onChangedSection(dynamic value) {
    _selectedSection = value;
    _selectedStation = null;
    _selectedAssetProfile = null;
    notifyListeners();
  }

  void onChangedStations(dynamic value) {
    _selectedStation = value;
    _selectedAssetProfile = null;
    notifyListeners();
  }

  void onChangedAssetsProfile(dynamic value) {
    _selectedAssetProfile = value;
    notifyListeners();
  }
}
