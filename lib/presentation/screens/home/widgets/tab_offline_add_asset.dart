import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/offline_add_entity_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class TabOfflineAddAsset extends StatefulWidget {
  const TabOfflineAddAsset({super.key});

  @override
  State<TabOfflineAddAsset> createState() => _TabOfflineAddAssetState();
}

class _TabOfflineAddAssetState extends State<TabOfflineAddAsset> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    await Provider.of<OfflineAddEntityDb>(context, listen: false)
        .getAllOfflineAddEntityDb(dontList: true);
    await getEachData();
    await Provider.of<OfflineAddEntityDb>(context, listen: false)
      .offlineAddAssetToServer(context);

    setState(() {
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> listOFData = [];
  Future getEachData() async {
    try {
      final list = Provider.of<OfflineAddEntityDb>(context, listen: false)
          .listOfflineEntitites;
      for (var i in list!) {
        listOFData.add(await _convertIdIntoValue(i.entityId, i.entityIdentifier,
            i.sectionInchargeId, i.sectionId, i.blockSectionId, i.stationId));
      }
    } catch (e) {
      log(e.toString());
      showMessage("Something went wrong.");
    }
  }

  Future<Map<String, dynamic>> _convertIdIntoValue(assetTypeId, assetIds,
      sectionInchargeid, sectionid, blockSectionid, stationid) async {
    String assetType = await EntiteDb.getValueById(assetTypeId);
    String assetId = assetIds;
    final ddd = await SectionInchargeDb.getValueById(sectionInchargeid);
      String sectionIncharge = ddd ?? "N/A";
    String section = await SectionDb.getValueById(sectionid);
    String blockSection = (blockSectionid == null ||
            blockSectionid.isEmpty ||
            blockSectionid == "null")
        ? "N/A"
        : await BlockSectionDb.getValueById(blockSectionid);
    String station =
        (stationid == null || stationid.isEmpty || stationid == "null")
            ? "N/A"
            : await StationDb.getValueById(stationid);
    return {
      "assetType": assetType,
      "assetId": assetId,
      "sectionIncharge": sectionIncharge,
      "section": section,
      "blockSection": blockSection,
      "station": station,
    };
  }
//---------------------------

  Future<void> syncData() async {
    await Provider.of<OfflineAddEntityDb>(context, listen: false)
        .offlineAddAssetToServer(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const AppLoadingIndicator()
        : Padding(
            padding: const EdgeInsets.only(
                top: AppDimensions.paddingSize10,
                bottom: AppDimensions.paddingSize10),
            child: Consumer<OfflineAddEntityDb>(
              builder: (context, controller, child) {
                final reports = controller.listOfflineEntitites;
                return reports!.isEmpty
                    ? Center(child: Text('noRecordFoundMessage'.tr()))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final report = reports[index];

                                  return AppMargin(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 1,
                                            color: AppColors.kBlack
                                                .withOpacity(0.2),
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
                                        collapsedBackgroundColor:
                                            AppColors.kWhite,
                                        backgroundColor: AppColors.kBgColor2,
                                        title: Text(
                                          listOFData[index]['assetId'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  AppDimensions.fontSize16(
                                                      context)),
                                        ),
                                        // subtitle: Text(report.),
                                        // trailing: Text(
                                        //   report.createdDate.toString(),
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.w400,
                                        //       fontSize:
                                        //           AppDimensions.fontSize13(context)),
                                        // ),
                                        expandedAlignment: Alignment.topLeft,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(
                                            color: AppColors.kBgColor,
                                          ),
                                          tile('assetTypeCap'.tr(),
                                              listOFData[index]['assetType']),
                                          tile('assetIdCap'.tr(),
                                              listOFData[index]['assetId']),
                                          tile(
                                              'sectionInchargeCap'.tr(),
                                              listOFData[index]
                                                  ['sectionIncharge']),
                                          tile('sectionCap'.tr(),
                                              listOFData[index]['section']),
                                          report.blockSectionId != null
                                              ? tile(
                                                  'blockSectionCap'.tr(),
                                                  listOFData[index]
                                                      ['blockSection'])
                                              : const SizedBox(),
                                          report.stationId != null
                                              ? tile('stationCap'.tr(),
                                                  listOFData[index]['station'])
                                              : const SizedBox(),
                                          tile('latitudeCap'.tr(),
                                              report.entityLatt),
                                          tile('longitudeCap'.tr(),
                                              report.entityLong)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const AppSpacer(
                                      heightPortion: .01,
                                    ),
                                itemCount: reports.length),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingSize10),
                            child: InkWell(
                              onTap: () async {
                                await syncData();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: h(context) * .06,
                                width: w(context) * .4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusSize50),
                                    color: AppColors.kPrimaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 1,
                                          color:
                                              AppColors.kBlack.withOpacity(0.2),
                                          blurRadius: 2,
                                          offset: const Offset(2, 1)),
                                    ]),
                                child: Text(
                                  'syncAll'.tr(),
                                  style: TextStyle(
                                      color: AppColors.kWhite,
                                      fontSize:
                                          AppDimensions.fontSize16(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
              },
            ));
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