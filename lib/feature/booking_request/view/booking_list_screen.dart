// import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
//
// class BookingListScreen extends StatefulWidget {
//   const BookingListScreen({super.key}) ;
//
//   @override
//   State<BookingListScreen> createState() => _BookingListScreenState();
// }
//
// class _BookingListScreenState extends State<BookingListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//         appBar:  MainAppBar(title: 'booking_requests'.tr,color: Theme.of(context).primaryColor),
//       body: GetBuilder<BookingRequestController>(
//         builder: (bookingRequestController){
//
//           bool isEmpty = bookingRequestController.bookingList.isEmpty;
//           int subBookingCount = 0;
//
//           if(bookingRequestController.bookingList.isNotEmpty){
//             for(var booking in bookingRequestController.bookingList){
//               if(booking.repeatBookingList !=null && booking.repeatBookingList!.isNotEmpty){
//                 for(var subBooking in booking.repeatBookingList!){
//                   if(bookingRequestController.bookingStatusState.name.toLowerCase() == subBooking.bookingStatus){
//                     subBookingCount ++;
//                     break;
//                   }
//                 }
//               }{
//                 subBookingCount ++;
//               }
//             }
//           }
//
//           if(!isEmpty){
//             if(subBookingCount == 0){
//               isEmpty = true;
//             }
//           }
//
//
//           List<BookingRequestModel> bookingList = bookingRequestController.bookingList;
//           return RefreshIndicator(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.6),
//             onRefresh: () async{
//               Get.find<BookingRequestController>().getBookingList(bookingRequestController.bookingStatusState.name.toLowerCase(),1);
//             },
//             child: CustomScrollView(
//               controller:bookingRequestController.scrollController,
//               physics: const ClampingScrollPhysics(
//                 parent: AlwaysScrollableScrollPhysics()
//               ),
//               slivers: [
//                 SliverPersistentHeader(delegate: BookingListMenu(),pinned: true,floating: false,),
//
//                 !bookingRequestController.isFirst? isEmpty ?
//                 SliverToBoxAdapter(child: SizedBox(
//                   height: Get.height * 0.75,
//                   child: NoDataScreen(
//                     type: NoDataType.booking,
//                     text: '${'no'.tr} ${bookingRequestController.bookingStatusState.name.toLowerCase()=='all'?'':
//                     bookingRequestController.bookingStatusState.name.toLowerCase().tr.toLowerCase()} ${"request_right_now".tr}',
//
//                   ),
//                 )) : SliverToBoxAdapter(
//                   child: Column( children: [
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: bookingList.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (con, index){
//                         return bookingList[index].repeatBookingList !=null && bookingList[index].repeatBookingList!.isNotEmpty  ?
//                         ListView.builder(
//                           shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
//                           itemCount: bookingList[index].repeatBookingList!.length,
//                           itemBuilder: (context,secondIndex){
//                             return bookingRequestController.bookingStatusState.name.toLowerCase() ==  bookingList[index].repeatBookingList![secondIndex].bookingStatus ? BookingRequestItem(
//                               bookingRequestModel: bookingList[index],
//                               repeatBooking : bookingList[index].repeatBookingList![secondIndex],
//                             ) : const SizedBox();
//                           },
//                         ):
//                         BookingRequestItem(bookingRequestModel: bookingList[index]);
//                       },
//                     ),
//                     bookingRequestController.isLoading ? CircularProgressIndicator(color: Theme.of(context).primaryColor,):const SizedBox()
//                   ]),
//                 ) :const SliverToBoxAdapter(child: BookingRequestItemShimmer()),
//               ],
//             ),
//           );
//         },
//       )
//     );
//   }
// }
//
//
//
//
// import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// class BookingListScreen extends StatefulWidget {
//   const BookingListScreen({super.key});
//
//   @override
//   State<BookingListScreen> createState() => _BookingListScreenState();
// }
//
// class _BookingListScreenState extends State<BookingListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: MainAppBar(
//         title: 'booking_requests'.tr,
//         color: Theme.of(context).primaryColor,
//       ),
//       body: GetBuilder<BookingRequestController>(
//         builder: (bookingRequestController) {
//           String selectedSlot = bookingRequestController.selectedTimeSlot;
//           String selectedStatus = bookingRequestController.bookingStatusState.name.toLowerCase();
//
//           List<BookingRequestModel> filteredBookingList = [];
//
//           String normalize(String s) => s.toLowerCase().trim();
//
//           // Helper function to extract slot from serviceSchedule (if possible)
//           String? extractSlotFromSchedule(String? schedule) {
//             if (schedule == null) return null;
//             // Example: Parse "2025-07-17 20:00:00" to determine slot
//             try {
//               final dateTime = DateTime.parse(schedule);
//               final hour = dateTime.hour;
//               // Define your slot logic based on time (customize as needed)
//               if (hour >= 17 && hour < 22) return '5pm to 10pm';
//               if (hour >= 5 && hour < 10) return '5am to 10am';
//               // Add more slot mappings as needed
//               return null;
//             } catch (e) {
//               return null;
//             }
//           }
//
//           // Filter bookings
//           for (var booking in bookingRequestController.bookingHistoryList) {
//             if (booking.repeatBookingList != null && booking.repeatBookingList!.isNotEmpty) {
//               List<RepeatBooking> filteredRepeatBookings = booking.repeatBookingList!
//                   .where((repeat) {
//                 final repeatStatus = normalize(repeat.bookingStatus ?? '');
//                 final repeatSlot = normalize(repeat.slot ?? '');
//
//                 final statusMatch = selectedStatus == 'all' || repeatStatus == normalize(selectedStatus);
//                 final slotMatch = selectedSlot == 'all' || repeatSlot == normalize(selectedSlot);
//
//                 return statusMatch && slotMatch;
//               }).toList();
//
//               if (filteredRepeatBookings.isNotEmpty) {
//                 filteredBookingList.add(
//                   BookingRequestModel(
//                     id: booking.id,
//                     readableId: booking.readableId,
//                     zoneId: booking.zoneId,
//                     bookingStatus: booking.bookingStatus,
//                     serviceSchedule: booking.serviceSchedule,
//                     isPaid: booking.isPaid,
//                     paymentMethod: booking.paymentMethod,
//                     totalBookingAmount: booking.totalBookingAmount,
//                     totalTaxAmount: booking.totalTaxAmount,
//                     totalDiscountAmount: booking.totalDiscountAmount,
//                     createdAt: booking.createdAt,
//                     updatedAt: booking.updatedAt,
//                     subCategoryId: booking.subCategoryId,
//                     totalCampaignDiscountAmount: booking.totalCampaignDiscountAmount,
//                     totalCouponDiscountAmount: booking.totalCouponDiscountAmount,
//                     isGuest: booking.isGuest,
//                     isRepeatBooking: booking.isRepeatBooking,
//                     repeatBookingList: filteredRepeatBookings,
//                     subCategory: booking.subCategory,
//                     serviceLocation: booking.serviceLocation,
//                   ),
//                 );
//               }
//             } else {
//               // Handle non-repeat bookings
//               final bookingStatusNormalized = normalize(booking.bookingStatus ?? '');
//               final statusMatch = selectedStatus == 'all' || bookingStatusNormalized == normalize(selectedStatus);
//
//               // Try to extract slot from serviceSchedule for non-repeat bookings
//               final bookingSlot = extractSlotFromSchedule(booking.serviceSchedule);
//               final slotMatch = selectedSlot == 'all' || (bookingSlot != null && normalize(bookingSlot) == normalize(selectedSlot));
//
//               if (statusMatch && slotMatch) {
//                 filteredBookingList.add(booking);
//               }
//             }
//           }
//
//           // Debug logging to verify filtered bookings
//           print('Selected time slot: $selectedSlot');
//           print('Selected status: $selectedStatus');
//           print('Filtered count: ${filteredBookingList.length}');
//           for (var booking in filteredBookingList) {
//             if (booking.repeatBookingList != null && booking.repeatBookingList!.isNotEmpty) {
//               for (var repeat in booking.repeatBookingList!) {
//                 print('→ ${booking.id}, slot=${repeat.slot}');
//               }
//             } else {
//               print('→ ${booking.id}, slot=${extractSlotFromSchedule(booking.serviceSchedule) ?? 'N/A'}');
//             }
//           }
//
//           bool isEmpty = bookingRequestController.bookingHistoryList.isEmpty || filteredBookingList.isEmpty;
//
//           return RefreshIndicator(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(150),
//             onRefresh: () async {
//               await bookingRequestController.getBookingList(
//                 bookingRequestController.bookingStatusState.name.toLowerCase(),
//                 1,
//               );
//             },
//             child: CustomScrollView(
//               controller: bookingRequestController.scrollController,
//               physics: const ClampingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
//                 SliverPersistentHeader(
//                   delegate: BookingListMenu(),
//                   pinned: true,
//                   floating: false,
//                 ),
//                 if (!bookingRequestController.isFirst) ...[
//                   if (isEmpty)
//                     SliverFillRemaining(
//                       child: NoDataScreen(
//                         type: NoDataType.booking,
//                         text:
//                         '${'no'.tr} ${selectedStatus == 'all' ? '' : selectedStatus.tr.toLowerCase()} ${"request_right_now".tr}',
//                       ),
//                     )
//                   else
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           final booking = filteredBookingList[index];
//
//                           // Ensure UI reflects the filtered bookings
//                           if (booking.repeatBookingList != null && booking.repeatBookingList!.isNotEmpty) {
//                             return Column(
//                               children: booking.repeatBookingList!
//                                   .where((repeat) {
//                                 final repeatStatus = normalize(repeat.bookingStatus ?? '');
//                                 final repeatSlot = normalize(repeat.slot ?? '');
//
//                                 final statusMatch = selectedStatus == 'all' || repeatStatus == normalize(selectedStatus);
//                                 final slotMatch = selectedSlot == 'all' || repeatSlot == normalize(selectedSlot);
//
//                                 return statusMatch && slotMatch;
//                               })
//                                   .map((repeat) => BookingRequestItem(
//                                 bookingRequestModel: booking,
//                                 repeatBooking: repeat,
//                                 serviceId: '',
//                               ))
//                                   .toList(),
//                             );
//                           } else {
//                             return BookingRequestItem(
//                               bookingRequestModel: booking,
//                               serviceId: '',
//                             );
//                           }
//                         },
//                         childCount: filteredBookingList.length,
//                       ),
//                     ),
//                   if (bookingRequestController.isLoading)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ] else
//                   const SliverToBoxAdapter(child: BookingRequestItemShimmer()),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

/////////////////////////////////////////////////


//
// import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// class BookingListScreen extends StatefulWidget {
//   const BookingListScreen({super.key});
//
//   @override
//   State<BookingListScreen> createState() => _BookingListScreenState();
// }
//
// class _BookingListScreenState extends State<BookingListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: MainAppBar(
//         title: 'booking_requests'.tr,
//         color: Theme.of(context).primaryColor,
//       ),
//       body: GetBuilder<BookingRequestController>(
//         builder: (bookingRequestController) {
//           String selectedSlot = bookingRequestController.selectedTimeSlot;
//           String selectedStatus = bookingRequestController.bookingStatusState.name.toLowerCase();
//
//
//
//           List<BookingRequestModel> filteredBookingList = [];
//
//           String normalize(String s) => s.toLowerCase().trim();
//
//           String? extractSlotFromSchedule(String? schedule) {
//             if (schedule == null) return null;
//             try {
//               final dateTime = DateTime.parse(schedule);
//               final hour = dateTime.hour;
//               if (hour >= 5 && hour < 10) return '5am to 10am';
//               if (hour >= 17 && hour < 22) return '5pm to 10pm';
//               return null;
//             } catch (_) {
//               return null;
//             }
//           }
//
//           for (var booking in bookingRequestController.bookingHistoryList) {
//             if (booking.isRepeatBooking == 1 &&
//                 booking.repeatBookingList != null &&
//                 booking.repeatBookingList!.isNotEmpty) {
//               // Filter repeat bookings
//               List<RepeatBooking> filteredRepeatBookings = booking.repeatBookingList!.where((repeat) {
//                 final repeatStatus = normalize(repeat.bookingStatus ?? '');
//                 final repeatSlot = normalize(repeat.slot ?? extractSlotFromSchedule(repeat.serviceSchedule) ?? '');
//
//                 final statusMatch = selectedStatus == 'all' || repeatStatus == normalize(selectedStatus);
//                 final slotMatch = selectedSlot == 'all' || repeatSlot == normalize(selectedSlot);
//
//                 return statusMatch && slotMatch;
//               }).toList();
//
//               if (filteredRepeatBookings.isNotEmpty) {
//                 // Add booking with filtered repeat bookings only
//                 filteredBookingList.add(
//                   BookingRequestModel(
//                     id: booking.id,
//                     readableId: booking.readableId,
//                     zoneId: booking.zoneId,
//                     bookingStatus: booking.bookingStatus,
//                     serviceSchedule: booking.serviceSchedule,
//                     isPaid: booking.isPaid,
//                     paymentMethod: booking.paymentMethod,
//                     totalBookingAmount: booking.totalBookingAmount,
//                     totalTaxAmount: booking.totalTaxAmount,
//                     totalDiscountAmount: booking.totalDiscountAmount,
//                     createdAt: booking.createdAt,
//                     updatedAt: booking.updatedAt,
//                     subCategoryId: booking.subCategoryId,
//                     totalCampaignDiscountAmount: booking.totalCampaignDiscountAmount,
//                     totalCouponDiscountAmount: booking.totalCouponDiscountAmount,
//                     isGuest: booking.isGuest,
//                     isRepeatBooking: booking.isRepeatBooking,
//                     repeatBookingList: filteredRepeatBookings,
//                     subCategory: booking.subCategory,
//                     serviceLocation: booking.serviceLocation,
//                   ),
//                 );
//               }
//             } else {
//               // Filter non-repeat bookings
//               final bookingStatusNormalized = normalize(booking.bookingStatus ?? '');
//               final statusMatch = selectedStatus == 'all' || bookingStatusNormalized == normalize(selectedStatus);
//
//               final bookingSlot = extractSlotFromSchedule(booking.serviceSchedule);
//               final slotMatch = selectedSlot == 'all' || (bookingSlot != null && normalize(bookingSlot) == normalize(selectedSlot));
//
//               if (statusMatch && slotMatch) {
//                 filteredBookingList.add(booking);
//               }
//             }
//           }
//
//           bool isEmpty = bookingRequestController.bookingHistoryList.isEmpty || filteredBookingList.isEmpty;
//
//
//           return RefreshIndicator(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(150),
//             onRefresh: () async {
//               await bookingRequestController.getBookingList(
//                 bookingRequestController.bookingStatusState.name.toLowerCase(),
//                 1,
//               );
//             },
//             child: CustomScrollView(
//               controller: bookingRequestController.scrollController,
//               physics: const ClampingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
//                 SliverPersistentHeader(
//                   delegate: BookingListMenu(),
//                   pinned: true,
//                   floating: false,
//                 ),
//                 if (!bookingRequestController.isFirst) ...[
//                   if (isEmpty)
//                     SliverFillRemaining(
//                       child: NoDataScreen(
//                         type: NoDataType.booking,
//                         text:
//                         '${'no'.tr} ${selectedStatus == 'all' ? '' : selectedStatus.tr.toLowerCase()} ${"request_right_now".tr}',
//                       ),
//                     )
//                   else
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           final booking = filteredBookingList[index];
//
//                           if (booking.isRepeatBooking == 1 &&
//                               booking.repeatBookingList != null &&
//                               booking.repeatBookingList!.isNotEmpty) {
//                             return Column(
//                               children: booking.repeatBookingList!
//                                   .map((repeat) => BookingRequestItem(
//                                 bookingRequestModel: booking,
//                                 repeatBooking: repeat,
//                                 serviceId: '',
//                               ))
//                                   .toList(),
//                             );
//                           } else {
//                             return BookingRequestItem(
//                               bookingRequestModel: booking,
//                               serviceId: '',
//                             );
//                           }
//                         },
//                         childCount: filteredBookingList.length,
//                       ),
//                     ),
//                   if (bookingRequestController.isLoading)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ] else
//                   const SliverToBoxAdapter(child: BookingRequestItemShimmer()),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



//////////////////////



// import 'package:demandium_serviceman/common/widgets/no_data_screen.dart';
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:intl/intl.dart';
//
// import '../widgets/booking_list_menu.dart';
//
// class BookingListScreen extends StatefulWidget {
//   const BookingListScreen({super.key});
//
//   @override
//   State<BookingListScreen> createState() => _BookingListScreenState();
// }
//
// class _BookingListScreenState extends State<BookingListScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     final controller = Get.find<BookingRequestController>();
//     controller.resetFiltersForAllService();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: MainAppBar(
//         title: 'booking_requests'.tr,
//         color: Theme.of(context).primaryColor,
//       ),
//       body: GetBuilder<BookingRequestController>(
//         builder: (bookingRequestController) {
//           String selectedSlot = bookingRequestController.selectedTimeSlot;
//           String selectedStatus = bookingRequestController.selectedStatus.toLowerCase();
//           String selectedServiceType = bookingRequestController.selectedServiceType;
//           String? selectedDate = bookingRequestController.formattedSelectedDate;
//
//           List<BookingRequestModel> filteredBookingList = [];
//
//           String normalize(String s) => s.toLowerCase().trim().replaceAll(' ', '');
//
//           String? extractSlotFromSchedule(String? schedule) {
//             if (schedule == null) return null;
//             try {
//               final dateTime = DateTime.parse(schedule);
//               final hour = dateTime.hour;
//               if (hour >= 5 && hour < 10) return '5am to 10am';
//               if (hour >= 17 && hour < 22) return '5pm to 10pm';
//               return null;
//             } catch (_) {
//               return null;
//             }
//           }
//
//           bool isDateMatch(String? schedule, {String? fallback}) {
//             if (selectedDate.isEmpty) return true;
//             try {
//               final parsedDate = DateTime.parse(schedule ?? fallback ?? '');
//               final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
//               return formattedDate == selectedDate;
//             } catch (_) {
//               return false;
//             }
//           }
//
//           for (var booking in bookingRequestController.bookingHistoryList) {
//             if (booking.isRepeatBooking == 1 &&
//                 booking.repeatBookingList != null &&
//                 booking.repeatBookingList!.isNotEmpty) {
//               List<RepeatBooking> filteredRepeatBookings = booking.repeatBookingList!.where((repeat) {
//                 final repeatStatus = normalize(repeat.bookingStatus ?? '');
//                 final repeatSlot = normalize(repeat.slot ?? extractSlotFromSchedule(repeat.serviceSchedule) ?? '');
//                 final serviceType = normalize(booking.subCategory?.name ?? '');
//                 final statusMatch = selectedStatus == 'all' ||
//                     (selectedStatus == 'pending' && (repeatStatus == 'accepted' || repeatStatus == 'ongoing')) ||
//                     repeatStatus == selectedStatus;
//                 final slotMatch = selectedSlot == 'all' || repeatSlot == normalize(selectedSlot);
//                 final serviceTypeMatch = selectedServiceType == 'all' || serviceType == normalize(selectedServiceType);
//                 final dateMatch = isDateMatch(booking.createdAt);
//
//                 return statusMatch && slotMatch && serviceTypeMatch && dateMatch;
//               }).toList();
//
//               if (filteredRepeatBookings.isNotEmpty) {
//                 filteredBookingList.add(
//                   BookingRequestModel(
//                     id: booking.id,
//                     readableId: booking.readableId,
//                     zoneId: booking.zoneId,
//                     bookingStatus: booking.bookingStatus,
//                     serviceSchedule: booking.serviceSchedule,
//                     isPaid: booking.isPaid,
//                     paymentMethod: booking.paymentMethod,
//                     totalBookingAmount: booking.totalBookingAmount,
//                     totalTaxAmount: booking.totalTaxAmount,
//                     totalDiscountAmount: booking.totalDiscountAmount,
//                     createdAt: booking.createdAt,
//                     updatedAt: booking.updatedAt,
//                     subCategoryId: booking.subCategoryId,
//                     totalCampaignDiscountAmount: booking.totalCampaignDiscountAmount,
//                     totalCouponDiscountAmount: booking.totalCouponDiscountAmount,
//                     isGuest: booking.isGuest,
//                     isRepeatBooking: booking.isRepeatBooking,
//                     repeatBookingList: filteredRepeatBookings,
//                     subCategory: booking.subCategory,
//                     serviceLocation: booking.serviceLocation,
//                   ),
//                 );
//               }
//             } else {
//               final bookingStatusNormalized = normalize(booking.bookingStatus ?? '');
//               final statusMatch = selectedStatus == 'all' ||
//                   (selectedStatus == 'pending' && (bookingStatusNormalized == 'accepted' || bookingStatusNormalized == 'ongoing')) ||
//                   bookingStatusNormalized == selectedStatus;
//               final bookingSlot = extractSlotFromSchedule(booking.serviceSchedule);
//               final slotMatch = selectedSlot == 'all' || (bookingSlot != null && normalize(bookingSlot) == normalize(selectedSlot));
//               final serviceType = normalize(booking.subCategory?.name ?? '');
//               final serviceTypeMatch = selectedServiceType == 'all' || serviceType == normalize(selectedServiceType);
//               final dateMatch = isDateMatch(booking.createdAt);
//
//               if (statusMatch && slotMatch && serviceTypeMatch && dateMatch) {
//                 filteredBookingList.add(booking);
//               }
//             }
//           }
//
//           bool isEmpty = bookingRequestController.bookingHistoryList.isEmpty || filteredBookingList.isEmpty;
//
//           return RefreshIndicator(
//             backgroundColor: Theme.of(context).colorScheme.surface,
//             color: Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(150),
//             onRefresh: () async {
//               // Reset date if service type is 'all'
//               if (bookingRequestController.selectedServiceType.toLowerCase() == 'all') {
//                 bookingRequestController.selectedDate = null;
//               }
//
//               await bookingRequestController.getBookingList(
//                 bookingRequestController.selectedStatus.toLowerCase() == 'all'
//                     ? bookingRequestController.bookingStatusState.name.toLowerCase()
//                     : bookingRequestController.selectedStatus.toLowerCase() == 'pending'
//                     ? 'completed'
//                     : bookingRequestController.selectedStatus.toLowerCase(),
//                 1,
//               );
//             },
//             child: CustomScrollView(
//               controller: bookingRequestController.scrollController,
//               physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
//                 SliverPersistentHeader(
//                   delegate: BookingListMenu(),
//                   pinned: true,
//                   floating: false,
//                 ),
//                 if (!bookingRequestController.isFirst) ...[
//                   if (isEmpty)
//                     SliverFillRemaining(
//                       child: NoDataScreen(
//                         type: NoDataType.booking,
//                         text: selectedDate.isEmpty
//                             ? 'No bookings for the current date.'
//                             : 'No bookings for ${bookingRequestController.formattedSelectedDate}.',
//                       ),
//                     )
//                   else
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           final booking = filteredBookingList[index];
//
//                           if (booking.isRepeatBooking == 1 &&
//                               booking.repeatBookingList != null &&
//                               booking.repeatBookingList!.isNotEmpty) {
//                             return Column(
//                               children: booking.repeatBookingList!
//                                   .map((repeat) => BookingRequestItem(
//                                 bookingRequestModel: booking,
//                                 repeatBooking: repeat,
//                                 serviceId: '',
//                               ))
//                                   .toList(),
//                             );
//                           } else {
//                             return BookingRequestItem(
//                               bookingRequestModel: booking,
//                               serviceId: '',
//                             );
//                           }
//                         },
//                         childCount: filteredBookingList.length,
//                       ),
//                     ),
//                   if (bookingRequestController.isLoading)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ] else
//                   const SliverToBoxAdapter(child: BookingRequestItemShimmer()),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


