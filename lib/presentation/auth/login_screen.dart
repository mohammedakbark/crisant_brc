import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/shared_pre_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/first_time_downloading_screen.dart';
import 'package:test_managment/presentation/screens/dashboard.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('data'),
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingSize20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SIGN IN',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppDimensions.fontSize25(context)),
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
                      showLoaingIndicator(context);
                      final response = await ApiService.loginUser(
                          usernameController.text,
                          passwordController.text,
                          1,
                          context);
                      closeLoadingIndicator(context);
                      if (response) {
                        Navigator.of(context).pushAndRemoveUntil(
                          AppRoutes.createRoute(const DashboardScreen()),
                          (route) => false,
                        );
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
