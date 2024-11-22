// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test_managment/core/components/app_spacer.dart';
// import 'package:test_managment/core/components/common_widgets.dart';
// import 'package:test_managment/core/services/local_service.dart';
// import 'package:test_managment/core/utils/app_colors.dart';
// import 'package:test_managment/core/utils/app_dimentions.dart';
// import 'package:test_managment/core/utils/responsive_helper.dart';
// import 'package:test_managment/core/utils/route.dart';
// import 'package:test_managment/presentation/screens/dashboard.dart';
// import 'package:test_managment/presentation/screens/home/download_data.dart';

// class FirstTimeDownloadingScreen extends StatefulWidget {
//   const FirstTimeDownloadingScreen({super.key});

//   @override
//   State<FirstTimeDownloadingScreen> createState() =>
//       _FirstTimeDownloadingScreenState();
// }

// class _FirstTimeDownloadingScreenState
//     extends State<FirstTimeDownloadingScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future getData() async {
//     await Provider.of<LocalDatabaseService>(context, listen: false)
//         .dowloadAllData(context, dontListen: true)
//         .then((value) {
//       Navigator.of(context).pushAndRemoveUntil(
//         AppRoutes.createRoute(DashboardScreen()),
//         (route) => false,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       body: Stack(
//         children: [
//           const DownloadDataScreen(),
//           Container(
//             color: const Color.fromARGB(95, 238, 238, 238),
//             width: w(context),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   // height: ,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: AppDimensions.paddingSize10,
//                       vertical: AppDimensions.paddingSize20),
//                   color: AppColors.kWhite,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const AppLoadingIndicator(),
//                       AppSpacer(
//                         widthPortion: .02,
//                       ),
//                       Text(
//                         'Please wait until downloading finish',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: AppDimensions.fontSize18(context)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
