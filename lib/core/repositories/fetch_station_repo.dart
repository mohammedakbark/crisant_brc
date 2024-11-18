import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/model/response_model.dart';
import 'package:test_managment/core/utils/app_const.dart';

class FetchStationRepo {
  Dio dio = Dio();
  final url = '${AppConst.baseURL}${AppConst.stationURL}';

  Future<ResponseModel?> fetchStation(BuildContext context) async {
    try {
      final token =
          await Provider.of<AuthDb>(context, listen: false).getUserData();
      final response = await dio.post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': token
          }));

      final decodedata = jsonDecode(response.toString());

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
