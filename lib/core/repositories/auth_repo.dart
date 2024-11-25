import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/model/response_model.dart';
import 'package:test_managment/core/utils/app_const.dart';

class AuthRepo {
  static Dio dio = Dio();
  static const url = '${AppConst.baseURL}${AppConst.loginURL}';
  static const profilUrl = "${AppConst.baseURL}${AppConst.profileURL}";
  static Future<ResponseModel?> loginUser(
      String userName, String password, int devisionId) async {
    try {
      final response = await dio.post(url, data: {
        "userName": userName.trim(),
        "userPassword": password.trim(),
        "divisionId": devisionId
      });

      final decodedata = jsonDecode(response.toString());

      if (decodedata['status'] == 200) {
        return ResponseModel.fromJson(decodedata);
      } else {
        return ResponseModel.fromJson(decodedata);
      }
    } catch (e) {
      showMessage('Please Check Your Internet Connection', isWarning: true);
      log(e.toString());
      return null;
    }
  }

  static Future<ResponseModel?> getUserProfileData(
      String userName, String password, int devisionId,String token) async {
    try {
      final response = await dio.post(profilUrl,
       options: Options(headers: {
            'Content-Type': 'application/pdf',
            'Authorization': token
          }),
       data: {
        "userName": userName.trim(),
        "userPassword": password.trim(),
        "divisionId": devisionId
      });

      final decodedata = jsonDecode(response.toString());

      if (decodedata['status'] == 200) {
        return ResponseModel.fromJson(decodedata);
      } else {
        return ResponseModel.fromJson(decodedata);
      }
    } catch (e) {
      showMessage('Please Check Your Internet Connection', isWarning: true);
      log(e.toString());
      return null;
    }
  }
}
