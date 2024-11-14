import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/responsive_helper.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: w(context),
      top: AppDimensions.paddingSize5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const DrawerButton(
                color: AppColors.kWhite,
              ),
              Text(
                'Hi Crisant',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kWhite,
                    shadows: [
                      Shadow(
                          blurRadius: 2,
                          offset: const Offset(1, 2),
                          color: AppColors.kBlack.withOpacity(.2))
                    ],
                    fontSize: AppDimensions.fontSize18(context)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: PopupMenuButton(
              color: AppColors.kBgColor,
              initialValue: 'English',
              tooltip: 'Language',
              icon: Row(
                children: [
                  Text(
                    context.locale.languageCode == 'en' ? 'English' : 'हिन्दी',
                    style: const TextStyle(),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.kBlack,
                  )
                ],
              ),
              onSelected: (value) {
                context.setLocale(Locale(value));
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(value: 'en', child: Text('English')),
                  const PopupMenuItem(value: 'hi', child: Text('हिन्दी'))
                ];
              },
            ),
          )
        ],
      ),
    );
  }
}
