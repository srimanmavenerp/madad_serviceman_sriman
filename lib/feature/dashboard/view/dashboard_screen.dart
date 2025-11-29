import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

import '../../dashboard_bookings/dashboard_booking_controller.dart';
import '../widgets/business_summery_section.dart';

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

  @override
  void initState() {
    super.initState();

    Get.find<UserController>().getUserInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _refreshKey.currentState?.show(); // Automatically shows the pull-to-refresh
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
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
              Obx(() {
                return bookingController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : bookingController.filteredBookings.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: const Center(child: Text('No bookings found.')),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                      );
              }),
              SizedBox(height: 20),
              BusinessSummerySection(),
            ],
          ),
        ),
      ),
    );
  }
}
