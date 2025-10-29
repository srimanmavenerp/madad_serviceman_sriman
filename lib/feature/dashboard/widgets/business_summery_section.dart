// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:http/http.dart' as http;
//
// class BusinessSummerySection extends StatelessWidget {
//   const BusinessSummerySection({super.key});
//
//   Future<void> _refreshDashboard(DashboardController controller) async {
//     await controller.getDashboardData();  // Your method to fetch data
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DashboardController>(
//       builder: (controller) {
//         if (controller.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return RefreshIndicator(
//           onRefresh: () => _refreshDashboard(controller),
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(), // needed for RefreshIndicator
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeDefault,
//                     vertical: Dimensions.paddingSizeSmall,
//                   ),
//                   child: Text(
//                     "bookings_summary".tr,
//                     style: robotoMedium.copyWith(
//                       fontSize: Dimensions.fontSizeLarge,
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: Dimensions.paddingSizeDefault,
//                     vertical: Dimensions.paddingSizeSmall,
//                   ),
//                   width: MediaQuery.of(context).size.width,
//                   height: 260,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor.withOpacity(Get.isDarkMode ? 0.5 : 1),
//                     boxShadow: Get.find<ThemeController>().darkTheme ? null : shadow,
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           BusinessSummaryItem(
//                             height: 85,
//                             curveColor: const Color(0xff7180ff),
//                             cardColor: const Color(0xff6a79ff),
//                             amount: controller.cards.pendingBookings ?? 0,
//                             title: "total_assigned_booking".tr,
//                             iconData: Images.earning,
//                           ),
//                           const SizedBox(width: Dimensions.paddingSizeSmall),
//                           BusinessSummaryItem(
//                             height: 85,
//                             cardColor: const Color(0xff3376E0),
//                             curveColor: const Color(0xff367ae3),
//                             amount: controller.cards.ongoingBookings ?? 0,
//                             title: "ongoing_booking".tr,
//                             iconData: Images.service,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//                       BusinessSummaryItem(
//                         cardColor: Theme.of(context).colorScheme.surfaceTint,
//                         amount: controller.cards.completedBookings ?? 0,
//                         title: "total_completed_booking".tr,
//                         iconData: Images.serviceMan,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//                       BusinessSummaryItem(
//                         cardColor: Theme.of(context).colorScheme.tertiary,
//                         amount: controller.cards.canceledBookings ?? 0,
//                         title: "total_canceled_booking".tr,
//                         iconData: Images.booking,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//



import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:flutter/material.dart';

class BusinessSummerySection extends StatefulWidget {
  const BusinessSummerySection({super.key});

  @override
  State<BusinessSummerySection> createState() => _BusinessSummerySectionState();
}

class _BusinessSummerySectionState extends State<BusinessSummerySection> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState?.show(); // Auto pull on first build
    });
  }

  Future<void> _refreshDashboard(DashboardController controller) async {
    await controller.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: () => _refreshDashboard(controller),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  child: Text(
                    "bookings_summary".tr,
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor
                        .withOpacity(Get.isDarkMode ? 0.5 : 1),
                    boxShadow:
                    Get.find<ThemeController>().darkTheme ? null : shadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BusinessSummaryItem(
                            height: 85,
                            curveColor: const Color(0xff7180ff),
                            cardColor: const Color(0xff6a79ff),
                            amount: controller.cards.pendingBookings ?? 0,
                            title: "total_assigned_booking".tr,
                            iconData: Images.earning,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          BusinessSummaryItem(
                            height: 85,
                            cardColor: const Color(0xff3376E0),
                            curveColor: const Color(0xff367ae3),
                            amount: controller.cards.ongoingBookings ?? 0,
                            title: "ongoing_booking".tr,
                            iconData: Images.service,
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      BusinessSummaryItem(
                        cardColor: Theme.of(context).colorScheme.surfaceTint,
                        amount: controller.cards.completedBookings ?? 0,
                        title: "total_completed_booking".tr,
                        iconData: Images.serviceMan,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      BusinessSummaryItem(
                        cardColor: Theme.of(context).colorScheme.tertiary,
                        amount: controller.cards.canceledBookings ?? 0,
                        title: "total_canceled_booking".tr,
                        iconData: Images.booking,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
