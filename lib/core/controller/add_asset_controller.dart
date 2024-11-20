import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/model/block_station_model.dart';
import 'package:test_managment/model/section_incharge_model.dart';
import 'package:test_managment/model/section_model.dart';
import 'package:test_managment/model/station_model.dart';

class AddAssetController with ChangeNotifier {
  String? _selectedEntityId;
  String? get selectedEntityId => _selectedEntityId; 

  String? _selectedEntityType;
  String? get selectedEntityType => _selectedEntityType;

  String? _selectedSectonInchargeId;
  String? get selectedSectonInchargeId => _selectedSectonInchargeId;

  String? _selectedSectionId;
  String? get selectedSectionId => _selectedSectionId;



  String? _selectedStationId;
  String? get selectedStationId => _selectedStationId;

  String? _selectedBlockId;
  String? get selectedBlockId => _selectedBlockId;


  clearAllData() {
    _selectedEntityId = null;
    _selectedEntityType = null;
    _selectedSectonInchargeId = null;
    _selectedSectionId = null;
    // _selectedStationType = null;
    _selectedStationId = null;
    _selectedBlockId = null;
    // _assetProfile = null;
//---------------
    _listOfDisplaySection = null;
    _listOfDispalySation = null;
    _listOfBlockStation = null;
  }

  

  void onChangeEnitity(
    dynamic value,
  ) {
    try {
      _selectedEntityId = value['id'];
      _selectedEntityType = value['entityType'];

      _selectedSectonInchargeId = null;
      _selectedSectionId = null;
      _selectedStationId = null;
      _selectedBlockId = null;

      //--------
      _listOfDisplaySection = null;
      _listOfDispalySation = null;
      _listOfBlockStation = null;

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  //  void onTapAssetGroup(EntityModel model) {
  //   _selectedEntityModel = model;
  // }
  List<SectionModel>? _listOfDisplaySection;
  List<SectionModel>? get listOfDisplaySection => _listOfDisplaySection;

  void onChangedSectionIncharge(dynamic value, List<SectionModel> list) {
    try {
      _selectedSectonInchargeId = value['id'];
      _listOfDisplaySection = list
          .where((element) =>
              element.sectionInchargeId == _selectedSectonInchargeId)
          .toList();
      _selectedSectionId = null;
      _selectedStationId = null;
      _selectedBlockId = null;
      //------------

      _listOfDispalySation = null;
      _listOfBlockStation = null;

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  List<BlockSectionModel>? _listOfBlockStation;
  List<BlockSectionModel>? get listOfBlockStation => _listOfBlockStation;
  List<StationModel>? _listOfDispalySation;
  List<StationModel>? get listOfDispalySation => _listOfDispalySation;
  void onChangedSection(
    dynamic value, {
    List<BlockSectionModel>? blockList,
    List<StationModel>? stationList,
  }) {
    try {
     
      _selectedSectionId = value['id'];
      //-----------------

      if (_selectedEntityType == 'BLOCK') {
        if (blockList != null) {
          _listOfBlockStation = blockList
              .where((element) => element.sectionId == _selectedSectionId)
              .toList();
        } else {
          _listOfBlockStation = [];
        }
      } else {
        if (stationList != null) {
          _listOfDispalySation = stationList
              .where((element) => element.sectionId == _selectedSectionId)
              .toList();
        } else {
          _listOfDispalySation = [];
        }
      }

      // Reset dependent fields
      _selectedStationId = null;
      _selectedBlockId = null;
      // _assetProfile = null;

      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
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
    try {
      _selectedStationId = value['id'];
      // _assetProfile = null;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  void onChangedBlocks(dynamic value) {
    try {
      _selectedBlockId = value['id'];
      // _assetProfile = null;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
