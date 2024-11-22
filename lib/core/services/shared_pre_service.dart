import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreService with ChangeNotifier {
  final key = 'isDataAlredyHave';
  bool? _dataisUpdated;
  Future<bool> get dataisUpdated async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _dataisUpdated = preferences.getBool(key) ?? false;
    notifyListeners();
    return _dataisUpdated!;
  }

  Future setDataStorageStatus(bool vaue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = await preferences.setBool(key, vaue);
    _dataisUpdated = data;
    notifyListeners();
  }

  deletedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = await preferences.remove(key);
    _dataisUpdated = data;
    notifyListeners();
  }
}
