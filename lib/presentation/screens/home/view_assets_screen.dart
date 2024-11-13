import 'package:flutter/cupertino.dart';
import 'package:test_managment/presentation/components/app_margin.dart';
import 'package:test_managment/presentation/components/app_page_head_text.dart';
import 'package:test_managment/presentation/components/app_spacer.dart';

class ViewAssetsScreen extends StatelessWidget {
  const ViewAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppMargin(
      child: Column(
        children: [
          const AppPageHeadText(title: 'View Test Asset'),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) => const Text('Id'),
                  separatorBuilder: (context, index) => const AppSpacer(
                        heightPortion: .05,
                      ),
                  itemCount: 10))
        ],
      ),
    );
  }
}
