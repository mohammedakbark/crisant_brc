import 'package:flutter/cupertino.dart';

class AddAssetController with ChangeNotifier {
  String? _selectedEntityId;
  String? get selectedEntityId => _selectedEntityId;
  String? _selectedEntityType;
  String? get selectedEntityType => _selectedEntityType;

  String? _selectedSectonInchargeId;
  String? get selectedSectonInchargeId => _selectedSectonInchargeId;

  String? _selectedSectionId;
  String? get selectedSectionId => _selectedSectionId;

  // String? _selectedStationType;
  // String? get selectedStationType => _selectedStationType;

  String? _selectedStationId;
  String? get selectedStationId => _selectedStationId;
  String? _selectedBlockId;
  String? get selectedBlockId => _selectedBlockId;

  String? _assetProfile;
  String? get assetProfile => _assetProfile;

  clearAllData() {
    _selectedEntityId = null;
    _selectedEntityType = null;
    _selectedSectonInchargeId = null;
    _selectedSectionId = null;
    // _selectedStationType = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _assetProfile = null;
  }

  bool _isTheAssetisBlock = false;
  bool get isTheAssetisBlock => _isTheAssetisBlock;

  void onChangeEnitity(dynamic value) {
    _selectedEntityId = value['id'];
    _selectedEntityType = value['entityType'];
    _selectedSectonInchargeId = null;
    _selectedSectionId = null;
    // _selectedStationType = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _assetProfile = null;
    notifyListeners();
  }

  //  void onTapAssetGroup(EntityModel model) {
  //   _selectedEntityModel = model;
  // }

  void onChangedSectionIncharge(dynamic value) {
    _selectedSectonInchargeId = value['id'];
    _selectedSectionId = null;
    // _selectedStationType = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _assetProfile = null;
    notifyListeners();
  }

  void onChangedSection(dynamic value) {
    _selectedSectionId = value['id'];
    // _selectedStationType = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    _assetProfile = null;
    notifyListeners();
  }

  // onchangeTheAssetType(String type) {
  //   if (type == 'Block') {
  //     _isTheAssetisBlock = true;
  //   } else {
  //     _isTheAssetisBlock = false;
  //   }
  //   // _selectedStationType = type;
  //   _selectedStation = null;
  //   _assetProfile = null;
  //   notifyListeners();
  // }

  void onChangedStations(dynamic value) {
    _selectedStationId = value['id'];
    _assetProfile = null;
    notifyListeners();
  }

  void onChangedBlocks(dynamic value) {
    _selectedBlockId = value['id'];
    _assetProfile = null;
    notifyListeners();
  }
}
