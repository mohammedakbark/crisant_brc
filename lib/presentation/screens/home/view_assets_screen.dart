import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/model/test_report_model.dart';

class ViewAssetsScreen extends StatefulWidget {
  const ViewAssetsScreen({super.key});

  @override
  State<ViewAssetsScreen> createState() => _ViewAssetsScreenState();
}

class _ViewAssetsScreenState extends State<ViewAssetsScreen> {
  List<TestReportsModel> reports = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    reports = await ApiService.getAllTestReports(context);
    setState(() {
      isLoading = false;
    });
  }

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
      body: isLoading
          ? AppLoadingIndicator()
          : Padding(
              padding: EdgeInsets.only(top: AppDimensions.paddingSize10),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    //   return AppMargin(
                    //       child: Container(
                    //     padding: EdgeInsets.all(AppDimensions.paddingSize10),
                    //     height: h(context) * .1,
                    //     width: w(context),
                    //     color: index.isOdd ? AppColors.kBgColor2 : null,
                    //     child: Text(report.entityProfileId),
                    //   ));
                    // },

                    return AppMargin(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 1,
                              color: AppColors.kBlack.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          collapsedBackgroundColor: AppColors.kWhite,
                          backgroundColor: AppColors.kWhite,
                          title: Text(report.entityProfileId),
                          expandedAlignment: Alignment.topLeft,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            tile('ENTITY', report.entityId),
                            tile('ENTITY PROFILE', report.entityId),
                            tile('SECTION INCHARGE', report.entityId),
                            tile('SECTION', report.sectionId),
                            report.blockSectionId != null
                                ? tile('BLOCK SECTION', report.blockSectionId!)
                                : SizedBox(),
                            report.stationId != null
                                ? tile('STATION', report.stationId!)
                                : SizedBox(),
                            tile('LATITUDE', report.testLatt),
                            tile('LONGITUDE', report.testLong)
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const AppSpacer(
                        heightPortion: .01,
                      ),
                  itemCount: reports.length),
            ),
    );
  }

  Widget tile(String head, String body) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSize25,
          vertical: AppDimensions.paddingSize5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            head,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontSize15(context)),
          ),
          Text(
            body,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppDimensions.fontSize15(context)),
          )
        ],
      ),
    );
  }
}
