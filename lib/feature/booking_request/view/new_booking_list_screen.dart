import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../api/api_client.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/styles.dart';
import '../../booking_details/bindings/booking_bindings.dart';
import '../../booking_details/view/booking_details_screen.dart';
import '../../dashboard/widgets/main_app_bar.dart';
import '../model/new_booking_list_model.dart';
import '../widgets/booking_list_menu.dart';
import '../widgets/booking_request_item_card.dart';
import '../widgets/service_request_menu.dart';

enum BooingListStatus { pending, completed }

class BookingService {
  final ApiClient apiClient;
  static const String _baseUrl = 'https://madadservices.com/api/v1/serviceman/booking/list';

  BookingService({required this.apiClient});

  Future<BookingResponse> fetchBookings({
    int limit = 100,
    int offset = 1,
    String? bookingStatus,
    String? slot,
    String? serviceId,
    String? fromDate,
    String? toDate,
    required String token,
  }) async {
    final queryParams = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      'service_type': 'all',
    };

    if (bookingStatus != null && bookingStatus != 'all') {
      queryParams['booking_status'] = bookingStatus;
    }
    if (slot != null && slot != 'all') {
      queryParams['slot'] = slot;
    }
    if (serviceId != null && serviceId != 'all') {
      queryParams['service_id'] = serviceId;
    }
    if (fromDate != null) {
      queryParams['from_date'] = fromDate;
    }
    if (toDate != null) {
      queryParams['to_date'] = toDate;
    }
    debugPrint('BookingService - serviceId: $serviceId');

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    // Print token before calling the API
    debugPrint(" BookingService Token: ${apiClient.token}");

    final headers = {
      'Authorization': 'Bearer ${apiClient.token}',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(uri, headers: headers);

      debugPrint('====> Booking API Response: ${response.body}');
      debugPrint('API urllllllllll: $uri');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map<String, dynamic>) {
          return BookingResponse.fromJson(jsonData);
        } else {
          throw Exception('Unexpected response format: $jsonData');
        }
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error in fetchBookings: $e');
      throw Exception('Error fetching bookings: $e');
    }
  }
}

class BookingController with ChangeNotifier {
  final BookingService _bookingService = BookingService(apiClient: Get.find<ApiClient>());
  BookingResponse? bookingResponse;
  bool isLoading = false;
  String? errorMessage;

  // Filters
  List<String> timeSlots = ['all', '5am to 9am', '5pm to 10pm'];
  List<String> serviceTypes = ['all']; // Will be populated dynamically

  BooingListStatus _selectedStatus = BooingListStatus.pending;
  String _selectedTimeSlot = 'all';
  String _selectedServiceType = 'all';
  DateTime? _selectedDate;

  BooingListStatus get selectedStatus => _selectedStatus;
  String get selectedTimeSlot => _selectedTimeSlot;
  String get selectedServiceType => _selectedServiceType;
  DateTime? get selectedDate => _selectedDate;

  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  String get formattedFromDate => _fromDate != null
      ? DateFormat('yyyy-MM-dd').format(_fromDate!)
      : '';

  String get formattedToDate => _toDate != null
      ? DateFormat('yyyy-MM-dd').format(_toDate!)
      : '';

  void updateFromDate(DateTime? date) {
    _fromDate = date;
    notifyListeners();
  }

  void updateToDate(DateTime? date) {
    _toDate = date;
    notifyListeners();
  }

  void clearDates() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  void updateBookingStatusState(BooingListStatus status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void updateTimeSlotFilter(String slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  void updateServiceTypeFilter(String type) {
    _selectedServiceType = type;
    notifyListeners();
  }

  void updateSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Method to populate service types f
  void _populateServiceTypes() {
    Set<String> uniqueServiceNames = {'all'};


    if (bookingResponse?.content?.services != null) {
      for (var service in bookingResponse!.content!.services!) {
        if (service.name != null && service.name!.isNotEmpty) {
          uniqueServiceNames.add(service.name!);
        }
      }
    }

    // Method 2: Alternative
    if (uniqueServiceNames.length == 1 && bookingResponse?.content?.bookings?.data != null) {
      for (var booking in bookingResponse!.content!.bookings!.data) {
        if (booking.Service?.name != null && booking.Service!.name!.isNotEmpty) {
          uniqueServiceNames.add(booking.Service!.name!);
        }
      }
    }

    serviceTypes = uniqueServiceNames.toList();

    if (!serviceTypes.contains(_selectedServiceType)) {
      _selectedServiceType = 'all';
    }

    debugPrint('Updated serviceTypes: $serviceTypes');
  }

  void _populateServiceTypesFromBothSources() {
    Set<String> uniqueServiceNames = {'all'};

    // Get services from the main services array
    if (bookingResponse?.content?.services != null) {
      for (var service in bookingResponse!.content!.services!) {
        if (service.name != null && service.name!.isNotEmpty) {
          uniqueServiceNames.add(service.name!);
        }
      }
    }

    if (bookingResponse?.content?.bookings?.data != null) {
      for (var booking in bookingResponse!.content!.bookings!.data) {
        if (booking.Service?.name != null && booking.Service!.name!.isNotEmpty) {
          uniqueServiceNames.add(booking.Service!.name!);
        }
      }
    }

    serviceTypes = uniqueServiceNames.toList();

    if (!serviceTypes.contains(_selectedServiceType)) {
      _selectedServiceType = 'all';
    }

    debugPrint('Updated serviceTypes from both sources: $serviceTypes');
  }


  Future<void> fetchBookings({required String token}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final originalResponse = await _bookingService.fetchBookings(
        token: token,
        bookingStatus: _selectedStatus.name,
        slot: _selectedTimeSlot != 'all' ? _selectedTimeSlot : '',
        fromDate: _fromDate != null ? formattedFromDate : null,
        toDate: _toDate != null ? formattedToDate : null,
      );

      bookingResponse = originalResponse;

      _populateServiceTypes();

      if (_selectedServiceType != 'all' && bookingResponse?.content?.bookings?.data != null) {
        final filteredBookings = bookingResponse!.content!.bookings!.data
            .where((booking) =>
        booking.Service?.name == _selectedServiceType)
            .toList();

        final filteredPagination = BookingPagination(
          currentPage: bookingResponse!.content!.bookings!.currentPage,
          data: filteredBookings,
          lastPage: bookingResponse!.content!.bookings!.lastPage,
          total: filteredBookings.length,
          perPage: bookingResponse!.content!.bookings!.perPage,
        );

        final filteredContent = Content(
          bookings: filteredPagination,
        );

        bookingResponse = BookingResponse(
          responseCode: bookingResponse!.responseCode,
          message: bookingResponse!.message,
          content: filteredContent,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Error fetching bookings: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class BookingScreen extends StatefulWidget {
  final String token;

  const BookingScreen({Key? key, required this.token}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late BookingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BookingController();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    await _controller.fetchBookings(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MainAppBar(
        title: 'booking_requests'.tr,
        color: Theme.of(context).primaryColor,
      ),
      body: ChangeNotifierProvider<BookingController>.value(
        value: _controller,
        child: Consumer<BookingController>(
          builder: (context, controller, child) {
            final bookings = controller.bookingResponse?.content?.bookings?.data ?? [];

            return RefreshIndicator(
              onRefresh: _loadBookings,
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _BookingListMenuDelegate(
                      controller: controller,
                      token: widget.token,
                    ),
                  ),
                  if (controller.isLoading)
                    SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.errorMessage != null)
                    SliverFillRemaining(
                      child: ErrorWidget(controller.errorMessage!),
                    )
                  else if (bookings.isEmpty)
                      SliverFillRemaining(
                        child: Center(child: Text('no_bookings_found'.tr)),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final booking = bookings[index];
                            return BookingCard(
                              booking: booking,
                              bookingId: booking.id ?? '',
                            );
                          },
                          childCount: bookings.length,
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String error;

  const ErrorWidget(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<BookingController>().fetchBookings(
                    token: context.findAncestorStateOfType<_BookingScreenState>()?.widget.token ?? '');
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingListMenuDelegate extends SliverPersistentHeaderDelegate {
  final BookingController controller;
  final String token;

  _BookingListMenuDelegate({
    required this.controller,
    required this.token,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final controller = Provider.of<BookingController>(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: Dimensions.paddingSizeSmall,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              height: 36,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: BooingListStatus.values.length,
                itemBuilder: (context, index) {
                  final status = BooingListStatus.values[index];
                  return InkWell(
                    onTap: () {
                      controller.updateBookingStatusState(status);
                      controller.fetchBookings(token: token);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: BookingMenuItem(
                        title: status.name.toLowerCase().tr,
                        isSelected: controller.selectedStatus == status,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 2),
            // Time slot dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Time Slot',
                  style: TextStyle(
                    fontSize: 10,
                    color:Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: _dropdownDecoration(context),
                  child: DropdownButton<String>(
                    value: controller.selectedTimeSlot,
                    items: controller.timeSlots.map((slot) {
                      return DropdownMenuItem<String>(
                        value: slot,
                        child: Text(
                          slot,
                          style: robotoRegular.copyWith(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateTimeSlotFilter(value);
                        controller.fetchBookings(token: token);
                      }
                    },
                    underline: const SizedBox(),
                    style: robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),
            // Service type dropdown - Now dynamic based on subcategory names
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Service Type',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  height: 38,
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: _dropdownDecoration(context),
                  child: DropdownButton<String>(
                    value: controller.selectedServiceType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    items: controller.serviceTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateServiceTypeFilter(value);
                        controller.fetchBookings(token: token);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),
            // Date Picker Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'From Date',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: _dateButtonDecoration(context),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: controller.fromDate != null
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).hintColor,
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.fromDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.updateFromDate(picked);
                            controller.fetchBookings(token: token);
                          }
                        },
                      ),
                    ),
                    Text(
                      controller.fromDate != null
                          ? DateFormat('MMM dd').format(controller.fromDate!)
                          : '',
                      style: TextStyle(
                        fontSize: 12,
                        color: controller.fromDate != null
                            ? Theme.of(context).textTheme.bodyLarge!.color
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),


            // const SizedBox(width: 8),
            // const Text('-'),
            const SizedBox(width: 8),

            // To Date Picker Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'To Date',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: _dateButtonDecoration(context),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: controller.toDate != null
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).hintColor,
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: controller.toDate ?? (controller.fromDate ?? DateTime.now()),
                            firstDate: controller.fromDate ?? DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.updateToDate(picked);
                            controller.fetchBookings(token: token);
                          }
                        },
                      ),
                    ),
                    // Text(
                    //   controller.toDate != null
                    //       ? DateFormat('MMM dd').format(controller.toDate!)
                    //       : '',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: controller.toDate != null
                    //         ? Theme.of(context).textTheme.bodyLarge!.color
                    //         : Theme.of(context).hintColor,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            Text(
              controller.toDate != null
                  ? DateFormat('MMM dd').format(controller.toDate!)
                  : '',
              style: TextStyle(
                fontSize: 12,
                color: controller.toDate != null
                    ? Theme.of(context).textTheme.bodyLarge!.color
                    : Theme.of(context).hintColor,
              ),
            ),

            // Clear dates button
            if (controller.fromDate != null || controller.toDate != null)
              IconButton(
                icon: Icon(Icons.clear, size: 20),
                onPressed: () {
                  controller.clearDates();
                  controller.fetchBookings(token: token);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  double get minExtent => 100;

  @override
  double get maxExtent => 100;



  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

  BoxDecoration _dropdownDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(
        color: Theme.of(context).hintColor.withOpacity(0.1),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  BoxDecoration _dateButtonDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(
        color: Theme.of(context).hintColor.withOpacity(0.1),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

class BookingMenuItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const BookingMenuItem({
    Key? key,
    required this.title,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).hintColor.withOpacity(0.2),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}



// Booking Card Widget


class BookingCard extends StatelessWidget {
  final Booking booking;
  const BookingCard({Key? key, required this.booking, required String bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    String scheduleText = 'N/A';
    try {
      if (booking.serviceSchedule != null) {
        final schedule = DateTime.parse(booking.serviceSchedule!);
        scheduleText = dateFormat.format(schedule);
      }
    } catch (_) {
      scheduleText = 'Invalid date';
    }

    return GestureDetector(
        onTap: () {
          Get.to(
                () => BookingDetailsScreen(
              bookingId: booking.id ?? '',
              isSubBooking: false,
              fromPage: 'dashboard',
            ),
            binding: BookingDetailsBinding(),
          );
        },

      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: Get.isDarkMode ? null : [BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Booking #${booking.readableId ?? ''}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // if (booking.isRepeatBooking == 1) ...[
                      //   const SizedBox(width: 6),
                      //   const Icon(Icons.repeat, size: 14, color: Colors.green),
                      // ],
                      // const Spacer(),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(50),
                      //     color: _getStatusColor(booking.bookingStatus),
                      //   ),
                      //   child: Text(
                      //     booking.bookingStatus?.tr ?? '',
                      //     style: const TextStyle(
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    booking.Service?.name ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                  const Divider(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // _infoRow('Booking Date:', dateFormat.format(booking.createdAt!)),
                            const SizedBox(height: 4),
                            _infoRow('Schedule:', scheduleText),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Amount',
                            style: TextStyle(fontSize: 14, color: Theme.of(context).secondaryHeaderColor),
                          ),
                          Text(
                            'ORM ${booking.totalBookingAmount?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          )

                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            (booking.serviceLocation == "provider")
                                ? "Provider Location"
                                : "Customer Location",
                            style: const TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (booking.vehicle != null)
                    Text(
                      'Vehicle: ${booking.vehicle!.brand ?? ''} ${booking.vehicle!.model ?? ''} (${booking.vehicle!.vehicleNo ?? ''})',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),

                  if (booking.serviceAddressLocation?.address != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Address: ${booking.serviceAddressLocation!.address!}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  /// View Details Button
                  ///
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     // onPressed: () {
                  //     //   Get.toNamed('/booking-details/${booking.id}');
                  //     // },
                  //     child: const Text('View Details'),
                  //   ),
                  // )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  /// Color helper based on status
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}







