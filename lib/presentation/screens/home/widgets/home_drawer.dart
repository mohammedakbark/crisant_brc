import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: w(context) * .6,
      shape: const BeveledRectangleBorder(),
      backgroundColor: AppColors.kBgColor,
    );
  }
}
