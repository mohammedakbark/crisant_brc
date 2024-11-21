import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/presentation/auth/login_screen.dart';
import 'package:test_managment/presentation/screens/dashboard.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) async {
        final auth = await Provider.of<AuthDb>(context, listen: false)
            .checkUserTableExist();
        if (auth) {
          await Provider.of<AuthDb>(context, listen: false).getUserData();

          Navigator.of(context).pushAndRemoveUntil(
            AppRoutes.createRoute(const DashboardScreen()),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            AppRoutes.createRoute(LoginScreen()),
            (route) => false,
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ASSET',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontSize25(context)),
            ),
            Text(
              'MANAGEMENT SYSTEM',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: AppDimensions.fontSize15(context)),
            )
          ],
        ),
      ),
    );
  }
}
