import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

class BookingListMenu extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<BookingRequestController>(
      builder: (controller) {
        final selectedTimeSlot = controller.selectedTimeSlot;
        final selectedServiceType = controller.selectedServiceType;

        // Ensure current values exist in their respective lists
        final validTimeSlots = controller.timeSlots.toSet().toList();
        final validServiceTypes = controller.serviceTypes.toSet().toList();

        String? dropdownTimeSlot = validTimeSlots.contains(selectedTimeSlot) ? selectedTimeSlot : null;
        String? dropdownServiceType = validServiceTypes.contains(selectedServiceType) ? selectedServiceType : null;

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
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: BookingMenuItem(
                            title: status.name.toLowerCase().tr,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 2),

                // Time slot dropdown
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: _dropdownDecoration(context),
                  child: DropdownButton<String>(
                    value: dropdownTimeSlot,
                    items: validTimeSlots.map((slot) {
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
                      }
                    },
                    underline: const SizedBox(),
                    style: robotoRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Service type dropdown
                Container(
                  height: 38,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: _dropdownDecoration(context),
                  child: DropdownButton<String>(
                    value: dropdownServiceType,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    items: validServiceTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type.tr,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateServiceTypeFilter(value);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Date Picker Button
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
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
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
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
                        controller.updateSelectedDate(picked);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

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
}




///////////////////




// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// import '../controller/new_booking_list_controller.dart';
//
// class BookingListMenu extends SliverPersistentHeaderDelegate {
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return GetBuilder<BookingController>(  // Using GetBuilder with GetxController
//       builder: (controller) {
//         final selectedTimeSlot = controller.selectedTimeSlot.value;  // Use .value to access Rx variables
//         final selectedServiceType = controller.selectedServiceType.value;
//         final selectedStatus = controller.selectedStatus.value;
//
//         // Ensure current values exist in their respective lists
//         final validTimeSlots = controller.timeSlots.toSet().toList();
//         final validServiceTypes = controller.serviceTypes.toSet().toList();
//         final validStatuses = controller.bookingStatuses.toSet().toList();
//
//         // Set dropdown value based on current selections
//         String? dropdownTimeSlot = validTimeSlots.contains(selectedTimeSlot) ? selectedTimeSlot : null;
//         String? dropdownServiceType = validServiceTypes.contains(selectedServiceType) ? selectedServiceType : null;
//         String? dropdownStatus = validStatuses.contains(selectedStatus) ? selectedStatus : null;
//
//         return Container(
//           color: Theme.of(context).colorScheme.surface,
//           padding: const EdgeInsets.symmetric(
//             vertical: Dimensions.paddingSizeSmall,
//             horizontal: Dimensions.paddingSizeSmall,
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//
//
//                 // Booking Status Buttons
//                 // SizedBox(
//                 //   height: 36,
//                 //   child: ListView.builder(
//                 //     shrinkWrap: true,
//                 //     physics: const NeverScrollableScrollPhysics(),
//                 //     scrollDirection: Axis.horizontal,
//                 //     itemCount: validStatuses.length,
//                 //     itemBuilder: (context, index) {
//                 //       final status = validStatuses[index];
//                 //       return InkWell(
//                 //         onTap: () {
//                 //           controller.updateBookingStatusState(status);
//                 //         },
//                 //         child: Padding(
//                 //           padding: const EdgeInsets.only(right: 12),
//                 //           child: BookingMenuItem(
//                 //             title: status.toLowerCase().tr,  // Assuming you want to localize the string
//                 //             index: index,
//                 //           ),
//                 //         ),
//                 //       );
//                 //     },
//                 //   ),
//                 // ),
//
//                 SizedBox(
//                   height: 36,
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: validStatuses.length,
//                     itemBuilder: (context, index) {
//
//                       print('validStatuses length: ${validStatuses.length}');
//                       print('Rendering status at index: $index - Status: ${validStatuses[index]}');
//
//                       if (index >= validStatuses.length) {
//                         return Container();
//                       }
//
//                       final status = validStatuses[index];
//
//                       return InkWell(
//                         onTap: () {
//                           controller.updateBookingStatusState(status);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 12),
//                           child: BookingMenuItem(
//                             title: status.toLowerCase().tr,
//                             index: index,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(width: 2),
//
//                 // Time Slot Dropdown
//
//                 Container(
//                   height: 38,
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   decoration: _dropdownDecoration(context),
//                   child: DropdownButton<String>(
//                     value: dropdownTimeSlot,
//                     items: validTimeSlots.map((slot) {
//                       return DropdownMenuItem<String>(
//                         value: slot,
//                         child: Text(
//                           slot,
//                           style: robotoRegular.copyWith(fontSize: 12),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         controller.updateTimeSlotFilter(value);
//                       }
//                     },
//                     underline: const SizedBox(),
//                     style: robotoRegular.copyWith(
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(width: 8),
//
//                 // Service Type Dropdown
//                 Container(
//                   height: 38,
//                   width: 80,
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   decoration: _dropdownDecoration(context),
//                   child: DropdownButton<String>(
//                     value: dropdownServiceType,
//                     isExpanded: true,
//                     underline: const SizedBox(),
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       size: 18,
//                       color: Theme.of(context).textTheme.bodyLarge!.color,
//                     ),
//                     items: validServiceTypes.map((String type) {
//                       return DropdownMenuItem<String>(
//                         value: type,
//                         child: Text(
//                           type.tr,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Theme.of(context).textTheme.bodyLarge!.color,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         controller.updateServiceTypeFilter(value);
//                       }
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(width: 8),
//
//                 // Date Picker Button
//                 Container(
//                   height: 35,
//                   width: 35,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).cardColor,
//                     border: Border.all(
//                       color: Theme.of(context).hintColor.withOpacity(0.1),
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(
//                       Icons.calendar_today,
//                       size: 20,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     onPressed: () async {
//                       final DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime(2030),
//                         builder: (context, child) {
//                           return Theme(
//                             data: Theme.of(context).copyWith(
//                               colorScheme: ColorScheme.light(
//                                 primary: Theme.of(context).primaryColor,
//                                 onPrimary: Colors.white,
//                                 onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       // if (picked != null) {
//                       //   controller.updateSelectedDate(picked);
//                       // }   /////////
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   double get maxExtent => 56;
//
//   @override
//   double get minExtent => 56;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
//
//   BoxDecoration _dropdownDecoration(BuildContext context) {
//     return BoxDecoration(
//       color: Theme.of(context).cardColor,
//       border: Border.all(
//         color: Theme.of(context).hintColor.withOpacity(0.1),
//         width: 1,
//       ),
//       borderRadius: BorderRadius.circular(6),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 3,
//           offset: const Offset(0, 1),
//         ),
//       ],
//     );
//   }
// }
