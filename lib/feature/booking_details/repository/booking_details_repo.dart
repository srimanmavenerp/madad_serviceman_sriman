import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';

class BookingDetailsRepo {
  final ApiClient apiClient;

  BookingDetailsRepo({required this.apiClient});

  Future<Response> getBookingDetails(
      {required String bookingID, required bool isSubBooking}) async {
    final response = await apiClient.getData(
        "${isSubBooking ? AppConstants.subBookingDetailsUrl : AppConstants.bookingDetailsUrl}$bookingID");
    print("getBookingDetails response: ${response.body}");
    return response;
  }

  Future<Response> changeBookingStatus(
      {required String bookingID,
      required String status,
      required String otp,
      List<MultipartBody>? photoEvidence,
      required bool isSubBooking}) async {
    final response = await apiClient.postMultipartData(
      "${isSubBooking ? AppConstants.subBookingStatusUpdateUrl : AppConstants.bookingStatusUpdateUrl}/$bookingID",
      {'booking_status': status, '_method': 'put', "booking_otp": otp},
      photoEvidence,
      null,
    );
    print("changeBookingStatus response: ${response.body}");
    return response;
  }

  Future<Response> changePaymentStatus(
      String bookingID, String paymentStatus) async {
    final response = await apiClient.postData(
        "${AppConstants.paymentStatusUpdate}/$bookingID",
        {'payment_status': paymentStatus, '_method': 'put'});
    print("changePaymentStatus response: ${response.body}");
    return response;
  }

  Future<Response> getServiceListBasedOnSubcategory(
      String subCategoryId) async {
    final response = await apiClient.getData(
        "${AppConstants.serviceListBasedOnSubCategory}?limit=50&offset=1&sub_category_id=$subCategoryId");
    print("getServiceListBasedOnSubcategory response: ${response.body}");
    return response;
  }

  Future<Response> sendBookingOTPNotification(String? bookingId) async {
    final response = await apiClient.getData(
        "${AppConstants.bookingOTPNotificationUri}?booking_id=$bookingId");
    print("sendBookingOTPNotification response: ${response.body}");
    return response;
  }

  Future<Response> getBookingPriceList(
      String zoneId, String serviceInfo) async {
    final response = await apiClient.getData(
        "${AppConstants.getBookingPriceList}?zone_id=$zoneId&service_info=$serviceInfo");
    print("getBookingPriceList response: ${response.body}");
    return response;
  }

  Future<Response> removeCartServiceFromServer(
      {CartModel? cart, String? bookingId, String? zoneId}) async {
    final response =
        await apiClient.postData(AppConstants.removeCartServiceFromServer, {
      "_method": "put",
      "booking_id": bookingId,
      "zone_id": zoneId,
      "variant_key": cart?.variantKey,
      "service_id": cart?.serviceId
    });
    print("removeCartServiceFromServer response: ${response.body}");
    return response;
  }

  Future<Response> updateBooking(
      {required bool isSubBooking,
      String? bookingId,
      String? subBookingId,
      String? zoneId,
      String? paymentStatus,
      String? servicemanId,
      String? bookingStatus,
      String? serviceSchedule,
      String? serviceInfo,
      String? serviceData}) async {
    final response = await apiClient.postData(
        isSubBooking
            ? AppConstants.updateSubBooking
            : AppConstants.updateRegularBooking,
        {
          "_method": "put",
          "booking_id": bookingId,
          "booking_repeat_id": subBookingId,
          "zone_id": zoneId,
          "payment_status": paymentStatus,
          "serviceman_id": servicemanId,
          "booking_status": bookingStatus,
          "service_schedule": serviceSchedule,
          "service_info": serviceInfo,
          "service_data": serviceData
        });
    print("updateBooking response: ${response.body}");
    return response;
  }
}
