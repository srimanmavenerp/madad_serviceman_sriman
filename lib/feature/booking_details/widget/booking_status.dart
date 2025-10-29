import 'package:demandium_serviceman/feature/booking_details/widget/booking_details_widget.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/cancelledimage.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/connectors.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/indicator_theme.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/indicators.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/timeline_theme.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/timeline_tile_builder.dart';
import 'package:demandium_serviceman/feature/booking_details/widget/timeline/timelines.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/booking_details_model.dart';
import 'package:flutter_avif/flutter_avif.dart';

import 'booking_images/booking_image_model.dart';

class CompatibleNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const CompatibleNetworkImage({
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lower = imageUrl.toLowerCase();
    final isAvif = lower.endsWith('.avif');
    final isWebp = lower.endsWith('.webp');

    // Try to convert AVIF URLs to more compatible formats
    final convertedUrl = _convertImageUrl(imageUrl);

    if (isAvif) {
      // Use AVIF package for AVIF images
      return AvifImage(
        image: NetworkImage(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder ??
            (context, error, stackTrace) {
              debugPrint("AVIF Image Load Error for $imageUrl: $error");
              // Fallback to regular image loading with converted URL
              return _buildRegularNetworkImage(convertedUrl);
            },
      );
    } else if (isWebp) {
      // Handle WebP images with regular network image
      return _buildRegularNetworkImage(imageUrl);
    } else {
      // Regular image formats
      return _buildRegularNetworkImage(imageUrl);
    }
  }

  Widget _buildRegularNetworkImage(String url) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _buildLoading();
      },
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) {
            debugPrint("Image Load Error for $url: $error");
            return _buildErrorPlaceholder();
          },
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.broken_image, color: Colors.grey[700], size: 24),
    );
  }
}

String _convertImageUrl(String originalUrl) {
  final lower = originalUrl.toLowerCase();

  if (lower.endsWith('.avif')) {
    // Try converting AVIF to JPEG (if server supports it)
    return originalUrl.replaceAll('.avif', '.jpg');
  }

  return originalUrl;
}

// String _getCompatibleImageUrl(String originalUrl) {
//   final lower = originalUrl.toLowerCase();

//   if (lower.endsWith('.avif') || lower.endsWith('.webp')) {
//     // Append a parameter to request JPEG version from server
//     return '$originalUrl?format=jpg';
//   }

//   return originalUrl;
// }

class BookingStatus extends StatefulWidget {
  final String? bookingId;
  const BookingStatus({super.key, this.bookingId});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  late BookingDetailsController controller;
  Timer? _autoRefreshTimer;
  Map<DateTime, List<CalendarEvents>> _events = {};
  DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;
  // List<CalendarEvents> _selectedEvents = [];
  bool _loading = true;
  bool _dialogMounted = true;

  List<File> _selectedImages = [];
  List<File> _selectedBeforeImages = [];
  List<File> _selectedCancelImages = [];

  bool _isUploading = false;
  List<Map<String, dynamic>> _occurrences = [];
  bool _isLoadingOccurrences = true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookingDetailsController>();
    _initializeData();
    _startAutoRefresh();
  }

  Future<void> _initializeData() async {
    await _fetchCalendarEvents();
    await _fetchBookingOccurrences();
    _getEventsForDay(_focusedDay);
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      if (mounted) {
        await _refreshData();
      }
    });
  }

  Future<void> _refreshData() async {
    try {
      // _showCalendarEventPopup
      //fetchBookingImageDetails()
      await _fetchCalendarEvents();
      await _fetchBookingOccurrences();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error in auto refresh: $e');
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Color _parseColor(String? hexColor, {String? status}) {
    if (status == "cancelled" || status == "pending") {
      return Colors.red;
    }
    try {
      hexColor = (hexColor ?? '').replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.green;
    }
  }

  Future<void> _fetchCalendarEvents() async {
    if (!mounted) return;

    setState(() => _loading = true);

    try {
      final bookingDetailsController = Get.find<BookingDetailsController>();
      final bookingDetails = bookingDetailsController
          .bookingDetails?.bookingContent?.bookingDetailsContent;
      final bookingId = bookingDetails?.id ?? widget.bookingId ?? '0';

      final url =
          "${AppConstants.baseUrl}${AppConstants.bookingDetailsByIdUrl}${bookingId}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'X-localization': 'en',
          if (Get.find<ApiClient>().token != null)
            'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          setState(() {
            _events.clear();
          });

          if (data is List) {
            for (var occurrenceData in data) {
              _processOccurrenceData(occurrenceData);
            }
          } else {
            // Single occurrence
            _processOccurrenceData(data);
          }
        }
      }
    } catch (e) {
      print('Error fetching calendar events: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _processOccurrenceData(Map<String, dynamic> occurrenceData) {
    try {
      final eventDate = DateTime.parse(occurrenceData['date']).toLocal();
      final key = DateTime(eventDate.year, eventDate.month, eventDate.day);

      final newEvent = CalendarEvents(
        date: occurrenceData['date'],
        status: occurrenceData['status'],
        label: occurrenceData['label'],
        note: occurrenceData['note'],
        color: occurrenceData['status'] == 'completed'
            ? '#4CAF50'
            : occurrenceData['status'] == 'cancelled'
                ? '#F44336'
                : '#FFA500',
        images: (occurrenceData['images'] as List?)?.cast<String>() ?? [],
        beforeImages:
            (occurrenceData['before_images'] as List?)?.cast<String>() ?? [],
      );

      if (_events[key] == null) {
        _events[key] = [newEvent];
      } else {
        bool eventExists = _events[key]!.any((event) =>
            event.date == newEvent.date && event.status == newEvent.status);

        if (!eventExists) {
          _events[key]!.add(newEvent);
        } else {
          int index =
              _events[key]!.indexWhere((event) => event.date == newEvent.date);
          if (index != -1) {
            _events[key]![index] = newEvent;
          }
        }
      }
    } catch (e) {
      print('Error processing occurrence data: $e');
    }
  }

  List<CalendarEvents> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  Future<void> _fetchBookingOccurrences() async {
    if (!mounted) return;

    setState(() {
      _isLoadingOccurrences = true;
    });

    try {
      final bookingDetailsController = Get.find<BookingDetailsController>();
      final bookingDetails = bookingDetailsController
          .bookingDetails?.bookingContent?.bookingDetailsContent;
      final bookingId = bookingDetails?.id ?? widget.bookingId ?? '0';

      final url =
          "${AppConstants.baseUrl}${AppConstants.bookingDetailsByIdUrl}${bookingId}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'X-localization': 'en',
          if (Get.find<ApiClient>().token != null)
            'Authorization': 'Bearer ${Get.find<ApiClient>().token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['data'] != null) {
            final data = jsonResponse['data'];

            if (mounted) {
              setState(() {
                _occurrences.clear();

                if (data is List) {
                  _occurrences =
                      data.map((e) => e as Map<String, dynamic>).toList();
                } else {
                  _occurrences = [data as Map<String, dynamic>];
                }
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching booking occurrences: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingOccurrences = false;
        });
      }
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  Map<String, CalendarEvents> _getUpdatedCalendarEventMap() {
    final bookingDetailsController = Get.find<BookingDetailsController>();
    final bookingDetails = bookingDetailsController
        .bookingDetails?.bookingContent?.bookingDetailsContent;
    final calendarEvents = bookingDetails?.calendarEvents ?? [];

    Map<String, CalendarEvents> updatedMap = {
      for (var event in calendarEvents)
        if (event.date != null) event.date!.split('T').first: event
    };

    _events.forEach((key, eventList) {
      if (eventList.isNotEmpty) {
        final keyString = key.toIso8601String().split('T').first;
        updatedMap[keyString] = eventList.first;
      }
    });

    return updatedMap;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (bookingDetailsController) {
        final bookingDetailsModel = bookingDetailsController.bookingDetails;
        final bookingDetails =
            bookingDetailsModel?.bookingContent?.bookingDetailsContent;
        final List<CalendarEvents> calendarEvents =
            bookingDetails?.calendarEvents ?? [];

        final Map<String, CalendarEvents> calendarEventMap = {
          for (var event in calendarEvents)
            if (event.date != null) event.date!.split('T').first: event
        };

        if (bookingDetailsModel == null && bookingDetails == null) {
          return const Center(child: BookingDetailsShimmer());
        } else if (bookingDetailsModel != null && bookingDetails == null) {
          return SizedBox(
              height: Get.height * 0.7,
              child: BookingEmptyScreen(bookingId: widget.bookingId));
        }

        final isBlockedSubCategory = bookingDetails?.subCategoryId ==
            '1a5bf45c-9d32-4f4e-a726-126e1a40c836';

        Widget statusTimelineSection = Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${'booking_date'.tr} : ',
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                  Text(
                    DateConverter.dateMonthYearTime(
                      DateConverter.isoUtcStringToLocalDate(
                          bookingDetails!.createdAt!),
                    ),
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${'scheduled_date'.tr} : ',
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault)),
                  if (bookingDetails.serviceSchedule != null)
                    Text(
                      DateConverter.dateMonthYearTime(
                        DateTime.tryParse(bookingDetails.serviceSchedule!),
                      ),
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault),
                      textDirection: TextDirection.ltr,
                    ),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              RichText(
                text: TextSpan(
                  text: '${'payment_status'.tr}:   ',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text:
                          bookingDetails.isPaid == 1 ? 'paid'.tr : 'unpaid'.tr,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: bookingDetails.isPaid == 0
                            ? Theme.of(context).colorScheme.error
                            : Colors.green,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              RichText(
                text: TextSpan(
                  text: '${'Booking_Status'.tr}:   ',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text: bookingDetails.bookingStatus!.tr,
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources
                            .buttonTextColorMap[bookingDetails.bookingStatus],
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Timeline1(
                bookingDetails: bookingDetails,
                statusHistories: bookingDetails.statusHistories,
                scheduleHistories: bookingDetails.scheduleHistories,
                increment: bookingDetails.scheduleHistories!.length > 1 &&
                        bookingDetails.statusHistories!.isNotEmpty
                    ? 2
                    : 1,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ],
          ),
        );

        if (isBlockedSubCategory) {
          return Scaffold(
            body: SingleChildScrollView(
              child: statusTimelineSection,
            ),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await _refreshData();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (calendarEvents.isEmpty)
                    Center(child: Text('Calendar data is not available.'))
                  else
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: TableCalendar<CalendarEvents>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue[200],
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.purple[200],
                            shape: BoxShape.circle,
                          ),
                          defaultDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          disabledTextStyle: TextStyle(color: Colors.grey),
                          markerDecoration:
                              BoxDecoration(color: Colors.transparent),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                          weekendStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault),
                        ),
                        enabledDayPredicate: (day) {
                          final updatedCalendarEventMap =
                              _getUpdatedCalendarEventMap();
                          final key = day.toIso8601String().split('T').first;
                          return updatedCalendarEventMap.containsKey(key);
                          // return true;
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          final today = DateTime.now();
                          final todayDate =
                              DateTime(today.year, today.month, today.day);
                          final selectedDate = DateTime(selectedDay.year,
                              selectedDay.month, selectedDay.day);

                          if (selectedDate.isAfter(todayDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    'Not allowed to submit images for future dates',
                                    style: TextStyle(
                                      fontSize: 18.0, // Bigger font
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin:
                                    EdgeInsets.all(20.0), // Margin on all sides
                                elevation: 10,
                              ),
                            );
                            return;
                          }

                          if (selectedDate.isBefore(todayDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0), // Increases height
                                  child: Text(
                                    'Not allowed to submit images for past dates',
                                    style: TextStyle(
                                      fontSize: 18.0, // Bigger font
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin:
                                    EdgeInsets.all(20.0), // Margin on all sides
                                elevation: 10,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _loading = true;
                          });

                          final bookingDetailsController =
                              Get.find<BookingDetailsController>();
                          final bookingDetails = bookingDetailsController
                              .bookingDetails
                              ?.bookingContent
                              ?.bookingDetailsContent;
                          final bookingId =
                              bookingDetails?.id ?? widget.bookingId ?? '0';

                          CalendarEvents? updatedEvent;

                          if (bookingId.isNotEmpty) {
                            try {
                              final response = await fetchBookingImageDetails(
                                  bookingId: bookingId, date: selectedDay);
                              if (response != null &&
                                  response.isSuccess &&
                                  response.imageDetails.isNotEmpty) {
                                final imageDetails =
                                    response.imageDetails.first;
                                final key = DateTime(selectedDay.year,
                                    selectedDay.month, selectedDay.day);

                                updatedEvent = CalendarEvents(
                                  date: imageDetails.date,
                                  status: imageDetails.status,
                                  label: imageDetails.label,
                                  note: imageDetails.note,
                                  color: imageDetails.color ??
                                      (imageDetails.status == 'completed'
                                          ? '#4CAF50'
                                          : imageDetails.status == 'cancelled'
                                              ? '#F44336'
                                              : '#FFA500'),
                                  images: imageDetails.images ?? [],
                                  beforeImages: imageDetails.beforeImages ?? [],
                                );

                                setState(() {
                                  _events[key] = [updatedEvent!];
                                });
                              }
                            } catch (e) {
                              print(
                                  'Error fetching image details on day selection: $e');
                            }
                          }

                          setState(() {
                            _loading = false;
                          });

                          final key =
                              selectedDay.toIso8601String().split('T').first;

                          final updatedCalendarEventMap =
                              _getUpdatedCalendarEventMap();

                          if (updatedEvent != null) {
                            updatedCalendarEventMap[key] = updatedEvent;
                          }
                          if (updatedCalendarEventMap.containsKey(key)) {
                            final event = updatedCalendarEventMap[key]!;
                            final status = event.status?.toLowerCase() ?? '';

                            // Case 1: Pending → show popup only if beforeImages exist
                            if (status == "pending" &&
                                (event.beforeImages?.isNotEmpty ?? false)) {
                              _showCalendarEventPopup(context, event);
                            }
                            // Case 2: Completed / Cancelled → always show popup
                            else if (status == "completed" ||
                                status == "cancelled") {
                              _showCalendarEventPopup(context, event);
                            }
                            // Case 3: Rescheduled or Scheduled → always show bottom sheet
                            else if (status == "rescheduled" ||
                                status == "scheduled") {
                              _showBottomSheet(context, selectedDay);
                            }
                            // Case 4: Pending (no beforeImages) → show bottom sheet
                            else if (status == "pending") {
                              _showBottomSheet(context, selectedDay);
                            }
                            // Case 5: Default fallback → show bottom sheet
                            else {
                              _showBottomSheet(context, selectedDay);
                            }
                          } else {
                            _showBottomSheet(context, selectedDay);
                          }

                          // if (updatedCalendarEventMap.containsKey(key)) {
                          //   final event = updatedCalendarEventMap[key]!;
                          //   if (event.status?.toLowerCase() == "pending" &&
                          //       (event.beforeImages?.isNotEmpty ?? false)||event.status?.toLowerCase()=="scheduled"&&(event.beforeImages?.isNotEmpty??false)) {
                          //     _showCalendarEventPopup(context, event);
                          //   } else if (event.status?.toLowerCase() !=
                          //       "pending") {
                          //   _showBottomSheet(context, selectedDay);
                          //   } else {
                          //     _showBottomSheet(context, selectedDay);
                          //   }
                          // } else {
                          //   _showBottomSheet(context, selectedDay);
                          // }
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, events) {
                            final updatedCalendarEventMap =
                                _getUpdatedCalendarEventMap();
                            final key = date.toIso8601String().split('T').first;

                            if (updatedCalendarEventMap.containsKey(key)) {
                              final event = updatedCalendarEventMap[key]!;
                              final color = _parseColor(
                                  event.color ?? '#4CAF50',
                                  status: event.status);
                              debugPrint(
                                  "calderbuilder:${event.color}:${event.status}");
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Tooltip(
                                    message: event.label ?? '',
                                    child: Text(
                                      '${date.day}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Center(
                              child: Text(
                                '${date.day}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          },
                          todayBuilder: (context, date, events) {
                            // Use updated calendar event map for today's date as well
                            final updatedCalendarEventMap =
                                _getUpdatedCalendarEventMap();
                            final key = date.toIso8601String().split('T').first;

                            if (updatedCalendarEventMap.containsKey(key)) {
                              final event = updatedCalendarEventMap[key]!;
                              final color = _parseColor(
                                  event.color ?? '#4CAF50',
                                  status: event.status);
                              debugPrint(
                                  "todaybuilder:${event.color}:${event.status}");
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Tooltip(
                                    message: event.label ?? '',
                                    child: Text(
                                      '${date.day}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[200],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
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
  }

  void _showBottomSheet(BuildContext context, DateTime selectedDay) {
    final hasOccurrence = _occurrences.any((occ) {
      final occDate = DateTime.parse(occ['date']).toLocal();
      return occDate.year == selectedDay.year &&
          occDate.month == selectedDay.month &&
          occDate.day == selectedDay.day &&
          (occ['status'] == 'completed' || occ['status'] == 'cancelled');
    });

    if (hasOccurrence) {
      Get.snackbar(
        'Already Processed',
        'This date already has a booking occurrence',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 40,
              margin: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            Text(
              'Update Service Status',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            SizedBox(height: Dimensions.paddingSizeDefault),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(Icons.camera_alt, color: Colors.blue[800], size: 24),
              ),
              title: Text('Complete Your Service',
                  style: robotoMedium.copyWith(color: Colors.blue[800])),
              subtitle: Text('Take photos to complete the service',
                  style: robotoRegular.copyWith(color: Colors.grey[600])),
              onTap: () async {
                Get.back();
                await _showImagePicker(context, selectedDay);
              },
            ),
            Divider(color: Colors.grey[300], thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.cancel, color: Colors.red[800], size: 24),
              ),
              title: Text('Cancel Your Service',
                  style: robotoMedium.copyWith(color: Colors.red[800])),
              subtitle: Text('Cancel the service with reason',
                  style: robotoRegular.copyWith(color: Colors.grey[600])),
              onTap: () {
                Get.back();
                _showReasonDialog(context, selectedDay);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePicker(
    BuildContext context,
    DateTime selectedDay, {
    bool isAfter = false,
    StateSetter? dialogSetState,
    List<File>? currentAfterImages,
    List<File>? currentBeforeImages,
  }) async {
    final picker = ImagePicker();

    List<File> workingAfterImages = List.from(_selectedImages);
    List<File> workingBeforeImages = List.from(_selectedBeforeImages);

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Text(
                  isAfter
                      ? 'Add After Service Photos'
                      : 'Add Before Service Photos',
                  style:
                      robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue[800]),
                title: Text(isAfter ? 'Take After Photo' : 'Take Before Photo'),
                onTap: () async {
                  Navigator.pop(context);

                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1200,
                    maxHeight: 1200,
                    imageQuality: 85,
                  );

                  if (pickedFile != null) {
                    final originalFile = File(pickedFile.path);

                    final safeFile = await _validateAndCopyImage(
                        originalFile, isAfter ? 'after_' : 'before_');

                    if (safeFile != null) {
                      if (isAfter) {
                        workingAfterImages.add(safeFile);
                      } else {
                        workingBeforeImages.add(safeFile);
                      }

                      setState(() {
                        _selectedImages = List.from(workingAfterImages);
                        _selectedBeforeImages = List.from(workingBeforeImages);
                      });

                      if (dialogSetState != null) {
                        dialogSetState(() {});
                      } else {
                        if (_selectedImages.isNotEmpty ||
                            _selectedBeforeImages.isNotEmpty) {
                          _showImagePreview(context, selectedDay,
                              isAfter: isAfter);
                        }
                      }
                    } else {
                      Get.snackbar(
                        'Error',
                        'Failed to process the captured image. Please try again.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green[800]),
                title: Text(isAfter
                    ? 'Choose After Photos from Gallery (Max 5)'
                    : 'Choose Before Photos from Gallery (Max 5)'),
                onTap: () async {
                  Navigator.pop(context);

                  final pickedFiles = await picker.pickMultiImage(
                    maxWidth: 1200,
                    maxHeight: 1200,
                    imageQuality: 85,
                  );

                  if (pickedFiles.isNotEmpty) {
                    final limitedFiles = pickedFiles.take(5).toList();

                    List<File> validFiles = [];

                    for (int i = 0; i < limitedFiles.length; i++) {
                      final originalFile = File(limitedFiles[i].path);
                      final safeFile = await _validateAndCopyImage(
                          originalFile, '${isAfter ? 'after' : 'before'}_$i');

                      if (safeFile != null) {
                        validFiles.add(safeFile);
                      }
                    }

                    if (validFiles.isNotEmpty) {
                      if (isAfter) {
                        workingAfterImages.addAll(validFiles);
                      } else {
                        workingBeforeImages.addAll(validFiles);
                      }

                      setState(() {
                        _selectedImages = List.from(workingAfterImages);
                        _selectedBeforeImages = List.from(workingBeforeImages);
                      });

                      if (dialogSetState != null) {
                        dialogSetState(() {});
                      } else {
                        if (_selectedImages.isNotEmpty ||
                            _selectedBeforeImages.isNotEmpty) {
                          _showImagePreview(context, selectedDay,
                              isAfter: isAfter);
                        }
                      }

                      if (validFiles.length < limitedFiles.length) {
                        Get.snackbar(
                          'Warning',
                          'Some images could not be processed and were skipped.',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Error',
                        'No valid images could be processed. Please try again.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePreview(BuildContext context, DateTime selectedDay,
      {required bool isAfter}) {
    if (_selectedBeforeImages.isEmpty && _selectedImages.isEmpty) {
      return;
    }

    Get.dialog(
      Dialog(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Padding(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Selected Images',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge)),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                    if (_selectedBeforeImages.isNotEmpty) ...[
                      _buildImageSection(
                        context,
                        label: 'Before Images:',
                        images: _selectedBeforeImages,
                        onRemove: (index) {
                          setState(() {
                            _selectedBeforeImages.removeAt(index);
                          });
                          dialogSetState(() {
                            if (_selectedBeforeImages.isEmpty &&
                                _selectedImages.isEmpty) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        onAddMore: () {
                          _showImagePicker(
                            context,
                            selectedDay,
                            isAfter: false,
                            dialogSetState: dialogSetState,
                          );
                        },
                        iconColor: Colors.blue,
                      ),
                    ],
                    if (_selectedImages.isNotEmpty) ...[
                      _buildImageSection(
                        context,
                        label: 'After Images:',
                        images: _selectedImages,
                        onRemove: (index) {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                          dialogSetState(() {
                            if (_selectedBeforeImages.isEmpty &&
                                _selectedImages.isEmpty) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        onAddMore: () {
                          _showImagePicker(
                            context,
                            selectedDay,
                            isAfter: true,
                            dialogSetState: dialogSetState,
                          );
                        },
                        iconColor: Colors.green,
                      ),
                    ],
                    if (_selectedBeforeImages.isEmpty &&
                        _selectedImages.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('No images selected.'),
                      ),
                    SizedBox(height: Dimensions.paddingSizeDefault),
                    if (_isUploading)
                      Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Uploading...', style: TextStyle(fontSize: 14)),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.grey[600])),
                          ),
                          TextButton(
                            onPressed: () async {
                              dialogSetState(() => _isUploading = true);

                              try {
                                await _submitBookingOccurrence(
                                  selectedDay,
                                  "completed",
                                  "Service completed with images",
                                  "Service Completed",
                                  _selectedImages,
                                  _selectedBeforeImages,
                                  _selectedCancelImages,
                                );

                                setState(() {
                                  _selectedImages.clear();
                                  _selectedBeforeImages.clear();
                                  _selectedCancelImages.clear();
                                });

                                await _refreshData();

                                Navigator.of(context).pop();
                              } catch (e) {
                                print("Submit error: ${e.toString()}");
                              } finally {
                                if (mounted && _dialogMounted) {
                                  dialogSetState(() => _isUploading = false);
                                }
                              }
                            },
                            child: Text('Submit',
                                style: TextStyle(color: Colors.blue[800])),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context, {
    required String label,
    required List<File> images,
    required void Function(int index) onRemove,
    required VoidCallback onAddMore,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: robotoRegular),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        images[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => onRemove(index),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onAddMore,
            icon: Icon(Icons.add_photo_alternate, color: iconColor),
            label: Text('Add More ${label.split(" ")[0]} Photos'),
          ),
        ),
      ],
    );
  }

  void _showReasonDialog(BuildContext context, DateTime selectedDay) {
    int? _selectedReason;
    List<File> _selectedCancelledImages = [];
    List<String> reasons = [
      'Car not available at parking slot',
      'Different car available',
      'Sorry, Unable to clean today,Will clean evening or nextday',
    ];

    Get.dialog(
      Dialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Cancellation Reason',
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge),
                  ),
                  SizedBox(height: Dimensions.paddingSizeSmall),
                  ...List.generate(reasons.length, (index) {
                    return RadioListTile<int>(
                      value: index,
                      groupValue: _selectedReason,
                      title: Text(reasons[index]),
                      onChanged: (val) {
                        setState(() {
                          _selectedReason = val;
                        });
                      },
                    );
                  }),
                  SizedBox(height: Dimensions.paddingSizeDefault),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final selectedFiles =
                              await Get.bottomSheet<List<File>>(
                            CameraButtonSheetCancelledimage(
                              bookingId: 'booking_001',
                              isSubBooking: false,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );

                          if (selectedFiles != null && mounted) {
                            setState(() {
                              _selectedCancelledImages = selectedFiles;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Upload Images"),
                              Icon(Icons.image_outlined)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault),
                  if (_isUploading)
                    Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Submitting...', style: TextStyle(fontSize: 14)),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_selectedReason == null) {
                              Get.snackbar(
                                'Error',
                                'Please select a cancellation reason',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            if (_selectedCancelledImages.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please upload at least one image',
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            // Set uploading state in parent widget if needed
                            if (mounted) {
                              setState(() {
                                _isUploading = true;
                              });
                            }

                            // Close dialog first
                            Get.back();

                            try {
                              await _submitBookingOccurrence(
                                selectedDay,
                                "cancelled",
                                reasons[_selectedReason!],
                                "Service Not Completed",
                                [], // images
                                [], // beforeImages
                                _selectedCancelledImages, // cancelled images
                              );

                              debugPrint(
                                  "selectedDay: $selectedDay, reason: ${reasons[_selectedReason!]}, cancelledImages: ${_selectedCancelledImages.map((e) => e.path).toList()}");

                              if (mounted) {
                                await _refreshData();
                              }
                            } catch (e) {
                              if (mounted) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to submit: ${e.toString()}',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isUploading = false;
                                });
                              }
                            }
                          },
                          child: Text('Submit',
                              style: TextStyle(color: Colors.blue[800])),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submitBookingOccurrence(
    DateTime date,
    String status,
    String note,
    String label,
    List<File> images,
    List<File> beforeImages,
    List<File> cancelledImages,
  ) async {
    if (!mounted) return;

    setState(() {
      _isUploading = true;
    });

    try {
      debugPrint('=== Starting booking occurrence submission ===');

      final bookingDetailsController = Get.find<BookingDetailsController>();
      final bookingDetails = bookingDetailsController
          .bookingDetails?.bookingContent?.bookingDetailsContent;
      final bookingId = bookingDetails?.id ?? widget.bookingId ?? '0';
      debugPrint('Booking ID: $bookingId');

      final url = Uri.parse(
        'https://madadservices.com/api/v1/serviceman/booking/booking-occurrences',
      );
      debugPrint('URL: $url');

      final request = http.MultipartRequest('POST', url);

      // Auth token
      String? authToken;
      try {
        authToken = Get.find<ApiClient>().token;
        debugPrint('Auth token obtained from ApiClient');
      } catch (e) {
        authToken = 'Bearer YOUR_HARDCODED_TOKEN_HERE';
        debugPrint('Using hardcoded auth token');
      }

      request.headers.addAll({
        'Accept': 'application/json',
        'X-localization': 'en',
        if (authToken != null && authToken.isNotEmpty)
          'Authorization': 'Bearer $authToken',
      });

      // Add fields
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      request.fields.addAll({
        'booking_id': bookingId,
        'date': formattedDate,
        'status': status,
        'note': note,
        'label': label,
      });
      debugPrint('Request fields: ${request.fields}');

      // Helper to safely add files
      Future<void> _addFiles(List<File> files, String fieldName) async {
        for (var file in files) {
          try {
            final exists = await file.exists();
            final length = await file.length();
            debugPrint('Checking file $file: exists=$exists, length=$length');

            if (exists && length > 0) {
              final multipartFile =
                  await http.MultipartFile.fromPath(fieldName, file.path);
              request.files.add(multipartFile);
              debugPrint('Added file $file to field $fieldName');
            } else {
              debugPrint('File skipped (does not exist or empty): $file');
            }
          } catch (e, s) {
            debugPrint('Error adding file $file to $fieldName: $e\n$s');
          }
        }
      }

      // Add images
      await _addFiles(images, 'images[]');
      await _addFiles(beforeImages, 'before_images[]');

      if (status == 'cancelled' && cancelledImages.isNotEmpty) {
        await _addFiles(cancelledImages, 'cancelled_images[]');
      }

      debugPrint(
        'Sending request with ${request.files.length} files...',
      );

      // Send request
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      debugPrint('HTTP response code: ${response.statusCode}');
      debugPrint('Response body: $responseString');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(responseString);
        debugPrint('Parsed JSON response: $jsonResponse');

        final occurrenceData = jsonResponse['data'];
        if (!mounted) return;
        setState(() {
          _occurrences.add(occurrenceData);
        });
        debugPrint('Occurrence added to local state');

        _processOccurrenceData(occurrenceData);

        final eventDate = DateTime.parse(occurrenceData['date']).toLocal();
        final imageDetailsResponse = await fetchBookingImageDetails(
          bookingId: bookingId,
          date: eventDate,
        );

        if (!mounted) return;
        if (imageDetailsResponse != null &&
            imageDetailsResponse.isSuccess &&
            imageDetailsResponse.imageDetails.isNotEmpty) {
          final imageDetails = imageDetailsResponse.imageDetails.first;
          final key = DateTime(eventDate.year, eventDate.month, eventDate.day);

          setState(() {
            _events[key] = [
              CalendarEvents(
                date: imageDetails.date,
                status: imageDetails.status,
                label: imageDetails.label,
                note: imageDetails.note,
                color: imageDetails.color ??
                    (occurrenceData['status'] == 'completed'
                        ? '#4CAF50'
                        : occurrenceData['status'] == 'cancelled'
                            ? '#F44336'
                            : '#FFA500'),
                images: imageDetails.images ?? [],
                beforeImages: imageDetails.beforeImages ?? [],
                cancelledImages: imageDetails.cancelledImages ?? [],
              )
            ];
          });
          debugPrint('Events map updated for $key');
        }

        Get.snackbar(
          'Success',
          'Booking occurrence submitted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await _refreshData();
      } else {
        final errorMessage = _parseErrorMessageFromResponse(responseString);
        debugPrint('Error message from backend: $errorMessage');
        if (response.statusCode != 200 && response.statusCode != 201) {
          _handleErrorResponse(responseString, response.statusCode);
          return; // Stop further execution
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error submitting booking occurrence: $e');
      debugPrint('Stacktrace:\n$stacktrace');

      if (!mounted) return;
      Get.snackbar(
        'Error',
        'Failed to submit booking occurrence: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });
      debugPrint('=== Booking occurrence submission finished ===');
    }
  }

  void _handleErrorResponse(String responseString, int statusCode) {
    try {
      final Map<String, dynamic> jsonResponse = json.decode(responseString);

      if (jsonResponse['status'] == 'fail' && jsonResponse['errors'] != null) {
        // Check for cancelled_images error specifically
        if (jsonResponse['errors']['cancelled_images.0'] != null) {
          final errorMsg =
              (jsonResponse['errors']['cancelled_images.0'] as List).join(', ');
          _showErrorPopup('Image Size Error', errorMsg);
          return;
        }
      }

      // Fallback error
      _showErrorPopup('Error $statusCode', 'Something went wrong');
    } catch (e) {
      // JSON parsing failed or unexpected format
      _showErrorPopup('Error $statusCode', 'Something went wrong');
    }
  }

  void _showErrorPopup(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<File?> _validateAndCopyImage(File originalFile, String prefix) async {
    try {
      if (!await originalFile.exists()) {
        print('Original file does not exist: ${originalFile.path}');
        return null;
      }

      final fileSize = await originalFile.length();
      if (fileSize == 0) {
        print('File is empty: ${originalFile.path}');
        return null;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          '$prefix${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newFile = File('${appDir.path}/$fileName');

      await originalFile.copy(newFile.path);

      if (await newFile.exists() && await newFile.length() > 0) {
        return newFile;
      }

      return null;
    } catch (e) {
      print('Error validating/copying image: $e');
      return null;
    }
  }

  String _parseErrorMessageFromResponse(String responseBody) {
    try {
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['message'] ??
          jsonResponse['error'] ??
          'Unknown error';
    } catch (e) {
      return 'Failed to parse error response';
    }
  }

  Future<GetImagesResponse?> fetchBookingImageDetails({
    required String bookingId,
    required DateTime date,
  }) async {
    try {
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      String? authToken;
      try {
        final apiClient = Get.find<ApiClient>();
        authToken = apiClient.token;
        if (authToken == null || authToken.isEmpty) {
          print('Error: No token found in ApiClient');
          Get.snackbar(
            'Authentication Error',
            'No authentication token available. Please log in again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return null;
        }
      } catch (e) {
        print('Error retrieving token from ApiClient: $e');
        Get.snackbar(
          'Authentication Error',
          'Failed to retrieve authentication token. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      final url = Uri.parse(
          'https://madadservices.com/api/v1/serviceman/booking/calendareventfordate');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-localization': 'en',
        'Authorization': 'Bearer $authToken',
      };

      final body = jsonEncode({
        'booking_id': bookingId,
        'date': formattedDate,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print("FDCvgfcgc${jsonResponse}");
        if (!jsonResponse.containsKey('success') ||
            !jsonResponse.containsKey('events')) {
          print('Error: Response missing success or events field');
          Get.snackbar(
            'Error',
            'Invalid API response format: missing success or events field',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return null;
        }

        final getImagesResponse = GetImagesResponse.fromJson(jsonResponse);
        return getImagesResponse;
      } else if (response.statusCode == 401) {
        print('Error: HTTP 401 - Unauthenticated');
        Get.snackbar(
          'Authentication Error',
          'Session expired or invalid token. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      } else {
        final errorMessage = _parseErrorMessageFromResponse(response.body);
        print('Error: HTTP ${response.statusCode} - $errorMessage');
        Get.snackbar(
          'Error',
          'Failed to fetch booking image details: $errorMessage',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e, stacktrace) {
      print('Exception during fetchBookingImageDetails: $e');
      print('Stacktrace: $stacktrace');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  void _showCalendarEventPopup(
      BuildContext context, CalendarEvents event) async {
    final bookingId = widget.bookingId ??
        Get.find<BookingDetailsController>()
            .bookingDetails
            ?.bookingContent
            ?.bookingDetailsContent
            ?.id ??
        '';

    if (bookingId.isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid booking ID',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final eventDate = DateTime.tryParse(event.date ?? '');
    if (eventDate == null) {
      Get.snackbar(
        'Error',
        'Invalid event date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final response =
        await fetchBookingImageDetails(bookingId: bookingId, date: eventDate);

    if (response == null ||
        !response.isSuccess ||
        response.imageDetails.isEmpty) {
      Get.dialog(
        Dialog(
          child: Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No image details available for this event.',
                  style:
                      robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  'Booking ID: $bookingId',
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Colors.grey[600]),
                ),
                Text(
                  'Date: ${_formatDate(eventDate.toIso8601String())}',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: Dimensions.paddingSizeDefault),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final imageDetails = response.imageDetails.first;
    print("gfdsxcvbnjhgfdxcbgfdc gfc${imageDetails.cancelledImages}");

    Get.dialog(
      Dialog(
        child: Container(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _parseColor(imageDetails.color,
                            status: imageDetails.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        imageDetails.label,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _parseColor(imageDetails.color,
                            status: imageDetails.status)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    imageDetails.status.toUpperCase(),
                    style: robotoMedium.copyWith(
                      color: _parseColor(imageDetails.color,
                          status: imageDetails.status),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ),

                if (imageDetails.date.isNotEmpty ||
                    imageDetails.updatedAt.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (imageDetails.updatedAt.isNotEmpty)
                          Text(
                            _formatDate(imageDetails.updatedAt),
                            style: robotoRegular,
                          ),
                      ],
                    ),
                  ),

                // Note
                if (imageDetails.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      imageDetails.note,
                      style: robotoRegular.copyWith(color: Colors.grey[600]),
                    ),
                  ),

                // Before Images
                Visibility(
                  visible: imageDetails.status.toUpperCase() == "CANCELLED"
                      ? false
                      : true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Before Service Images:',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall)),
                        SizedBox(height: 4),
                        if (imageDetails.beforeImages != null &&
                            imageDetails.beforeImages!.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageDetails.beforeImages!.length,
                              itemBuilder: (context, index) {
                                final imageUrl =
                                    imageDetails.beforeImages![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CompatibleNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Text(
                            'No Before Images',
                            style:
                                robotoRegular.copyWith(color: Colors.grey[600]),
                          ),
                        if (imageDetails.beforeImagesUploadedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Before service time: ${_formatDate(imageDetails.beforeImagesUploadedAt!)}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // After Images
                Visibility(
                  visible: imageDetails.status.toUpperCase() == "CANCELLED"
                      ? false
                      : true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('After Service Images:',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall)),
                        SizedBox(height: 4),
                        if (imageDetails.images != null &&
                            imageDetails.images!.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageDetails.images!.length,
                              itemBuilder: (context, index) {
                                final imageUrl = imageDetails.images![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CompatibleNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Text(
                            'No After Images',
                            style:
                                robotoRegular.copyWith(color: Colors.grey[600]),
                          ),
                        if (imageDetails.afterImagesUploadedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'After service time: ${_formatDate(imageDetails.afterImagesUploadedAt!)}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Add After Image or Cancel actions
                if (imageDetails.status.toLowerCase() == "pending" ||
                    (imageDetails.status.toLowerCase() == "completed" &&
                        (imageDetails.images == null ||
                            imageDetails.images!.isEmpty)))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            setState(() {
                              _selectedImages.clear();
                              _selectedBeforeImages.clear();
                            });
                            _showImagePicker(
                                context, DateTime.parse(imageDetails.date),
                                isAfter: true);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Add After Service Image',
                              style: robotoMedium.copyWith(
                                color: Colors.blue[800],
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.paddingSizeSmall),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            _showReasonDialog(
                                context, DateTime.parse(imageDetails.date));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Cancel Service',
                              style: robotoMedium.copyWith(
                                color: Colors.red[800],
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
// Cancelled Images
                Visibility(
                  visible: imageDetails.status.toUpperCase() == "CANCELLED",
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cancelled Service Images:',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(height: 4),
                        if (imageDetails.cancelledImages!.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageDetails.cancelledImages!.length,
                              itemBuilder: (context, index) {
                                final imageUrl =
                                    imageDetails.cancelledImages![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CompatibleNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Text(
                            'No Cancelled Images',
                            style:
                                robotoRegular.copyWith(color: Colors.grey[600]),
                          ),
                        if (imageDetails.cancelledImagesUploadedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'After service time: ${_formatDate(imageDetails.cancelledImagesUploadedAt!)}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.paddingSizeDefault),

                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate).toLocal();

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;

      final hour = date.hour > 12
          ? date.hour - 12
          : date.hour == 0
              ? 12
              : date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$day/$month/$year at $hour:$minute $period';
    } catch (_) {
      return rawDate;
    }
  }
}

class Timeline1 extends StatelessWidget {
  final BookingDetailsContent? bookingDetailsContent;
  final List<StatusHistories>? statusHistories;
  final List<ScheduleHistories>? scheduleHistories;
  final int increment;
  const Timeline1(
      {super.key,
      required this.statusHistories,
      this.scheduleHistories,
      required this.increment,
      this.bookingDetailsContent,
      required BookingDetailsContent bookingDetails});

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      theme: TimelineThemeData(
          nodePosition: 0,
          indicatorTheme: const IndicatorThemeData(position: 0, size: 30.0)),
      padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: Get.find<LocalizationController>().isLtr ? 0 : 10),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: statusHistories!.length + increment,
        contentsBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 20.0, bottom: 20.0, top: 7, right: 10),
            child: index == 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${'booking_placed_by'.tr} ${scheduleHistories![index].user != null ? scheduleHistories![index].user!.firstName : "customer".tr} "
                          "${scheduleHistories![index].user != null ? scheduleHistories![index].user!.lastName : ""}",
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                        DateConverter.dateMonthYearTime(
                            DateConverter.isoUtcStringToLocalDate(
                                scheduleHistories![index].createdAt!)),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    ],
                  )
                : index == 1 && statusHistories!.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${'booking'.tr} ${statusHistories?[index - 1].bookingStatus.toString().tr.toLowerCase()} ${'by'.tr} "
                            "${statusHistories![index - 1].user?.userType.toString().tr} ",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          statusHistories![index - 1].user?.userType !=
                                  'provider-admin'
                              ? Text(
                                  "${statusHistories![index - 1].user?.firstName ?? ""} ${statusHistories![index - 1].user?.lastName ?? ""}",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                )
                              : Text(
                                  bookingDetailsContent
                                          ?.provider?.companyName ??
                                      bookingDetailsContent
                                          ?.subBooking?.provider?.companyName ??
                                      "",
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            DateConverter.dateMonthYearTime(
                                DateConverter.isoUtcStringToLocalDate(
                                    statusHistories![index - 1].updatedAt!)),
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).secondaryHeaderColor),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                        ],
                      )
                    : index == 2 && scheduleHistories!.length > 1
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: (scheduleHistories!.length - 1) * 80,
                                child: ListView.builder(
                                  itemBuilder: (_, index) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${'booking_schedule_changed_by'.tr} ${scheduleHistories![index + 1].user!.userType.toString().tr}",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        if (scheduleHistories![index + 1]
                                                .user!
                                                .userType !=
                                            'provider-admin')
                                          Text(
                                            "${scheduleHistories![index + 1].user?.firstName.toString()} ${scheduleHistories![index + 1].user?.lastName.toString()}",
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        if (scheduleHistories![index + 1]
                                                .user!
                                                .userType ==
                                            'provider-admin')
                                          Text(
                                            "${bookingDetailsContent?.provider?.companyName ?? ""} ",
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        Text(
                                          DateConverter.dateMonthYearTime(
                                              DateTime.tryParse(
                                                  scheduleHistories![index + 1]
                                                      .schedule!)),
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        const SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraSmall),
                                      ],
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: scheduleHistories!.length - 1,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${'booking'.tr} ${statusHistories?[index - increment].bookingStatus.toString().tr.toLowerCase()} ${'by'.tr} "
                                  "${statusHistories?[index - increment].user?.userType.toString().tr} ",
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault)),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              statusHistories?[index - increment]
                                          .user
                                          ?.userType !=
                                      'provider-admin'
                                  ? Text(
                                      "${statusHistories![index - increment].user?.firstName ?? ""} ${statusHistories![index - increment].user?.lastName ?? ""}",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    )
                                  : Text(
                                      bookingDetailsContent
                                              ?.provider?.companyName ??
                                          bookingDetailsContent?.subBooking
                                              ?.provider?.companyName ??
                                          "",
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Text(
                                DateConverter.dateMonthYearTime(
                                    DateConverter.isoUtcStringToLocalDate(
                                        statusHistories![index - increment]
                                            .updatedAt!)),
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                textDirection: TextDirection.ltr,
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),
                            ],
                          ),
          );
        },
        connectorBuilder: (_, index, __) =>
            SolidLineConnector(color: Theme.of(context).primaryColor),
        indicatorBuilder: (_, index) {
          return DotIndicator(
            color: Theme.of(context).primaryColor,
            child: Center(child: Icon(Icons.check, color: light.cardColor)),
          );
        },
      ),
    );
  }
}
