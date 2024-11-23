import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/controller/parameter_controller.dart';
import 'package:test_managment/core/controller/test_asset_controller.dart';
import 'package:test_managment/core/components/custom_dropdown_field.dart';
import 'package:test_managment/core/components/custom_form_field.dart';
import 'package:test_managment/core/database/parameters_reason_db.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/model/db%20models/parameter_reson_model.dart';
import 'package:test_managment/model/db%20models/parameter_values_model.dart';
import 'package:test_managment/model/db%20models/parameters_model.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';

class AdditionalQuestionView extends StatefulWidget {
  const AdditionalQuestionView({super.key});

  @override
  State<AdditionalQuestionView> createState() => _AdditionalQuestionViewState();
}

class _AdditionalQuestionViewState extends State<AdditionalQuestionView> {
  List<ParameterValuesModel> allListOfparametrsValue = [];
  List<ParameterReasonModel> allListOfparametrsReason = [];
  @override
  void initState() {
    super.initState();
    allListOfparametrsValue =
        Provider.of<ParametersValueDb>(context, listen: false)
            .listOfParametersValues;

    allListOfparametrsReason =
        Provider.of<ParametersReasonDb>(context, listen: false)
            .listOfParametersResons;
  }

  List<Map<String, dynamic>> getfilterParametsrValue(
      ParametersModel parameter) {
    final filterdParameterValuesList = allListOfparametrsValue
        .where((element) => element.parameterId == parameter.parameterId)
        .toList();
    List<Map<String, dynamic>> map = [];
    for (var i in filterdParameterValuesList) {
      // Provider.of<ParameterController>(context,listen: false).listOfParametersValueList?.add(value)
      map.add({
        'title': i.parameterValue,
        'id': i.parameterValueId,
        'data': i.toJson()
      });
    }
    return map;
  }

  List<Map<String, dynamic>> getfilterParametsrReason(
      String selectedparametervalueId) {
    final filterdParameterResonListList = allListOfparametrsReason
        .where(
            (element) => element.parameterValueId == selectedparametervalueId)
        .toList();
    List<Map<String, dynamic>> map = [];
    for (var i in filterdParameterResonListList) {
      // Provider.of<ParameterController>(context,listen: false).listOfParametersValueList?.add(value)
      map.add(
          {'title': i.reason, 'id': i.parameterReasonId, 'data': i.toJson()});
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
          children: ctlr.filterdParameters!.asMap().entries.map((parameterRef) {
        final parameter = parameterRef.value;
        final index = parameterRef.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (parameter.parameterType == 'SELECT') ...[
              Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DROPDOWN FIELD
                    _titleText(parameter.parameterName,
                        isRequired:
                            parameter.mandatory == 'YES' ? true : false),
                    CustomDropdownField(
                        dontShowTitle: true,
                        items: getfilterParametsrValue(parameter),
                        onCallBack: (p0) {
                          final data =
                              ParameterValuesModel.fromJson(p0['data']);

                          if (data.parameterStatus == 'VALID') {
                            ctlr.onChangeTheParameterValue(index, true,
                                data.parameterValueId, data.parameterId);
                          } else {
                            ctlr.onChangeTheParameterValue(index, false,
                                data.parameterValueId, data.parameterId);
                          }
                        },
                        hintText: parameter.parameterName),
                    // IF NOT OK
                    if (ctlr.infinityHelperData != null) ...[
                      if (ctlr.infinityHelperData?[index]['bool'] == false) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _titleText('reason'.tr(), isRequired: true),
                            CustomDropdownField(
                                dontShowTitle: true,
                                items: getfilterParametsrReason(
                                    ctlr.infinityHelperData?[index]
                                        ['parameterValue']),
                                onCallBack: (value) {
                                  final data = ParameterReasonModel.fromJson(
                                      value['data']);
                                  ctlr.onChangeTheParameterReason(
                                      index, data.parameterReasonId);
                                },
                                hintText: 'reason'.tr()),
                          ],
                        ),
                      ]
                    ]
                  ],
                );
              })
            ],

            // TEXTFORMFIELD
            if (parameter.parameterType == 'INPUT') ...[
              Builder(
                builder: (context) {
                  // ctlr.getTextFieldData(index, parameter.parameterId);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleText(parameter.parameterName,
                          isRequired:
                              parameter.mandatory == 'YES' ? true : false),
                      CustomFormField(
                          controller: ctlr.infinityControllers![index]
                              ['$index'],
                          isRequiredField:
                              parameter.mandatory == 'YES' ? true : false,
                          hintText: parameter.parameterName),
                      // TextButton(
                      //     onPressed: () {
                      //       log(ctlr
                      //           .infinityControllers![index]['$index']!.text);
                      //     },
                      //     child: Text('test'))
                    ],
                  );
                },
              ),
            ]
          ],
        );
      }).toList());
    });
  }

  Widget _titleText(String title, {bool? isRequired}) {
    return Padding(
        padding:
            const EdgeInsets.symmetric(vertical: AppDimensions.paddingSize5),
        child: RichText(
            text: TextSpan(
                text: title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.kBlack),
                children: (isRequired == null||isRequired == false)
                    ? []
                    : [
                        const TextSpan(
                            text: " *", style: TextStyle(color: AppColors.kRed))
                      ])));
  }
}
