import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';

import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/model/divisions_model.dart';
import 'package:test_managment/presentation/screens/dashboard.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DivisionsModel> divison = [];

  getData() async {
    divison = await ApiService.getAllDivision(context);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  String? selectedDivisonId;
  String? devisionName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('data'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSize20),
          child: SizedBox(
            width: w(context),
            height: h(context),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // const Spacer(),
                  SizedBox(
                      width: w(context) * .3,
                      height: w(context) * .3,
                      child: Image.asset('assets/assets_logo.png')),
                  const AppSpacer(
                    heightPortion: .05,
                  ),
                  Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimensions.fontSize25(context)),
                  ),
                  const AppSpacer(
                    heightPortion: .025,
                  ),
                  DropdownButtonFormField<DivisionsModel>(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select division';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: "Division"),
                    items: divison.isEmpty
                        ? []
                        : divison
                            .map((e) => DropdownMenuItem<DivisionsModel>(
                                value: e, child: Text(e.divisionName)))
                            .toList(),
                    onChanged: (value) {
                      selectedDivisonId = value?.divisionId ?? '';
                      devisionName = value?.divisionName ?? '';
                    },
                  ),
                  const AppSpacer(
                    heightPortion: .025,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter user name';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    controller: usernameController,
                  ),
                  const AppSpacer(
                    heightPortion: .025,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      } else {
                        return null;
                      }
                    },
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    controller: passwordController,
                  ),
                  const AppSpacer(
                    heightPortion: .1,
                  ),
                  CustomButton(
                      title: 'LOGIN',
                      onTap: () async {
                        print('object');
                        if (_formKey.currentState!.validate()) {
                          // log(devisionName.toString());
                          // log(selectedDivisonId.toString());
                          showLoaingIndicator(context);
                          final response = await ApiService.loginUser(
                              usernameController.text,
                              passwordController.text,
                              int.parse(selectedDivisonId!),
                              devisionName!,
                              context);
                          closeLoadingIndicator(context);
                          if (response) {
                            Navigator.of(context).pushAndRemoveUntil(
                              AppRoutes.createRoute(const DashboardScreen()),
                              (route) => false,
                            );
                          }
                        }
                      }),
                  const Spacer(),

                  Text(
                    "Designed & developed by",
                    style: TextStyle(
                      color: AppColors.kBlack,
                      fontSize: AppDimensions.fontSize13(context),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Crisant Technologies, ",
                        style: TextStyle(
                            fontSize: AppDimensions.fontSize15(context),
                            color: AppColors.kBlack,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: "Mysuru",
                            style: TextStyle(
                                fontSize: AppDimensions.fontSize13(context),
                                color: AppColors.kBlack,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  const AppSpacer(
                    heightPortion: .05,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
