import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/presentation/screens/spash_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: w(context) * .6,
      shape: const BeveledRectangleBorder(),
      backgroundColor: AppColors.kBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
              butonColor: AppColors.kRed,
              title: 'LOGOUT',
              onTap: () async {
                await Provider.of<AuthDb>(context, listen: false)
                    .clearAuthtable();
                Navigator.of(context).pushAndRemoveUntil(
                  AppRoutes.createRoute(const SpashScreen()),
                  (route) => false,
                );
              }),
          AppSpacer(
            heightPortion: .05,
          )
        ],
      ),
    );
  }
}
