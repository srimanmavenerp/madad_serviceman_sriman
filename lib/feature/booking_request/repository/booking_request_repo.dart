// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// class BookingRequestRepo{
//   final ApiClient apiClient;
//   BookingRequestRepo({required this.apiClient});
//
//   Future<Response> getBookingList(String requestType, int offset) async {
//        return await apiClient.getData("${AppConstants.bookingRequestUrl}?limit=7&offset=$offset&booking_status=$requestType&service_type=all");
//   }
//
//   Future<Response> getBookingHistoryList(String requestType,int offset) async {
//     return await apiClient.getData("${AppConstants.bookingRequestUrl}?limit=10&offset=$offset&booking_status=$requestType&service_type=all");
//   }
//
// }
//
//



import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

class BookingRequestRepo {
  final ApiClient apiClient;

  BookingRequestRepo({required this.apiClient});

  static const String defaultSlot = '5am to 9am';
  // static const String defaultServiceId = '10646e61-1a40-4b4f-a388-2ae804e2e301';
  static const String defaultFromDate = '01-07-2025';
  static const String defaultToDate = '01-07-2025';

  Future<Response> getBookingList(
      String requestType,
      int offset, {
        String slot = defaultSlot,
        // String serviceId = defaultServiceId,
        String fromDate = defaultFromDate,
        String toDate = defaultToDate,
      }) async {
    // Construct the URL with additional query parameters using Uri
    final url = Uri.parse("${AppConstants.bookingRequestUrl}")
        .replace(queryParameters: {
      'limit': '7',
      'offset': '$offset',
      'booking_status': requestType,
      'service_type': 'all',
      'slot': slot,
      // 'service_id': serviceId,
      'from_date': fromDate,
      'to_date': toDate,
    });

    return await apiClient.getData(url.toString());
  }

  Future<Response> getBookingHistoryList(String requestType, int offset) async {
    final url = Uri.parse("${AppConstants.bookingRequestUrl}")
        .replace(queryParameters: {
      'limit': '10',
      'offset': '$offset',
      'booking_status': requestType,
      'service_type': 'all',
    });

    return await apiClient.getData(url.toString());
  }
}

