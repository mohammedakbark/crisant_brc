import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/database/block_section_db.dart';
import 'package:test_managment/core/database/enitity_profile_db.dart';
import 'package:test_managment/core/database/entite_db.dart';
import 'package:test_managment/core/database/offline_db.dart';
import 'package:test_managment/core/database/parameters_db.dart';
import 'package:test_managment/core/database/parameters_reason_db.dart';
import 'package:test_managment/core/database/parameters_value_db.dart';
import 'package:test_managment/core/database/section_db.dart';
import 'package:test_managment/core/database/section_incharge_db.dart';
import 'package:test_managment/core/database/station_db.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/services/local_service.dart';
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
    // TODO: implement initState
    super.initState();
    LocalDatabaseService().fetchAllDatabases(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Container(
                width: w(context),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSize10,
                    vertical: AppDimensions.paddingSize10),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSize10,
                    vertical: AppDimensions.paddingSize20),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSize18),
                    border:
                        Border.all(width: .5, color: AppColors.kPrimaryColor)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_done_outlined,
                      color: AppColors.kPrimaryColor,
                    ),
                    AppSpacer(
                      widthPortion: .02,
                    ),
                    Text(
                      'Everything is updated !',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.kPrimaryColor),
                    ),
                  ],
                )),
            const AppSpacer(
              heightPortion: .01,
            ),
            Consumer<EntiteDb>(builder: (context, dbController, _) {
              return Column(
                children: [
                  _buildTile('Entities', '12-12-2024', () async {
//
                    dbController.storeEntity(context);
                  }, dbController.isDownloading ?? false),
                  Text(dbController.listOfEntityData.length.toString())
                ],
              );
            }),
            Consumer<SectionInchargeDb>(builder: (context, dbController, _) {
              return Column(
                children: [
                  _buildTile('Section Incharge', '12-12-2024', () async {
                    dbController.storeSectionIncharges(context);
                  }, dbController.isDownloading ?? false),
                  Text(dbController.listOfSectionIncharge.length.toString())
                ],
              );
            }),
            Consumer<SectionDb>(
              builder: (context, dbController, _) => Column(
                children: [
                  _buildTile('Section', '12-12-2024', () {
                    dbController.storeSection(context);
                  }, dbController.isDownloading ?? false),
                  Text(dbController.listOfSection.length.toString())
                ],
              ),
            ),
            Consumer<BlockSectionDb>(
              builder: (context, dbController, _) => Column(
                children: [
                  _buildTile('Block Section', '12-12-2024', () {
                    dbController.storeBlockSections(context);
                  }, dbController.isDownloading ?? false),
                  Text(dbController.listOfBlockSections.length.toString())
                ],
              ),
            ),
            Consumer<StationDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Station', '12-12-2024', () {
                        dbController.storeStations(context);
                      }, dbController.isDownloading ?? false),
                      Text(dbController.listOfStationModel.length.toString())
                    ])),
            Consumer<ParametersDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Parameters', '12-12-2024', () {
                        dbController.storeParameters(context);
                      }, dbController.isDownloading ?? false),
                      Text(dbController.listOfParameters.length.toString())
                    ])),
            Consumer<ParametersValueDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Parameters Value', '12-12-2024', () {
                        dbController.storeParametersValues(context);
                      }, dbController.isDownloading ?? false),
                      Text(
                          dbController.listOfParametersValues.length.toString())
                    ])),
            Consumer<ParametersReasonDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Parameters Reason', '12-12-2024', () {
                        dbController.storeParameterReson(context);
                      }, dbController.isDownloading ?? false),
                      Text(
                          dbController.listOfParametersResons.length.toString())
                    ])),
            Consumer<EnitityProfileDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Entity Profile', '12-12-2024', () {
                        dbController.storeEnitityProfile(context);
                      }, dbController.isDownloading ?? false),
                      Text(dbController.listOfEnitityProfiles.length.toString())
                    ])),
            Consumer<OfflineDb>(
                builder: (context, dbController, _) => Column(children: [
                      _buildTile('Entity Profile in Queue', '12-12-2024',
                          hideDevider: true, () {
                        dbController.getAllOFFlineDb();
                      }, dbController.isDownloading ?? false),
                      Text(dbController.listOfflineEntitites!.length.toString())
                    ])),
            const AppSpacer(
              heightPortion: .02,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
      String title, String date, void Function()? onPressed, bool loading,
      {bool? hideDevider}) {
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
              leading: SizedBox(
                width: w(context) * .35,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  title,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: AppDimensions.fontSize18(context),
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last updated',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.fontSize10(context),
                        color: AppColors.kWhite),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.fontSize18(context),
                        color: AppColors.kWhite),
                  ),
                ],
              ),
              trailing: loading
                  ? IconButton(
                      onPressed: () {},
                      icon: const SizedBox(
                        height: 5,
                        width: 5,
                        child: CircularProgressIndicator(
                          color: AppColors.kWhite,
                          strokeAlign: 2,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.download_for_offline,
                        color: AppColors.kWhite,
                      )),
            ),
          ),
        ),
        hideDevider == true
            ? const SizedBox()
            : const Divider(
                color: AppColors.kGrey,
                endIndent: 20,
                indent: 20,
                thickness: .2,
              )
      ],
    );
  }
}
