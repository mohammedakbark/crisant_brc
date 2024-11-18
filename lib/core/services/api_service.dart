import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/auth_repo.dart';
import 'package:test_managment/core/database/auth_db.dart';

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
  }
}
