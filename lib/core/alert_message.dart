import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_managment/core/utils/app_colors.dart';

showMessage(String message) {
  return Fluttertoast.showToast(
    
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.kBlack,
      textColor: AppColors.kWhite,
      fontSize: 16.0);
}
