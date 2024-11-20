import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/controller/parameter_controller.dart';
import 'package:test_managment/core/controller/test_asset_controller.dart';
import 'package:test_managment/core/components/custom_dropdown_field.dart';
import 'package:test_managment/core/components/custom_form_field.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/model/parameter_values_model.dart';
import 'package:test_managment/model/parameters_model.dart';

class AdditionalQuestionView extends StatefulWidget {
  const AdditionalQuestionView({super.key});

  @override
  State<AdditionalQuestionView> createState() => _AdditionalQuestionViewState();
}

class _AdditionalQuestionViewState extends State<AdditionalQuestionView> {
  getFilterParametersValue() {}

  List<ParameterValuesModel> allListOfparametrsValue = [];
  @override
  void initState() {
    super.initState();
    allListOfparametrsValue =
        Provider.of<ParametersValueDb>(context, listen: false)
            .listOfParametersValues;
  }

  List<Map<String, dynamic>> filterParametsrValue(ParametersModel parameter) {
    final filterdParameterValues = allListOfparametrsValue
        .where((element) => element.parameterId == parameter.parameterId)
        .toList();
    List<Map<String, dynamic>> map = [];
    for (var i in filterdParameterValues) {
      // Provider.of<ParameterController>(context,listen: false).listOfParametersValueList?.add(value)
      map.add({
        'title': i.parameterValue,
        'id': i.parameterValueId,
        'data': i.toJson()
      });
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
          children: [
            if (parameter.parameterType == 'SELECT') ...[
              Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleText(parameter.parameterName,
                        isRequired:
                            parameter.mandatory == 'YES' ? true : false),
                    CustomDropdownField(
                        items: filterParametsrValue(parameter),
                        onCallBack: (p0) {
                          
                        },
                        hintText: parameter.parameterName),
                  ],
                );
              })
            ],
            if (parameter.parameterType == 'INPUT') ...[
              // CustomFormField(
              //     controller: ctlr.textedEditionControllers[0]['0']!,
              //     hintText: parameter.value.parameterName),
            ]
          ],
        );
      }).toList());
    });
  }

  Widget wayStationEquipView() {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Remarks..'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[0]['0']!,
              hintText: 'Remarks..'),
          _titleText('Way STN Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK', 'OK (NOT IN USE)'],
          //     onChanged: (value) {},
          //     hintText: 'Select')
        ],
      );
    });
  }

  Widget fourWRepeater() {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Available Eq. Amp. Cards', isRequired: true),
          CustomFormField(
              isRequiredField: true,
              controller: ctlr.textedEditionControllers[0]['0']!,
              hintText: 'Available Eq. Amp. Cards'),
          _titleText('Available ISO TRF Cards', isRequired: true),
          CustomFormField(
              isRequiredField: true,
              controller: ctlr.textedEditionControllers[1]['1']!,
              hintText: 'Available ISO TRF Cards'),
          _titleText('Card Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Battery voltage on Load', isRequired: true),
          // CustomFormField(
          //     isRequiredField: true,
          //     controller: ctlr.textedEditionControllers[2]['2']!,
          //     hintText: 'Battery voltage on Load'),
          // _titleText('Battery Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          _titleText('Remarks'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[3]['3']!,
              hintText: 'Remarks'),
        ],
      );
    });
  }

  Widget lcGetePhone() {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Battery Voltage', isRequired: true),
          CustomFormField(
              isRequiredField: true,
              controller: ctlr.textedEditionControllers[0]['0']!,
              hintText: 'Battery Voltage'),
          _titleText('I/P Ring Voltage on line'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[1]['1']!,
              hintText: 'I/P Ring Voltage on line'),
          _titleText('O/p Ring Voltage on line'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[2]['2']!,
              hintText: 'O/p Ring Voltage on line'),
          _titleText('LC Phone Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          // hintText: 'Select'),
          _titleText('Remarks'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[3]['3']!,
              hintText: 'Remarks'),
        ],
      );
    });
  }

  Widget ecSocket() {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Box Condtion', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Socket Condition', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Box Type', isRequired: true),
          // CustomDropdownField(
          //     items: const ['IRON Type', 'FRP Type'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          _titleText('Remarks'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[0]['0']!,
              hintText: 'Remarks'),
        ],
      );
    });
  }

  Widget batteryCharger() {
    return Consumer<TestAssetsController>(builder: (context, ctlr, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText('Charger Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Battery Working Status', isRequired: true),
          // CustomDropdownField(
          //     items: const ['OK', 'NOT OK'],
          //     onChanged: (value) {},
          //     hintText: 'Select'),
          // _titleText('Out Put Voltage', isRequired: true),
          CustomFormField(
            isRequiredField: true,
            controller: ctlr.textedEditionControllers[0]['0']!,
            hintText: 'Out Put Voltage',
          ),
          _titleText('Bateery Voltage on Load', isRequired: true),
          CustomFormField(
              isRequiredField: true,
              controller: ctlr.textedEditionControllers[1]['1']!,
              hintText: 'Bateery Voltage on Load'),
          _titleText('Remarks'),
          CustomFormField(
              controller: ctlr.textedEditionControllers[2]['2']!,
              hintText: 'Remarks'),
        ],
      );
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
                children: (isRequired == null)
                    ? []
                    : [
                        const TextSpan(
                            text: " *", style: TextStyle(color: AppColors.kRed))
                      ])));
  }
}
