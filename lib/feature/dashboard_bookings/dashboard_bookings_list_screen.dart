// import 'package:flutter/material.dart';
// import 'dashboard_booking_controller.dart';
//
// class BookingListWidget extends StatelessWidget {
//   final CrewDashboardBookingController controller;
//
//   const BookingListWidget({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final bookings = controller.bookings;
//
//     if (controller.isLoading.value && bookings.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (bookings.isEmpty) {
//       return const Center(child: Text('No bookings found.'));
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: bookings.length,
//       itemBuilder: (context, index) {
//         final booking = bookings[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           child: ListTile(
//             title: Text('Booking ID: ${booking.id}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Customer ID: ${booking.customerId}'),
//                 Text('Status: ${booking.bookingStatus}'),
//                 Text('Amount: \$${booking.totalBookingAmount?.toStringAsFixed(2) ?? "0.00"}'),
//                 Text('Slot: ${booking.slot ?? ""}'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }