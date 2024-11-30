import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_managment/core/alert_message.dart';
import 'package:test_managment/core/components/app_spacer.dart';
import 'package:test_managment/core/components/common_widgets.dart';
import 'package:test_managment/core/components/custom_button.dart';
import 'package:test_managment/core/utils/app_dimentions.dart';

class SyncController with ChangeNotifier {
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  syncDataLoadingState() async {
    _isSyncing = true;
    notifyListeners();
    // notifyListeners();
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) {
    //     return PopScope(
    //       canPop: false,
    //       child: AlertDialog(
    //         titlePadding: const EdgeInsets.symmetric(
    //             horizontal: AppDimensions.paddingSize20,
    //             vertical: AppDimensions.paddingSize20),
    //         shape: const BeveledRectangleBorder(),
    //         title: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             const AppLoadingIndicator(),
    //             const AppSpacer(
    //               widthPortion: .05,
    //             ),
    //             Text(
    //               maxLines: 3,
    //               overflow: TextOverflow.ellipsis,
    //               'Please wait while syncing completes.',
    //               style: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: AppDimensions.fontSize16(context)),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  closeSync() {
    _isSyncing = false;
    notifyListeners();
  }

 static String converDataTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }
}
