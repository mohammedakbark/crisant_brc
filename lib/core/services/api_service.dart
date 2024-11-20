import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/add_new_asset_repo.dart';
import 'package:test_managment/core/repositories/add_new_test_repo.dart';
import 'package:test_managment/core/repositories/auth_repo.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/model/add_new_asset_model.dart';
import 'package:test_managment/model/reposrts%20models/test_report_add_model.dart';

class ApiService {
  static Future loginUser(
      String userName, String password, int devisionId, context) async {
    final result = await AuthRepo.loginUser(userName, password, devisionId);
    if (result != null && !result.error) {
      final Map<String, dynamic> data = result.data as Map<String, dynamic>;
      final token = data['token'];
      log(token.toString());
      // store data
      await Provider.of<AuthDb>(context, listen: false)
          .storeUserData(userName, password, devisionId, token);
      showMessage(result.message);
    } else {
      showMessage(result!.message);
    }
  } // ADD ASSET

  static Future<void> addNewAsset(
      BuildContext context, AddNewAssetModel model) async {
    final result = await AddNewAssetRepo().addNewAsset(context, model);
    if (result != null && !result.error) {
      showMessage(result.message);
    } else {
      showMessage(result!.message);
    }
  }

  static Future<void> addNewTest(
      BuildContext context, AddNewTestModel model) async {
    final result = await AddNewTestRepo().addNewTest(context, model);
    if (result != null && !result.error) {
      showMessage(result.message);
      log(result.data.toString());
    } else {
      showMessage(result!.message);
    }
  }

  // db
}
