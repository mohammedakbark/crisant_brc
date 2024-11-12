import 'package:flutter/material.dart';
import 'package:test_managment/utils/app_dimentions.dart';

class AppPageHeadText extends StatelessWidget {
  final String title;
  const AppPageHeadText({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize20),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontSize18(context)),
      ),
    );
  }
}
