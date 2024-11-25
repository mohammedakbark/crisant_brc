import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/presentation/screens/home/widgets/tab_offlin_test_views.dart';

class OffTestReports extends StatelessWidget {
  const OffTestReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: Text(
          'testReportsOfflineD'.tr(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontSize18(context)),
        ),
      ),
      body: const TabOfflinTestViews(),
    );
  }
}
