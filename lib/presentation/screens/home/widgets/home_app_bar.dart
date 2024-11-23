import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/services/lang_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kWhite,
      leading: const DrawerButton(
        color: AppColors.kBlack,
      ),
      title: Consumer<LanguageService>(builder: (context, service, _) {
        return Text(
          '${'hi'.tr()} ${Provider.of<AuthDb>(context, listen: false).userName}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.kBlack,
            fontSize: AppDimensions.fontSize18(context),
          ),
        );
      }),
      actions: [
        Consumer<LanguageService>(builder: (context, service, _) {
          return PopupMenuButton(
            color: AppColors.kBgColor,
            initialValue: service.selectedLanguage ??
                (
                  context.locale.languageCode == 'en'
                      ? 'English'
                      : context.locale.languageCode == "hi"
                          ? "हिन्दी"
                          : 'ಕನ್ನಡ',
                ),
            tooltip: 'Language',
            icon: Row(
              children: [
                Text(
                  service.selectedLanguage != null
                      ? ((service.selectedLanguage == 'en'
                          ? 'English'
                          : (service.selectedLanguage == 'hi')
                              ? "हिन्दी"
                              : 'ಕನ್ನಡ'))
                      : (context.locale.languageCode == 'en'
                          ? 'English'
                          : (context.locale.languageCode == 'hi')
                              ? "हिन्दी"
                              : 'ಕನ್ನಡ'),
                  style: const TextStyle(color: AppColors.kBlack),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.kBlack,
                ),
              ],
            ),
            onSelected: (value) {
              service.onchangeLangauge(context, value);
            }, // Update the language when selected
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: 'en', child: Text('English')),
                PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
                PopupMenuItem(value: 'ka', child: Text('ಕನ್ನಡ')),
              ];
            },
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
