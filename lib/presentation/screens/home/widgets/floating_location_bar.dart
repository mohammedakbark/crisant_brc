import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_managment/controller/floating_bar_controller.dart';
import 'package:test_managment/controller/location_provider.dart';
import 'package:test_managment/presentation/components/app_spacer.dart';
import 'package:test_managment/utils/app_colors.dart';
import 'package:test_managment/utils/app_dimentions.dart';
import 'package:test_managment/utils/responsive_helper.dart';

class FloatingDirectionBar extends StatefulWidget {
  const FloatingDirectionBar({super.key});

  @override
  State<FloatingDirectionBar> createState() => _FloatingDirectionBarState();
}

class _FloatingDirectionBarState extends State<FloatingDirectionBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FloatingBarController>(
        builder: (context, floatingController, _) {
      return Positioned(
        top: floatingController.top,
        left: floatingController.left,
        child: GestureDetector(
          onPanUpdate: (details) =>
              floatingController.onPanUpdate(details, context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: floatingController.isMinimized ? 60 : null,
            height: floatingController.isMinimized ? 60 : null,
            decoration: BoxDecoration(
              color: Provider.of<LocationProvider>(context).isNearTarget
                  ? AppColors.kPrimaryColor
                  : AppColors.kRed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSize10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                ),
              ],
            ),
            child: floatingController.isMinimized
                ? IconButton(
                    icon: const Icon(Icons.open_in_full, color: Colors.white),
                    onPressed: floatingController.minimizeBar)
                : Consumer<LocationProvider>(builder: (context, controller, _) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: w(context) * .6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingSize10),
                              child: Stack(
                                children: [
                                  const Text("Destination",
                                      style: TextStyle(color: Colors.white)),
                                  Positioned(
                                    right: 0,
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap:
                                                floatingController.minimizeBar,
                                            child: const Icon(Icons.minimize,
                                                color: Colors.white)),
                                        const AppSpacer(
                                          widthPortion: .04,
                                        ),
                                        InkWell(
                                          child: const Icon(Icons.close,
                                              color: Colors.white),
                                          onTap: () {
                                            controller.showFlaotingLocation(
                                                false,
                                                targetLat: null,
                                                targetLon: null);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                                AppDimensions.paddingSize10),
                            margin: const EdgeInsets.only(
                                left: 3, right: 3, bottom: 3),
                            decoration: BoxDecoration(
                                color: controller.isNearTarget
                                    ? AppColors.kBgColor
                                    : AppColors.kBgColor2,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        AppDimensions.radiusSize10),
                                    bottomRight: Radius.circular(
                                        AppDimensions.radiusSize10))),
                            child: controller.isNearTarget
                                ? _buildDestinationReachedUI(controller)
                                : _buildNavigationUI(controller),
                          )
                        ],
                      ),
                    );
                  }),
          ),
        ),
      );
    });
  }

  Widget _buildNavigationUI(LocationProvider controller) {
    return Column(
      children: [
        Text(
          controller.getDirectionGuidance(),
          style: TextStyle(
              fontSize: AppDimensions.fontSize18(context),
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const AppSpacer(
          heightPortion: .01,
        ),
        RichText(
          text: TextSpan(
              text: 'Distance:',
              style: TextStyle(
                  fontSize: AppDimensions.fontSize15(
                    context,
                  ),
                  color: AppColors.kBlack),
              children: [
                TextSpan(
                  text:
                      ' ${(controller.distance / 1000).toStringAsFixed(3)} Km',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.fontSize15(
                        context,
                      ),
                      color: AppColors.kBlack),
                )
              ]),
        ),
        const AppSpacer(
          heightPortion: .01,
        ),
        if (controller.isLocationEnabled) ...[
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: AppColors.kGrey,
              ),
              const AppSpacer(
                widthPortion: .01,
              ),
              Text(
                'Lat: ${controller.currentLat.toStringAsFixed(3)} Lon: ${controller.currentLon.toStringAsFixed(3)}',
                style: TextStyle(
                    fontSize: AppDimensions.fontSize15(context),
                    color: AppColors.kGrey),
              ),
            ],
          )
        ],
      ],
    );
  }

  Widget _buildDestinationReachedUI(LocationProvider controller) {
    return Column(
      children: [
        const Icon(
          Icons.location_on,
          size: 50,
          color: Colors.green,
        ),
        const AppSpacer(
          heightPortion: .01,
        ),
        Text(
          'You have reached your destination!',
          style: TextStyle(
            fontSize: AppDimensions.fontSize16(context),
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const AppSpacer(
          heightPortion: .03,
        ),
        RichText(
            text: TextSpan(
                text: 'You are ',
                style: const TextStyle(color: AppColors.kBlack),
                children: [
              TextSpan(
                text: '${(controller.distance / 1000).toStringAsFixed(3)} Km',
                style: const TextStyle(
                    color: AppColors.kBlack, fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' from the target')
            ]))
        // Text(
        //   'You are ${(controller.distance / 1000).toStringAsFixed(4)} Km from the target',
        //   style: TextStyle(fontSize: AppDimensions.fontSize13(context)),
        // ),
      ],
    );
  }
}
