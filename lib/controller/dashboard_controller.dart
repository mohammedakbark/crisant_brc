import 'package:flutter/cupertino.dart';

class DashboardController with ChangeNotifier {
  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;
  void onChagePageIndex(int newIndex) {
    _currentScreenIndex = newIndex;
    notifyListeners();
  }
}
