import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kWhite,
      leading: const DrawerButton(
        color: AppColors.kBlack,
      ),
      title: Text(
        'Hi ${Provider.of<AuthDb>(context, listen: false).userName}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.kBlack,
          fontSize: AppDimensions.fontSize18(context),
        ),
      ),
      actions: [
        PopupMenuButton(
          color: AppColors.kBgColor,
          initialValue: 'en', // Default language
          tooltip: 'Language',
          icon: Row(
            children: [
              Text(
                context.locale.languageCode == 'en' ? 'English' : 'हिन्दी',
                style: const TextStyle(color: AppColors.kBlack),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.kBlack,
              ),
            ],
          ),
          onSelected: (value) {
            context.setLocale(Locale(value));
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
