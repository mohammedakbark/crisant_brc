
import 'package:flutter/material.dart';
import 'package:test_managment/core/utils/responsive_helper.dart';

class AppEmptyText extends StatelessWidget {
  final String text;
  const AppEmptyText({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Text(
              text,
              style: const TextStyle(),
            ),
          );
  }
}

// class AppImageNotFoundText extends StatelessWidget {
//   const AppImageNotFoundText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       '(Image Not Found)',
//       textAlign: TextAlign.center,
//       style: AppStyle.inter(
//           color: AppColor.kGrey,
//           size: AppDimensions.fontSize10(context),
//           context: context),
//     );
//   }
// }
