import 'package:flutter/cupertino.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';

class ViewAssetsScreen extends StatelessWidget {
  const ViewAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppPageHeadText(title: 'View Test Asset'),
        Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  AppMargin(child: const Text('Id')),
              separatorBuilder: (context, index) => const AppSpacer(
                    heightPortion: .05,
                  ),
              itemCount: 20),
        ),
      ],
    );
  }
}
