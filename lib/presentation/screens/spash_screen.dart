import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/services/shared_pre_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
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

          // if (detailsareUpdated) {
            Navigator.of(context).pushAndRemoveUntil(
              AppRoutes.createRoute(const DashboardScreen()),
              (route) => false,
            );
          }  else {
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
            SizedBox(
                width: w(context) * .5,
                height: w(context) * .5,
                child: Image.asset('assets/assets_logo.png')),
            const AppSpacer(
              heightPortion: .03,
            ),
            Text(
              'TEST MANAGMENT',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 41, 77, 107),
                  fontSize: AppDimensions.fontSize17(context)),
            )
          ],
        ),
      ),
    );
  }
}
