import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class ViewAssetsScreen extends StatelessWidget {
  const ViewAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Builder(builder: (context) {
          return Consumer<NetworkService>(builder: (context, net, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  net.netisConnected == true ? "ONLINE" : "OFFLINE",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          });
        }),
        centerTitle: true,
        title: const AppPageHeadText(title: 'View Test Asset'),
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => AppMargin(
                  child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingSize10),
                height: h(context) * .1,
                width: w(context),
                color: index.isOdd ? AppColors.kBgColor2 : null,
                child: Text('Assset Id : '),
              )),
          separatorBuilder: (context, index) => const Divider(
                endIndent: 10,
                indent: 10,
              ),
          itemCount: 20),
    );
  }
}
