import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/repositories/add_new_asset_repo.dart';
import 'package:test_managment/core/repositories/add_new_test_repo.dart';
import 'package:test_managment/core/repositories/auth_repo.dart';
import 'package:test_managment/core/database/auth_db.dart';
import 'package:test_managment/core/repositories/fetch_entity_reports.dart';
import 'package:test_managment/core/repositories/get_division_repo.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/model/add_new_asset_model.dart';
import 'package:test_managment/model/divisions_model.dart';
import 'package:test_managment/model/reposrts%20models/test_report_add_model.dart';
import 'package:test_managment/model/test_report_model.dart';

class ApiService {
  static Future<bool> loginUser(String userName, String password,
      int devisionId, String divisonName, context) async {
    try {
      final result = await AuthRepo.loginUser(userName, password, devisionId);
      if (result != null) {
        if (!result.error) {
          final Map<String, dynamic> data = result.data as Map<String, dynamic>;
          final token = data['token'];
          log(token.toString());
          final profileResult = await AuthRepo.getUserProfileData(
              userName, password, devisionId, token);

          // store data
          if (profileResult != null) {
            if (!profileResult.error) {
              final Map<String, dynamic> data =
                  profileResult.data as Map<String, dynamic>;
              log('da');

              await Provider.of<AuthDb>(context, listen: false).storeUserData(
                  data['user']['userinfo']['userFullName'],
                  password,
                  devisionId,
                  token,
                  divisonName);
            } else {
              log('dasss');
              await Provider.of<AuthDb>(context, listen: false).storeUserData(
                  userName, password, devisionId, token, divisonName);
            }
          } else {
            log('daaaaaaa');

            await Provider.of<AuthDb>(context, listen: false).storeUserData(
                userName, password, devisionId, token, divisonName);
          }
          showMessage(result.message);
          return true;
        } else {
          showMessage(result.message, isWarning: true);
          return false;
        }
      } else {
        log('message');
        return false;
      }
    } catch (e) {
      log("Error - Login - ${e}");
      return false;
    }
  } // ADD ASSET

  static Future<bool> addNewAsset(
      BuildContext context, AddNewAssetModel model) async {
    final result = await AddNewAssetRepo().addNewAsset(context, model);
    if (result != null) {
      if (!result.error) {
        errorSnackBar(context, result.message);
        return true;
      } else {
        errorSnackBar(context, result.message, isError: true);
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> addNewTest(
      BuildContext context, AddNewTestModel model) async {
    final result = await AddNewTestRepo().addNewTest(context, model);
    if (result != null) {
      if (!result.error) {
        errorSnackBar(context, result.message);

        log(result.data.toString());
        return true;
      } else {
        errorSnackBar(context, result.message, isError: true);
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<List<TestReportsModel>> getAllTestReports(
      BuildContext context) async {
    if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
        true) {
      final result =
          await FetchEntityReports().fetchEntitiesTestReports(context);
      if (result != null) {
        if (!result.error) {
          final data = result.data as List;
          List<TestReportsModel> lis = data
              .map(
                (e) => TestReportsModel.fromJson(e),
              )
              .toList();
          log(lis.length.toString());
          // Sort in descending order by createdDate
          lis.sort((a, b) => (b.createdDate).compareTo(a.createdDate));
          return lis;
        } else {
          showMessage(result.message);
          return [];
        }
      } else {
        showMessage('Test Report Feching Failed');
        return [];
      }
    } else {
      showMessage('Please Check Your Internet Connection');
      return [];
    }
  }

  static Future<List<DivisionsModel>> getAllDivision(
      BuildContext context) async {
    if (Provider.of<NetworkService>(context, listen: false).netisConnected ==
        true) {
      final result = await GetDivisionRepo().getDivisions(context);
      if (result != null) {
        if (!result.error) {
          final data = result.data as List;
          List<DivisionsModel> lis = data
              .map(
                (e) => DivisionsModel.fromJson(e),
              )
              .toList();
          log(lis.length.toString());
          // Sort in descending order by createdDate
          lis.sort((a, b) => (a.divisionName).compareTo(b.divisionName));
          return lis;
        } else {
          showMessage(result.message);
          return [];
        }
      } else {
        showMessage('Test Report Feching Failed');
        return [];
      }
    } else {
      showMessage('Please Check Your Internet Connection');
      return [];
    }
  }
}
