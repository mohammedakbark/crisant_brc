import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/model/db%20models/entity_profile_model.dart';

class AssetProfiles extends StatefulWidget {
  final List<EntityProfileModel> listOfData;
  const AssetProfiles({super.key, required this.listOfData});

  @override
  State<AssetProfiles> createState() => _AssetProfilesState();
}

class _AssetProfilesState extends State<AssetProfiles> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    await getEachData();
    setState(() {
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> listOFData = [];

  Future getEachData() async {
    try {
      widget.listOfData
          .sort((a, b) => (b.modifiedDate).compareTo(a.modifiedDate));

      for (var i in widget.listOfData) {
        listOFData.add(await _convertIdIntoValue(i.entityId, i.entityProfileId,
            i.sectionInchargeId, i.sectionId, i.blockSectionId, i.stationId));
      }
    } catch (e) {
      showMessage("Something went wrong.");
    }
  }

  Future<Map<String, dynamic>> _convertIdIntoValue(assetTypeId, assetIds,
      sectionInchargeid, sectionid, blockSectionid, stationid) async {
    String assetType = await EntiteDb.getValueById(assetTypeId);
    String assetId = await EnitityProfileDb.getValueById(assetIds);
    String sectionIncharge =
        await SectionInchargeDb.getValueById(sectionInchargeid);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: Text(
            'assetsProfilesD'.tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontSize18(context)),
          ),
        ),
        body: isLoading
            ? const AppLoadingIndicator()
            : Padding(
                padding: const EdgeInsets.only(
                    top: AppDimensions.paddingSize10,
                    bottom: AppDimensions.paddingSize10),
                child: Builder(
                  builder: (
                    context,
                  ) {
                    final reports = widget.listOfData;
                    return reports.isEmpty
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
                                            backgroundColor:
                                                AppColors.kBgColor2,
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
                                            expandedAlignment:
                                                Alignment.topLeft,
                                            expandedCrossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(
                                                color: AppColors.kBgColor,
                                              ),
                                              tile(
                                                  'assetTypeCap'.tr(),
                                                  listOFData[index]
                                                      ['assetType']),
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
                                                  ? tile(
                                                      'stationCap'.tr(),
                                                      listOFData[index]
                                                          ['station'])
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
                            ],
                          );
                  },
                )));
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
