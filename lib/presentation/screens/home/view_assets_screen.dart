import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/services/network_service.dart';

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
          itemBuilder: (context, index) => AppMargin(child: const Text('Id')),
          separatorBuilder: (context, index) => const AppSpacer(
                heightPortion: .05,
              ),
          itemCount: 20),
    );
  }
}
