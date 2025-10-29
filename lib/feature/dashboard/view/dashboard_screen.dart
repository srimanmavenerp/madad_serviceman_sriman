// // import 'package:get/get.dart';
// // import 'package:demandium_serviceman/utils/core_export.dart';
// //
// // import '../../dashboard_bookings/dashboard_booking_details_screen.dart';
// //
// //
// // class DashBoardScreen extends StatefulWidget {
// //   const DashBoardScreen({super.key}) ;
// //   @override
// //   State<DashBoardScreen> createState() => _DashBoardScreenState();
// // }
// // class _DashBoardScreenState extends State<DashBoardScreen> {
// //
// //   void _loadData(){
// //     Get.find<DashboardController>().getDashboardData(reload: false);
// //     Get.find<UserController>().getUserInfo();
// //     Get.find<DashboardController>().changeToYearlyEarnStatisticsChart(EarningType.monthly);
// //     Get.find<DashboardController>().getMonthlyBookingsDataForChart(
// //       DateConverter.stringYear(DateTime.now()),DateTime.now().month.toString(),
// //       isRefresh: true
// //     );
// //     Get.find<DashboardController>().getYearlyBookingsDataForChart(
// //       DateConverter.stringYear(DateTime.now()),
// //       isRefresh: true
// //     );
// //     Get.find<NotificationController>().getNotifications(1,saveNotificationCount: false);
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Get.find<UserController>().getUserInfo();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar:  MainAppBar(
// //         color: Theme.of(context).primaryColor,
// //         title: AppConstants.appName,
// //         titleFontSize: Dimensions.fontSizeOverLarge,
// //       ),
// //       body: RefreshIndicator(
// //         backgroundColor: Theme.of(context).colorScheme.surface,
// //         color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.6),
// //         onRefresh: () async {
// //           _loadData();
// //         },
// //         child: SingleChildScrollView(
// //           physics: const ClampingScrollPhysics(
// //             parent: AlwaysScrollableScrollPhysics()
// //           ),
// //           child: GetBuilder<DashboardController>(
// //             builder: (dashboardController){
// //               return dashboardController.isLoading ?
// //               const DashboardTopCardShimmer() :
// //
// //               Column(
// //                 children:[
// //                   CrewDashboardScreen(),
// //                  // BusinessSummerySection(),
// //                  // BookingStatisticsSection(),
// //                  // RecentActivitySection(),
// //                   const SizedBox(height: Dimensions.paddingSizeDefault,)
// //                 ],
// //               );
// //             },
// //           ),
// //         ),
// //       )
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// import '../../dashboard_bookings/dashboard_booking_controller.dart';
// import '../widgets/business_summery_section.dart';
//
//
//
// class DashBoardScreen extends StatefulWidget {
//   const DashBoardScreen({super.key});
//
//   @override
//   State<DashBoardScreen> createState() => _DashBoardScreenState();
// }
//
// class _DashBoardScreenState extends State<DashBoardScreen> {
//   final CrewDashboardBookingController bookingController =
//   Get.put(CrewDashboardBookingController());
//
//   Timer? _autoRefreshTimer;
//   int _refreshCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Get.find<UserController>().getUserInfo();
//     bookingController.fetchBookings(); // initial fetch
//
//     // Start auto-refresh every 5 seconds, up to 3 times (15 seconds total)
//     _autoRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
//       if (_refreshCount >= 3) {
//         timer.cancel();
//       } else {
//         bookingController.fetchBookings(); // refresh call
//         _refreshCount++;
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _autoRefreshTimer?.cancel();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MainAppBar(
//         color: Theme.of(context).primaryColor,
//         // title: AppConstants.appName,
//         title: AppConstants.appName,
//
//         titleFontSize: Dimensions.fontSizeOverLarge,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BusinessSummerySection(),
//           SizedBox(height: 20,),
//           // Filter Buttons and Time Slot Dropdown
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Obx(() {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Status Filter Buttons
//                   Row(
//                     children: bookingController.statusFilters.map((status) {
//                       final isSelected = bookingController.selectedFilter.value == status;
//
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: TextButton.icon(
//                           icon: Icon(
//                             status == 'pending' ? Icons.hourglass_top : Icons.check_circle_outline,
//                             color: isSelected ? Colors.white : Colors.black,
//                             size: 18,
//                           ),
//                           label: Text(
//                             status.capitalize!,
//                             style: TextStyle(
//                               fontSize: Dimensions.fontSizeSmall,
//                               fontWeight: FontWeight.w500,
//                               color: isSelected ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           style: TextButton.styleFrom(
//                             backgroundColor: isSelected ? Colors.deepPurple : Colors.transparent,
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               side: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
//                             ),
//                           ),
//                           onPressed: () => bookingController.updateFilter(status),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//
//                   // Time Slot Dropdown
//                   Column(
//                     children: [
//                       Text(
//                         'Select Slot',
//                         style: robotoMedium.copyWith(fontSize:09),
//                       ),
//                      // const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           const Icon(Icons.schedule, size: 18, color: Colors.grey),
//                           const SizedBox(width: 8),
//                           DropdownButton<String>(
//                             value: bookingController.selectedTimeSlot.value,
//                             underline: const SizedBox(),
//                             icon: const Icon(Icons.arrow_drop_down),
//                             items: bookingController.timeSlots.map((slot) {
//                               return DropdownMenuItem(
//                                 value: slot,
//                                 child: Text(
//                                   slot,
//                                   style: TextStyle(
//                                     fontSize: 09,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (val) {
//                               if (val != null) {
//                                 bookingController.updateTimeSlot(val);
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             }),
//           ),
//
//           // Booking List
//           Expanded(
//             child: Obx(() {
//               if (bookingController.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final bookings = bookingController.filteredBookings;
//
//               if (bookings.isEmpty) {
//                 return const Center(child: Text('No bookings found.'));
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: bookings.length,
//                 itemBuilder: (context, index) {
//                   final booking = bookings[index];
//
//                   return GestureDetector(
//                     onTap: () {
//                       Get.to(
//                             () => BookingDetailsScreen(
//                           bookingId: booking.id,
//                           isSubBooking: false,
//                           fromPage: 'dashboard',
//                         ),
//                         binding: BookingDetailsBinding(),
//                       );
//                     },
//
//
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Theme.of(context).cardColor,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Vehicle No
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Vehicle No: ${booking.vehicle.vehicleNo}',
//                                   style: TextStyle(
//                                     fontSize: Dimensions.fontSizeLarge,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 8),
//
//                             // Vehicle Model + Amount Label
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Model: ${booking.vehicle.model}',
//                                   style: TextStyle(
//                                     fontSize: Dimensions.fontSizeSmall,
//                                     color: Theme.of(context).hintColor,
//                                   ),
//                                 ),
//                                 const Text(
//                                   'Total amount',
//                                   style: TextStyle(
//                                     color: Colors.orange,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 4),
//
//                             // Amount Value
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'OMR ${booking.totalBookingAmount.toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: Dimensions.fontSizeSmall,
//                                     color: Colors.orange,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox.shrink(),
//                               ],
//                             ),
//
//                             const SizedBox(height: 8),
//
//                             GestureDetector(
//                               onTap: () {},
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.purple[50],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.location_on, color: Colors.deepPurple, size: 16),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       'Customer Location',
//                                       style: TextStyle(color: Colors.black87),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

/////////////

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

import '../../dashboard_bookings/dashboard_booking_controller.dart';
import '../widgets/business_summery_section.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final CrewDashboardBookingController bookingController = Get.put(
    CrewDashboardBookingController(),
  );

  // final GlobalKey<RefreshIndicatorState> _refreshKey =
  // GlobalKey<RefreshIndicatorState>();
  ///
  ///import 'dart:io';Unified Update Checker (Android + iOS)

  Future<void> checkForAppUpdate(BuildContext context) async {
    if (Platform.isAndroid) {
      // ✅ ANDROID: Use Google Play In-App Update
      try {
        final info = await InAppUpdate.checkForUpdate();

        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          debugPrint("Android update available");

          if (info.immediateUpdateAllowed) {
            // Immediate update
            await InAppUpdate.performImmediateUpdate();
          } else if (info.flexibleUpdateAllowed) {
            // Flexible update (downloads in background)
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          } else {
            debugPrint(
              "Update available but not allowed (policy restriction).",
            );
          }
        } else {
          debugPrint("No Android update available.");
        }
      } catch (e) {
        debugPrint("Android in-app update failed: $e");
      }
    } else if (Platform.isIOS) {
      // 🍎 iOS: Use new_version_plus
      final newVersion = NewVersionPlus(
        iOSId: 'com.maven.madad.serviceman', // replace with your iOS bundle ID
        // androidId: 'com.yourcompany.yourapp',  // optional
      );

      try {
        final status = await newVersion.getVersionStatus();

        if (status != null && status.canUpdate) {
          debugPrint("iOS update available: ${status.storeVersion}");

          // Custom dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Update Available"),
              content: Text(
                "A new version (${status.storeVersion}) is available.\n"
                "You're currently on ${status.localVersion}.\n"
                "Please update to enjoy the latest features.",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Later"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await newVersion.launchAppStore(status.appStoreLink);
                  },
                  child: const Text("Update Now"),
                ),
              ],
            ),
          );
        } else {
          debugPrint("iOS app is up to date.");
        }
      } catch (e) {
        debugPrint("iOS version check failed: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Get.find<UserController>().getUserInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _refreshKey.currentState?.show(); // Automatically shows the pull-to-refresh
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForAppUpdate(context);
    });
  }

  Future<void> _onRefresh() async {
    await bookingController.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        color: Theme.of(context).primaryColor,
        title: AppConstants.appName,
        titleFontSize: Dimensions.fontSizeOverLarge,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BusinessSummerySection(),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Daily Car Wash",
              style: TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: bookingController.statusFilters.map((status) {
                      final isSelected =
                          bookingController.selectedFilter.value == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton.icon(
                          icon: Icon(
                            status == 'pending'
                                ? Icons.hourglass_top
                                : Icons.check_circle_outline,
                            color: isSelected ? Colors.white : Colors.black,
                            size: 18,
                          ),
                          label: Text(
                            status.capitalize!,
                            style: TextStyle(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.deepPurple
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                          onPressed: () =>
                              bookingController.updateFilter(status),
                        ),
                      );
                    }).toList(),
                  ),
                  Column(
                    children: [
                      Text(
                        'Select Slot',
                        style: robotoMedium.copyWith(fontSize: 9),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: bookingController.selectedTimeSlot.value,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: bookingController.timeSlots.map((slot) {
                              return DropdownMenuItem(
                                value: slot,
                                child: Text(
                                  slot,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                bookingController.updateTimeSlot(val);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                // key: _refreshKey,
                onRefresh: _onRefresh,
                child: bookingController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : bookingController.filteredBookings.isEmpty
                    ? const Center(child: Text('No bookings found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: bookingController.filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking =
                              bookingController.filteredBookings[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => BookingDetailsScreen(
                                  bookingId: booking.id,
                                  isSubBooking: false,
                                  fromPage: 'dashboard',
                                ),
                                binding: BookingDetailsBinding(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Vehicle No: ${booking.vehicle.vehicleNo}',
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Model: ${booking.vehicle.model}',
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        const Text(
                                          'Total amount',
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'OMR ${booking.totalBookingAmount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox.shrink(),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.deepPurple,
                                              size: 16,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Customer Location',
                                              style: TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
