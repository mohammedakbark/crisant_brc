import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

showMessage(String message, {bool? isWarning}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isWarning == true
          ? AppColors.kBgColor2
          : AppColors.kBlack.withOpacity(.8),
      textColor: isWarning == true ? AppColors.kRed : AppColors.kWhite,
      fontSize: 12);
}

showLoaingIndicator(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const AlertDialog(
        titlePadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSize20,
            vertical: AppDimensions.paddingSize20),
        shape: BeveledRectangleBorder(),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLoadingIndicator(),
            Text(
              'Please wait a moment..',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    },
  );
}

closeLoadingIndicator(BuildContext context) {
  Navigator.of(context).pop();
}
