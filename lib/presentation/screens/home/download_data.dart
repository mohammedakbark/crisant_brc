
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/offline_add_entity_db.dart';
import 'package:test_managment/core/database/offline_test_entity_db.dart';
import 'package:test_managment/core/database/parameters_db.dart';
import 'package:test_managment/core/database/parameters_reason_db.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/services/local_db_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  @override
  void initState() {
    super.initState();
    LocalDatabaseService().fetchAllDatabases(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDatabaseService>(builder: (context, controller, _) {
      return PopScope(
        canPop: !controller.isDownloading,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  if (!controller.isDownloading) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              centerTitle: true,
              title: Text(
                'Download',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontSize18(context)),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const AppSpacer(
                    heightPortion: .01,
                  ),
                  Consumer<EntiteDb>(builder: (context, dbController, _) {
                    return _buildTile('Asset Types', dbController.lastSyncData,
                        () async {
                      //
                      dbController.storeEntity(context);
                    },
                        count: dbController.listOfEntityData.length,
                        dbController.isDownloading ?? false);
                  }),
                  Consumer<SectionInchargeDb>(
                      builder: (context, dbController, _) {
                    return _buildTile(
                        'Section Incharge', dbController.lastSyncData,
                        () async {
                      dbController.storeSectionIncharges(context);
                    },
                        count: dbController.listOfSectionIncharge.length,
                        dbController.isDownloading ?? false);
                  }),
                  Consumer<SectionDb>(
                    builder: (context, dbController, _) =>
                        _buildTile('Sections', dbController.lastSyncData, () {
                      dbController.storeSection(context);
                    },
                            count: dbController.listOfSection.length,
                            dbController.isDownloading ?? false),
                  ),
                  Consumer<BlockSectionDb>(
                    builder: (context, dbController, _) => _buildTile(
                        'Block Sections', dbController.lastSyncData, () {
                      dbController.storeBlockSections(context);
                    },
                        count: dbController.listOfBlockSections.length,
                        dbController.isDownloading ?? false),
                  ),
                  Consumer<StationDb>(
                      builder: (context, dbController, _) =>
                          _buildTile('Stations', dbController.lastSyncData, () {
                            dbController.storeStations(context);
                          },
                              count: dbController.listOfStationModel.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'Parameters', dbController.lastSyncData, () {
                            dbController.storeParameters(context);
                          },
                              count: dbController.listOfParameters.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersValueDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'Parameter Values', dbController.lastSyncData,
                              () {
                            dbController.storeParametersValues(context);
                          },
                              count: dbController.listOfParametersValues.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersReasonDb>(
                      builder: (context, dbController, _) =>
                          _buildTile('Reasons', dbController.lastSyncData, () {
                            dbController.storeParameterReson(context);
                          },
                              count: dbController.listOfParametersResons.length,
                              dbController.isDownloading ?? false)),
                  Consumer<EnitityProfileDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'Asset Profiles', dbController.lastSyncData, () {
                            dbController.storeEnitityProfile(context);
                          },
                              count: dbController.listOfEnitityProfiles.length,
                              dbController.isDownloading ?? false)),
                  Consumer<OfflineAddEntityDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'Asset Profiles - Offline',
                              dbController.lastSyncData, () {
                            dbController.getAllOfflineAddEntityDb();
                          },
                              count: dbController.listOfflineEntitites?.length,
                              dbController.isDownloading ?? false)),
                  Consumer<OfflineTestEntityDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'Test Reports - Offline',
                              dbController.lastSyncData,
                              hideDevider: true, () {
                            dbController.getAllPendingOfflineTest();
                          },
                              count: dbController.listOfflineEntitites?.length,
                              dbController.isDownloading ?? false)),
                  const AppSpacer(
                    heightPortion: .02,
                  )
                ],
              ),
            ),
            bottomNavigationBar: Consumer<LocalDatabaseService>(
                builder: (context, controller, _) {
              return InkWell(
                onTap: () async {
                  if (!controller.isDownloading) {
                    await controller.dowloadAllData(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: h(context) * .08,
                  width: w(context),
                  decoration:
                      BoxDecoration(color: AppColors.kWhite, boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        color: AppColors.kBlack.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(3, 0)),
                  ]),
                  child: const Text(
                    'DOWNLOAD ALL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            })),
      );
    });
  }

  Widget _buildTile(
      String title, String date, void Function()? onPressed, bool loading,
      {bool? hideDevider, int? count}) {
    return Column(
      children: [
        AppMargin(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.kPrimaryColor,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSize10)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSize15,
                  vertical: AppDimensions.paddingSize10),
              minLeadingWidth: w(context) * .35,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: w(context) * .5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          title,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: AppDimensions.fontSize18(context),
                              color: AppColors.kWhite,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          count != null ? "${count} Records" : "0 Records",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppDimensions.fontSize10(context),
                              color: AppColors.kWhite),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.fontSize18(context),
                            color: AppColors.kWhite),
                      ),
                      Align(
                        child: Text(
                          'Last updated',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: AppDimensions.fontSize10(context),
                              color: AppColors.kWhite),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loading
                          ? const SizedBox(
                              height: 5,
                              width: 5,
                              child: CircularProgressIndicator(
                                color: AppColors.kWhite,
                                strokeAlign: 2,
                                strokeWidth: 3,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                if (!Provider.of<LocalDatabaseService>(context,
                                        listen: false)
                                    .isDownloading) {
                                  return onPressed!();
                                }
                              },
                              child: const Icon(
                                size: 30,
                                Icons.download_for_offline,
                                color: AppColors.kWhite,
                              )),
                      loading
                          ? const AppSpacer(
                              heightPortion: .005,
                            )
                          : const SizedBox(),
                      Text(
                        'Download',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppDimensions.fontSize10(context),
                            color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        hideDevider == true
            ? const SizedBox()
            : const AppSpacer(
                heightPortion: .01,
              )
      ],
    );
  }
}
