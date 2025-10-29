// // import 'package:flutter/material.dart';
// //
// // import '../model/new_booking_list_model.dart';
// // import '../repository/new_booking_list_repo.dart';
// //
// //
// // class BookingController with ChangeNotifier {
// //   final BookingService _bookingService = BookingService();
// //   BookingResponse? bookingResponse;
// //   bool isLoading = false;
// //   String? errorMessage;
// //
// //   List<String> bookingRequestList = ["accepted", "ongoing"];
// //
// //   List<String> bookingStatues = ["pending", "completed"];
// //
// //
// //   // Filters
// //   List<String> timeSlots = ['all', '5am to 10pm', '5pm to 10pm'];
// //   List<String> serviceTypes = ['all', 'On Demand', 'Car Maintenance', 'Daily Car Wash'];
// //
// //   String selectedTimeSlot = 'all';
// //   String selectedServiceType = 'all';
// //   String selectedStatus = 'All';
// //
// //
// //   Future<void> fetchBookings({
// //     required String token,
// //     int limit = 100,
// //     int offset = 1,
// //     String bookingStatus = 'pending',
// //     String slot = '5am to 9am',
// //     String serviceId = '10646e61-1a40-4b4f-a388-2ae804e2e301',
// //     String fromDate = '01-07-2025',
// //     String toDate = '01-07-2025',
// //   }) async {
// //     isLoading = true;
// //     errorMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       bookingResponse = await _bookingService.fetchBookings(
// //         token: token,
// //         limit: limit,
// //         offset: offset,
// //         bookingStatus: bookingStatus,
// //         slot: slot,
// //         serviceId: serviceId,
// //         fromDate: fromDate,
// //         toDate: toDate,
// //       );
// //     } catch (e) {
// //       errorMessage = e.toString();
// //     } finally {
// //       isLoading = false;
// //       notifyListeners();
// //     }
// //   }
// // }
//
//
// ///////////
//
//
// import 'package:get/get.dart';
// import '../model/new_booking_list_model.dart';
// import '../repository/new_booking_list_repo.dart';
//
// // class BookingController extends GetxController {
// //   final BookingService _bookingService = BookingService();
// //   BookingResponse? bookingResponse;
// //   var isLoading = false.obs;
// //   String? errorMessage;
// //
// //   // Booking Request List and Booking Statuses
// //   List<String> bookingRequestList = ["accepted", "ongoing"];
// //   List<String> bookingStatuses = ["pending", "completed", "all"];
// //
// //   // Filters
// //   List<String> timeSlots = ['all', '5am to 10pm', '5pm to 10pm', '5am to 9am'];
// //   List<String> serviceTypes = ['all', 'On Demand', 'Car Maintenance', 'Daily Car Wash'];
// //
// //   // Selected Filters
// //   var selectedTimeSlot = 'all'.obs;
// //   var selectedServiceType = 'all'.obs;
// //   var selectedStatus = 'all'.obs;
// //
// //   // Method to update selected time slot
// //   void updateTimeSlotFilter(String timeSlot) {
// //     selectedTimeSlot.value = timeSlot;
// //   }
// //
// //   // Method to update selected service type
// //   void updateServiceTypeFilter(String serviceType) {
// //     selectedServiceType.value = serviceType;
// //   }
// //
// //   // Method to update selected booking status
// //   void updateBookingStatusState(String status) {
// //     selectedStatus.value = status;
// //   }
// //
// //   // Fetch bookings with filters
// //   Future<void> fetchBookings({
// //     required String token,
// //     int limit = 100,
// //     int offset = 1,
// //     String? bookingStatus,
// //     String? slot,
// //     String? serviceId,
// //     String? fromDate,
// //     String? toDate,
// //   }) async {
// //     isLoading.value = true;
// //     errorMessage = null;
// //     update();
// //
// //     // Set default values if no filter is selected
// //     bookingStatus ??= selectedStatus.value;
// //     slot ??= selectedTimeSlot.value;
// //     serviceId ??= '10646e61-1a40-4b4f-a388-2ae804e2e301';
// //     fromDate ??= '01-07-2025';
// //     toDate ??= '01-07-2025';
// //
// //     try {
// //       // Log the parameters for debugging
// //       print("Fetching bookings with params: ");
// //       print({
// //         'token': token,
// //         'limit': limit,
// //         'offset': offset,
// //         'bookingStatus': bookingStatus,
// //         'slot': slot,
// //         'serviceId': serviceId,
// //         'fromDate': fromDate,
// //         'toDate': toDate,
// //       });
// //
// //       bookingResponse = await _bookingService.fetchBookings(
// //         token: token,
// //         limit: limit,
// //         offset: offset,
// //         bookingStatus: bookingStatus,
// //         slot: slot,
// //         serviceId: serviceId,
// //         fromDate: fromDate,
// //         toDate: toDate,
// //       );
// //     } catch (e) {
// //       // Print the error for debugging
// //       print("Error fetching bookings: $e");
// //       errorMessage = "Failed to fetch bookings: ${e.toString()}";
// //     } finally {
// //       isLoading.value = false;
// //       update();
// //     }
// //   }
// // }
//
//
//
//
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/new_booking_list_model.dart';
//
// class BookingController extends GetxController {
//   final String token;
//
//   BookingController({required this.token});
//
//   BookingResponse? bookingResponse;
//   var isLoading = false.obs;
//   String? errorMessage;
//
//   // Filter options
//   List<String> bookingRequestList = ["accepted", "ongoing"];
//   List<String> bookingStatuses = ["pending", "completed", "all"];
//   List<String> timeSlots = ['all', '5am to 10pm', '5pm to 10pm', '5am to 9am'];
//   List<String> serviceTypes = ['all', 'On Demand', 'Car Maintenance', 'Daily Car Wash'];
//
//   // Selected filters
//   var selectedTimeSlot = 'all'.obs;
//   var selectedServiceType = 'all'.obs;
//   var selectedStatus = 'all'.obs;
//
//   // Update filter methods
//   void updateTimeSlotFilter(String timeSlot) {
//     selectedTimeSlot.value = timeSlot;
//   }
//
//   void updateServiceTypeFilter(String serviceType) {
//     selectedServiceType.value = serviceType;
//   }
//
//   void updateBookingStatusState(String status) {
//     selectedStatus.value = status;
//   }
//
//   /// Fetch bookings (controller + API logic combined)
//   Future<void> fetchBookings({
//     int limit = 100,
//     int offset = 1,
//     String? bookingStatus,
//     String? slot,
//     String? serviceId,
//     String? fromDate,
//     String? toDate,
//   }) async {
//     isLoading.value = true;
//     errorMessage = null;
//     update();
//
//     const String baseUrl = 'https://madadservices.com/api/v1/serviceman/booking/list';
//
//     // Apply selected filters, skip "all"
//     bookingStatus ??= selectedStatus.value != 'all' ? selectedStatus.value : null;
//     slot ??= selectedTimeSlot.value != 'all' ? selectedTimeSlot.value : null;
//     serviceId ??= '10646e61-1a40-4b4f-a388-2ae804e2e';
//     fromDate ??= '01-07-2025';
//     toDate ??= '01-07-2025';
//
//     final queryParams = {
//       'limit': limit.toString(),
//       'offset': offset.toString(),
//       if (bookingStatus != null) 'booking_status': bookingStatus,
//       if (slot != null) 'slot': slot,
//       'service_id': serviceId,
//       'from_date': fromDate,
//       'to_date': toDate,
//     };
//
//     final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
//
//     final headers = {
//       'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5NWZhYWFjNi1jMWQyLTRkNGMtYmViMS0wNDE5NmRkMmZhOGUiLCJqdGkiOiJmZDU2OTljZTIwOGVhNTQyOGVkMmYxZjExYmZhZDk4ZDg2Y2NlZGFlNjI3Mzc0ZWNiYzE0OGJlY2NkODliNzJiYzMyOTkwMDlkZTUwNzEyNiIsImlhdCI6MTc1NDAzMjY5MS4yODYxMDk5MjQzMTY0MDYyNSwibmJmIjoxNzU0MDMyNjkxLjI4NjExMjA3MDA4MzYxODE2NDA2MjUsImV4cCI6MTc4NTU2ODY5MS4yODE3Mjk5MzY1OTk3MzE0NDUzMTI1LCJzdWIiOiIyNDAxNmRlNi03OTFjLTQxYTgtYTczMS03N2I1NGRlYWZlYTciLCJzY29wZXMiOltdfQ.nkuSqkKCbm-guZsueTRxSS9rQOYuRWq7b63iqp5Ol6K9Elq13LKmFQrEVs8BYRrB4F6OxdGQr7hh-FHBF8kL1LmJpBT1MkOtv9N46WpcFmi7oLTVUg048f6UW61l43cjwjtzPp7ZrRmgGOaxx_bTeWEDc5jvlMuN__8Fc3ENnxiO8oZoxuWxLq0rId6t1w0oLH2AI_kmRBVCJtjzml3m5f1hcOn1lRsKbdykmw-dhUZbjckOQHO8Z-nKhCXGfAwK7uG27NtOUkVss2YLwdOIQnpnzixcAOsWZ--zO773QYQF_878p0zB7nq5bcFr3P2_PZBLK6-iZS69YtIzNFeDoecpNR3og1MlCFULnIZO9j9w88iGisjaVDW9z_6nj7F5jmq_eayXDawkdz6k7nfgn9Zl4Dz3uTcxggNlDBZpECXienYhnnoz7JdB2sExfu2A0IDQYeKL6Pugvm083Motp-HN2tWQ038EHvv67S2nRiMIlbSqxJohAtf-SwNR_nIPcpU5J8dbmA4SYJ5OzKooRCqAEXH2FwR72qFzQKBSqwX0bgTesVD-jdnt5zS1VgUtDPU-LxFrtFrKOPl8C7pnlk9n12447MWsNw3-EdfwuejvPim-EGtqHV5YCqyvb-0O54-6gVe9ovnTWWlgMSb6RjN5Y_60uM-yxJWM2grYUMU',
//       'Content-Type': 'application/json',
//     };
//
//     try {
//       print("Fetching bookings with params: $queryParams");
//
//       final response = await http.get(uri, headers: headers);
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         bookingResponse = BookingResponse.fromJson(jsonData);
//       } else {
//         throw Exception('Failed to load bookings: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       errorMessage = "Failed to fetch bookings: ${e.toString()}";
//       print("Error fetching bookings: $e");
//     } finally {
//       isLoading.value = false;
//       update();
//     }
//   }
// }
//
