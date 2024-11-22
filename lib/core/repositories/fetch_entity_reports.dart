import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/utils/app_const.dart';
import 'package:test_managment/model/response_model.dart';

class FetchEntityReports {
  Dio dio = Dio();
  final url = '${AppConst.baseURL}${AppConst.entityTestReport}';

  Future<ResponseModel?> fetchEntitiesTestReports(BuildContext context) async {
    try {
      final token =
          await Provider.of<AuthDb>(context, listen: false).getUserData();
      final response = await dio.post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': token
          }));

      final decodedata = jsonDecode(response.toString());
      // log(decodedata.toString());

      if (decodedata['status'] == 200) {
        return ResponseModel.fromJson(decodedata);
      } else {
        return ResponseModel.fromJson(decodedata);
      }
    } catch (e) {
      return null;
    }
  }
}
