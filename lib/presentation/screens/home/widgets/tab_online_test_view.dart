import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/model/test_report_model.dart';

class TabOnlineTestView extends StatefulWidget {
  const TabOnlineTestView({super.key});

  @override
  State<TabOnlineTestView> createState() => _TabOnlineTestViewState();
}

class _TabOnlineTestViewState extends State<TabOnlineTestView> {
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
    return isLoading
        ? const AppLoadingIndicator()
        : Padding(
            padding: const EdgeInsets.only(
                top: AppDimensions.paddingSize10,
                bottom: AppDimensions.paddingSize10),
            child: reports.isEmpty
                ? const Center(child: Text('No records found'))
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final report = reports[index];

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
                            // controller: controller,
                            onExpansionChanged: (value) {},
                            shape: const BeveledRectangleBorder(
                                side: BorderSide.none),
                            collapsedBackgroundColor: AppColors.kWhite,
                            backgroundColor: AppColors.kBgColor2,
                            title: Text(
                              report.entityProfileId,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppDimensions.fontSize16(context)),
                            ),
                            subtitle: Text(report.distance),
                            trailing: Text(
                              report.createdDate.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppDimensions.fontSize13(context)),
                            ),
                            expandedAlignment: Alignment.topLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: AppColors.kBgColor,
                              ),
                              tile('ASSET TYPE', report.entityId),
                              tile('ASSET ID', report.entityProfileId),
                              tile('SECTION INCHARGE', report.entityId),
                              tile('SECTION', report.sectionId),
                              report.blockSectionId != null
                                  ? tile(
                                      'BLOCK SECTION', report.blockSectionId!)
                                  : const SizedBox(),
                              report.stationId != null
                                  ? tile('STATION', report.stationId!)
                                  : const SizedBox(),
                              tile('LATITUDE', report.testLatt),
                              tile('LONGITUDE', report.testLong),
                              tile('DISTANCE', report.distance)
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const AppSpacer(
                          heightPortion: .01,
                        ),
                    itemCount: reports.length),
          );
  }

  Widget tile(String head, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(
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
