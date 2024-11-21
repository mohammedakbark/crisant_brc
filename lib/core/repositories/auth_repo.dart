import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:test_managment/model/response_model.dart';
import 'package:test_managment/core/utils/app_const.dart';

class AuthRepo {
  static Dio dio = Dio();
  static const url = '${AppConst.baseURL}${AppConst.loginURL}';
  static Future<ResponseModel?> loginUser(
      String userName, String password, int devisionId) async {
    try {
      final response = await dio.post(url, data: {
        "userName": userName,
        "userPassword": password,
        "divisionId": devisionId
      });

      final decodedata = jsonDecode(response.toString());

      if (decodedata['status'] == 200) {
        return ResponseModel.fromJson(decodedata);
      } else {
        return ResponseModel.fromJson(decodedata);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
