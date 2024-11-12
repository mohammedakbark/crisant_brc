
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
              icon: const Row(
                children: [
                  Text(
                    'English',
                    style: TextStyle(),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.kBlack,
                  )
                ],
              ),
              onSelected: (value) {},
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(child: Text('English')),
                  const PopupMenuItem(child: Text('हिन्दी'))
                ];
              },
            ),
          )
        ],
      ),
    );
  }
}
