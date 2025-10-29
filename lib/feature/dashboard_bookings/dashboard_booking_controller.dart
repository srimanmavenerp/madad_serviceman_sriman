import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../api/api_client.dart';
import 'dashboard_bookings_model.dart';

class CrewDashboardBookingController extends GetxController {
  RxList<Content> bookings = <Content>[].obs;
  RxList<Content> filteredBookings = <Content>[].obs;

  //
  RxString selectedFilter = 'pending'.obs;
  RxString selectedTimeSlot = 'all'.obs;

  RxBool isLoading = false.obs;

  // Available filters and slots
  final List<String> statusFilters = ["pending", "completed"];
  final List<String> timeSlots = ['all', '5am to 10am', '5pm to 10pm'];

  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }




  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      final apiClient = Get.find<ApiClient>();
      final filter = selectedFilter.value;
      final slot = selectedTimeSlot.value;

      final slotParam = slot != 'all' ? '&slot=$slot' : '';

      final url =
          'https://madadservices.com/api/v1/serviceman/booking/service/todaybookings?limit=100&offset=1&filter=$filter$slotParam';

      print('Fetching with filter: $filter, slot: $slot');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'X-localization': 'en',
          if (apiClient.token != null && apiClient.token!.isNotEmpty)
            'Authorization': 'Bearer ${apiClient.token}',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        List<Content> fetchedBookings = [];

        if (jsonResponse['content'] is List) {
          fetchedBookings = (jsonResponse['content'] as List)
              .map((e) => Content.fromJson(e))
              .toList();
        } else if (jsonResponse['content'] is Map &&
            jsonResponse['content']['data'] is List) {
          fetchedBookings = (jsonResponse['content']['data'] as List)
              .map((e) => Content.fromJson(e))
              .toList();
        }

        bookings.value = fetchedBookings;
        filteredBookings.value = fetchedBookings;
      } else {
        bookings.clear();
        filteredBookings.clear();
      }
    } catch (e) {
      bookings.clear();
      filteredBookings.clear();
      print('Fetch Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //  selects status button (Pending/Completed)
  void updateFilter(String status) {
    selectedFilter.value = status;
    fetchBookings();
  }

  //  dropdown for time slots
  void updateTimeSlot(String slot) {
    selectedTimeSlot.value = slot;
    fetchBookings();
  }
}