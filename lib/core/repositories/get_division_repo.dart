import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_managment/core/utils/app_const.dart';
import 'package:test_managment/model/response_model.dart';

class GetDivisionRepo {

   Dio dio = Dio();
  final url = '${AppConst.baseURL}${AppConst.devisionURL}';

  Future<ResponseModel?> getDivisions(BuildContext context) async {
    try {
    
      final response = await dio.post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
           
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