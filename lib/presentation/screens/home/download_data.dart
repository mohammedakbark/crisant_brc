import 'package:flutter/material.dart';
import 'package:test_managment/presentation/components/app_margin.dart';
import 'package:test_managment/presentation/components/app_spacer.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/responsive_helper.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
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
            _buildTile('Entities', '12-12-2024'),
            _buildTile('Section Incharge', '12-12-2024'),
            _buildTile('Section', '12-12-2024'),
            _buildTile(
              'Block Section',
              '12-12-2024',
            ),
            _buildTile('Station', '12-12-2024'),
            _buildTile('Parameters', '12-12-2024'),
            _buildTile('Parameters Value', '12-12-2024'),
            _buildTile('Parameters Reason', '12-12-2024'),
            _buildTile('Entity Profile', '12-12-2024', hideDevider: true),
            AppSpacer(
              heightPortion: .02,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String date, {bool? hideDevider}) {
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
              trailing: IconButton(
                  onPressed: () {},
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
