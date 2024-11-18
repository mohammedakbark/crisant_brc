import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class FloatingBarController with ChangeNotifier {
  double top = 100;
  double left = 50;
  bool isMinimized = false;

  void onPanUpdate(DragUpdateDetails details, BuildContext context) {
    top = (top + details.delta.dy)
        .clamp(0, h(context) - (isMinimized ? 60 : 150));
    left = (left + details.delta.dx)
        .clamp(0, w(context) - (isMinimized ? 60 : 200));
    notifyListeners();
  }

  void minimizeBar() {
    isMinimized = !isMinimized;
    notifyListeners();
  }
}
