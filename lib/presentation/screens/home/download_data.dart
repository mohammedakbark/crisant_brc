import 'package:easy_localization/easy_localization.dart';
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
import 'package:test_managment/core/utils/route.dart';
import 'package:test_managment/presentation/screens/home/pages/sync_off_test_reports.dart';
import 'package:test_managment/presentation/screens/home/pages/view_asset_profiles.dart';
import 'package:test_managment/presentation/screens/home/pages/sync_off_asset_profiles.dart';

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
                'download'.tr(),
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
                    return _buildTile(
                        'assetTypesD'.tr(), dbController.lastSyncData,
                        () async {
                      //
                      await dbController.storeEntity(context);
                    },
                        count: dbController.listOfEntityData.length,
                        dbController.isDownloading ?? false);
                  }),
                  Consumer<SectionInchargeDb>(
                      builder: (context, dbController, _) {
                    return _buildTile(
                        'sectionInchargesD'.tr(), dbController.lastSyncData,
                        () async {
                      await dbController.storeSectionIncharges(context);
                    },
                        count: dbController.listOfSectionIncharge.length,
                        dbController.isDownloading ?? false);
                  }),
                  Consumer<SectionDb>(
                    builder: (context, dbController, _) => _buildTile(
                        'sectionsD'.tr(), dbController.lastSyncData, () async {
                      await dbController.storeSection(context);
                    },
                        count: dbController.listOfSection.length,
                        dbController.isDownloading ?? false),
                  ),
                  Consumer<BlockSectionDb>(
                    builder: (context, dbController, _) => _buildTile(
                        'blockSectionsD'.tr(), dbController.lastSyncData,
                        () async {
                      await dbController.storeBlockSections(context);
                    },
                        count: dbController.listOfBlockSections.length,
                        dbController.isDownloading ?? false),
                  ),
                  Consumer<StationDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'stationsD'.tr(), dbController.lastSyncData,
                              () async {
                            await dbController.storeStations(context);
                          },
                              count: dbController.listOfStationModel.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'parametersD'.tr(), dbController.lastSyncData,
                              () async {
                            await dbController.storeParameters(context);
                          },
                              count: dbController.listOfParameters.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersValueDb>(
                      builder: (context, dbController, _) => _buildTile(
                              'parametersValuesD'.tr(),
                              dbController.lastSyncData, () async {
                            await dbController.storeParametersValues(context);
                          },
                              count: dbController.listOfParametersValues.length,
                              dbController.isDownloading ?? false)),
                  Consumer<ParametersReasonDb>(
                      builder: (context, dbController, _) =>
                          _buildTile('reasonsD'.tr(), dbController.lastSyncData,
                              () async {
                            await dbController.storeParameterReson(context);
                          },
                              count: dbController.listOfParametersResons.length,
                              dbController.isDownloading ?? false)),
                  Consumer<EnitityProfileDb>(
                      builder: (context, dbController, _) => InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(AppRoutes.createRoute(AssetProfiles(
                                listOfData: dbController.listOfEnitityProfiles,
                              )));
                            },
                            child: _buildTile('assetsProfilesD'.tr(),
                                dbController.lastSyncData, () async {
                              await dbController.storeEnitityProfile(context);
                            },
                                count:
                                    dbController.listOfEnitityProfiles.length,
                                dbController.isDownloading ?? false),
                          )),
                  Consumer<OfflineAddEntityDb>(
                    builder: (context, dbController, _) => InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(AppRoutes.createRoute(OffAssetProfiles()));
                      },
                      child: _buildTile(
                        'assetProfilesofflineD'.tr(),
                        dbController.lastSyncData,
                        () async {
                          // await Provider.of<OfflineAddEntityDb>(context,
                          //         listen: false)
                          //     .offlineAddAssetToServer(
                          //   context,
                          // );
                          await dbController.getAllOfflineAddEntityDb();
                        },
                        count: dbController.listOfflineEntitites?.length,
                        dbController.isDownloading ?? false,
                        // showSync: true,
                        // onTap: () async {
                        //   // await Provider.of<OfflineAddEntityDb>(context,
                        //   //         listen: false)
                        //   //     .storeAllOfflineDataToServer(
                        //   //   context,
                        //   // );
                        // },
                      ),
                    ),
                  ),
                  Consumer<OfflineTestEntityDb>(
                      builder: (context, dbController, _) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  AppRoutes.createRoute(OffTestReports()));
                            },
                            child: _buildTile(
                              'testReportsOfflineD'.tr(),
                              dbController.lastSyncData,
                              hideDevider: true,
                              () async {
                                await dbController.getAllPendingOfflineTest();
                                // await Provider.of<OfflineTestEntityDb>(context,
                                //         listen: false)
                                //     .offlineSyncTestToServer(context);
                              },
                              count: dbController.listOfflineEntitites?.length,
                              dbController.isDownloading ?? false,
                              // showSync: true,
                              // onTap: () async {
                              //   await Provider.of<OfflineTestEntityDb>(context,
                              //           listen: false)
                              //       .storeAllOfflineDataToServer(context);
                              // },
                            ),
                          )),
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
                  child: Text(
                    'downloadAll'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            })),
      );
    });
  }

  Widget _buildTile(
    String title,
    String date,
    void Function()? onPressed,
    bool loading, {
    bool? hideDevider,
    int? count,
    bool? showSync,
    // void Function()? onTap
  }) {
    return Column(
      children: [
        AppMargin(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSize15,
                      vertical: AppDimensions.paddingSize10),
                  decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSize10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width:
                            // showSync == true
                            //     ? w(context) * .3
                            // :
                            w(context) * .5,
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
                              count != null
                                  ? "${count} ${'records'.tr()}"
                                  : "0 ${'records'.tr()}",
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
                              'lastUpdated'.tr(),
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
                                    if (!Provider.of<LocalDatabaseService>(
                                            context,
                                            listen: false)
                                        .isDownloading) {
                                      return onPressed!();
                                    }
                                  },
                                  child: Icon(
                                    size: 30,
                                    showSync == true
                                        ? Icons.cloud_sync_sharp
                                        : Icons.download_for_offline,
                                    color: AppColors.kWhite,
                                  )),
                          loading
                              ? const AppSpacer(
                                  heightPortion: .005,
                                )
                              : const SizedBox(),
                          Text(
                            showSync == true ? "Sync" : 'download'.tr(),
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
              // if (showSync == true) ...[
              //   // TextButton(
              //   //   onPressed: onTap,
              //   //   child: Text("Sync"),
              //   // )
              // ]
            ],
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
