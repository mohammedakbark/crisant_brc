import 'package:flutter/cupertino.dart';

class AddAssetController with ChangeNotifier {
  String? _selectedAssetGroup;
  String? get selectedAssetGroup => _selectedAssetGroup;

  String? _selectedSectonIncharge;
  String? get selectedSectonIncharge => _selectedSectonIncharge;

  String? _selectedSection;
  String? get selectedSection => _selectedSection;

  String? _selectedStationType;
  String? get selectedStationType => _selectedStationType;

  String? _selectedStation;
  String? get selectedStation => _selectedStation;

  String? _assetProfile;
  String? get assetProfile => _assetProfile;

  clearAllData() {
    _selectedAssetGroup = null;
    _selectedSectonIncharge = null;
    _selectedSection = null;
    _selectedStationType = null;
    _selectedStation = null;
    _assetProfile = null;
  }

  bool _isTheAssetisBlock = false;
  bool get isTheAssetisBlock => _isTheAssetisBlock;

  void onChangeAsetGroup(dynamic value) {
    _selectedAssetGroup = value;
    _selectedSectonIncharge = null;
    _selectedSection = null;
    _selectedStationType = null;
    _selectedStation = null;
    _assetProfile = null;
    notifyListeners();
  }

  void onChangedSectionIncharge(dynamic value) {
    _selectedSectonIncharge = value;
    _selectedSection = null;
    _selectedStationType = null;
    _selectedStation = null;
    _assetProfile = null;
    notifyListeners();
  }

  void onChangedSection(dynamic value) {
    _selectedSection = value;
    _selectedStationType = null;
    _selectedStation = null;
    _assetProfile = null;
    notifyListeners();
  }

  onchangeTheAssetType(String type) {
    if (type == 'Block') {
      _isTheAssetisBlock = true;
    } else {
      _isTheAssetisBlock = false;
    }
    _selectedStationType = type;
    _selectedStation = null;
    _assetProfile = null;
    notifyListeners();
  }

  void onChangedStations(dynamic value) {
    _selectedStation = value;
    _assetProfile = null;
    notifyListeners();
  }
}
