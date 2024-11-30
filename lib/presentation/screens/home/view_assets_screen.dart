import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/core/components/app_margin.dart';
import 'package:test_managment/core/components/app_page_head_text.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/controller/sync_controller.dart';
import 'package:test_managment/core/services/api_service.dart';
import 'package:test_managment/core/services/network_service.dart';
import 'package:test_managment/core/utils/app_colors.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';
import 'package:test_managment/model/test_report_model.dart';
import 'package:test_managment/presentation/screens/home/widgets/app_drawer.dart';
import 'package:test_managment/presentation/screens/home/widgets/home_app_bar.dart';
import 'package:test_managment/presentation/screens/home/widgets/tab_offlin_test_views.dart';
import 'package:test_managment/presentation/screens/home/widgets/tab_offline_add_asset.dart';
import 'package:test_managment/presentation/screens/home/widgets/tab_online_test_view.dart';

class ViewAssetsScreen extends StatelessWidget {
  const ViewAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncController>(builder: (context, controller, _) {
      return PopScope(
        canPop: !controller.isSyncing,
        child: Scaffold(
            drawer: const HomeDrawer(),
            appBar: AppBar(
              leadingWidth: 70,
              // leading: Builder(builder: (context) {
              //   return Consumer<NetworkService>(builder: (context, net, _) {
              //     return Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           net.netisConnected == true ? "ONLINE" : "OFFLINE",
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     );
              //   });
              // }),
              leading: controller.isSyncing
                  ? const Icon(Icons.menu)
                  : const DrawerButton(
                      color: AppColors.kBlack,
                    ),
              centerTitle: true,
              title: AppPageHeadText(title: 'viewTestAsset'.tr()),
            ),
            body: Stack(
              children: [
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: AppDimensions.fontSize12(context)),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.fontSize13(context)),
                          tabs: [
                            Tab(
                              text: 'onlineData'.tr(),
                            ),
                            Tab(
                              text: 'offlineData'.tr(),
                            ),
                            Tab(
                              text: 'offlineAddAsset'.tr(),
                            ),
                          ]),
                      const Expanded(
                          child: TabBarView(children: [
                        TabOnlineTestView(),
                        TabOfflinTestViews(),
                        TabOfflineAddAsset()
                      ]))
                    ],
                  ),
                ),
                controller.isSyncing
                    ? Container(
                        alignment: Alignment.center,
                        width: w(context),
                        color: AppColors.kBlack.withOpacity(.5),
                        child: Container(
                          margin:
                              const EdgeInsets.all(AppDimensions.paddingSize25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingSize20),
                          width: w(context),
                          height: h(context) * .1,
                          color: AppColors.kWhite,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const AppLoadingIndicator(),
                              const AppSpacer(
                                widthPortion: .05,
                              ),
                              Text(
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                'Please wait while syncing completes.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        AppDimensions.fontSize16(context)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            )),
      );
    });
  }
}
