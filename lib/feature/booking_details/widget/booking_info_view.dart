// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:demandium_serviceman/feature/booking_details/model/booking_details_model.dart';
//
// class BookingInformationView extends StatelessWidget {
//   final BookingDetailsContent bookingDetails;
//   final bool isSubBooking;
//   final IconData? icon;
//   final String? subTitle;
//   const BookingInformationView({super.key,this.subTitle, this.icon,required this.bookingDetails, required this.isSubBooking}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     return  GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){
//
//       return Column(crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Expanded(
//               child: Row(children: [
//                 Text(
//                   '${'booking'.tr} # ${bookingDetails.readableId}',
//                   overflow: TextOverflow.ellipsis,
//                   style: robotoBold.copyWith(
//                     fontSize: Dimensions.fontSizeLarge,
//                     color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.9),
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//                 if (isSubBooking)
//                   Container(
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
//                     padding: const EdgeInsets.all(2),
//                     margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
//                     child: const Icon(Icons.repeat, color: Colors.white, size: 12),
//                   ),
//               ]),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: Dimensions.paddingSizeDefault,
//                 vertical: Dimensions.paddingSizeExtraSmall,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: Get.isDarkMode
//                     ? Colors.grey.withOpacity(0.2)
//                     : ColorResources.buttonBackgroundColorMap[bookingDetails.bookingStatus],
//               ),
//               child: Center(
//                 child: Text(
//                   bookingDetails.bookingStatus?.tr ?? "",
//                   style: robotoMedium.copyWith(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: Get.isDarkMode
//                         ? Theme.of(context).primaryColorLight
//                         : ColorResources.buttonTextColorMap[bookingDetails.bookingStatus],
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//
//           const SizedBox(height: Dimensions.paddingSizeDefault),
//
//           BookingItem(
//             icon: Icons.calendar_month,
//             //img: Images.iconCalendar,
//             title: '${'booking_date'.tr} : ',
//             subTitle: DateConverter.dateMonthYearTime(
//               DateConverter.isoUtcStringToLocalDate(bookingDetails.createdAt!),
//             ),
//           ),
//
//           if (bookingDetails.serviceSchedule != null) const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//
//           if (bookingDetails.serviceSchedule != null)
//             BookingItem(
//               icon: Icons.calendar_view_month,
//               //img: Images.iconCalendar,
//               title: '${'scheduled_date'.tr} : ',
//               subTitle: ' ${DateConverter.dateMonthYearTime(DateTime.tryParse(bookingDetails.serviceSchedule!))}',
//             ),
//
//           if (bookingDetails.slot != null)
//             BookingItem(
//               icon: Icons.access_time,
//
//               title: '${'Slot'.tr} : ',
//               subTitle: ' ${(bookingDetails.slot!)}',
//             ),
//
//
//           // Example for vehicle details section
//           if (bookingDetails.vehicle != null) ...[
//             const SizedBox(height: Dimensions.paddingSizeSmall),
//             Text(
//               "vehicle_information".tr,
//               style: robotoBold.copyWith(
//                 fontSize: Dimensions.fontSizeDefault,
//                 color: Theme.of(context).textTheme.bodyLarge!.color,
//               ),
//             ),
//             const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//             BookingItem(
//               icon: Icons.directions_car,
//               title: "${'vehicle_model'.tr} : ",
//               subTitle: bookingDetails.vehicle?.model ?? "",
//             ),
//             BookingItem(
//               icon: Icons.palette,
//               title: "${'vehicle_color'.tr} : ",
//               subTitle: bookingDetails.vehicle?.color ?? "",
//             ),
//             BookingItem(
//               icon: Icons.confirmation_number,
//               title: "${'vehicle_number'.tr} : ",
//               subTitle: bookingDetails.vehicle?.vehicleNo ?? "",
//             ),
//             GestureDetector(
//               onTap: () async {
//                 final number = bookingDetails.vehicle?.contactNo;
//                 if (number != null && number.isNotEmpty) {
//                   final uri = Uri.parse("tel:$number");
//                   if (await canLaunchUrl(uri)) {
//                     await launchUrl(uri, mode: LaunchMode.externalApplication);
//                   }
//                 }
//               },
//               child: BookingItem(
//                 icon: Icons.phone,
//                 title: "${'contact_number'.tr} : ",
//                 subTitle: bookingDetails.vehicle?.contactNo ?? "",
//               ),
//             ),
//             BookingItem(
//               icon: Icons.info_outline,
//               title: "${'additional_details'.tr} : ",
//               subTitle: bookingDetails.vehicle?.additionalDetails ?? "",
//             ),
//           ],
//
//           BookingItem(
//             icon: Icons.location_city,
//             //img: Images.iconLocation,
//             title: '${'service_address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'address_not_found'.tr
//
//             }',
//             date: '', subTitle: '',
//           ),
//           const SizedBox(height:Dimensions.paddingSizeDefault),
//           Text("payment_method".tr,
//             style: robotoBold.copyWith(
//                 fontSize: Dimensions.fontSizeDefault,
//                 color: Theme.of(context).textTheme.bodyLarge!.color),
//           ),
//           const SizedBox(height:Dimensions.paddingSizeExtraSmall),
//
//           Text("${bookingDetails.paymentMethod!.tr} ${ bookingDetails.partialPayments !=null  && bookingDetails.partialPayments!.isNotEmpty ? "&_wallet_balance".tr: ""}",
//               style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:.5))),
//           const SizedBox(height:Dimensions.paddingSizeExtraSmall),
//
//           (bookingDetails.paymentMethod !="cash_after_service" && bookingDetails.paymentMethod !="offline_payment") ?
//           Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeExtraSmall),
//             child: Text("${'transaction_id'.tr} : ${bookingDetails.transactionId}",
//               style: robotoRegular.copyWith(
//                 fontSize: Dimensions.fontSizeSmall,
//                 color: Theme.of(context).hintColor,
//               ),
//             ),
//           ):const SizedBox.shrink(),
//
//           Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
//             child: RichText(
//               text: TextSpan(text: "${'payment_status'.tr} : ",
//                 style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: bookingDetails.partialPayments != null && bookingDetails.partialPayments!.isNotEmpty && bookingDetails.isPaid == 0 ? "partially_paid".tr :  bookingDetails.isPaid == 0 ? "unpaid".tr : "paid".tr,
//                     style: robotoBold.copyWith(
//                       fontSize: Dimensions.fontSizeDefault,
//                       color: bookingDetails.partialPayments != null && bookingDetails.partialPayments!.isNotEmpty && bookingDetails.isPaid == 0 ? Theme.of(context).primaryColor : bookingDetails.isPaid == 0 ?
//                       Theme.of(context).colorScheme.error: Colors.green,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//           Row(
//             children: [
//               Text("${'amount'.tr} : ",
//                 style: robotoBold.copyWith(
//                   fontSize: Dimensions.fontSizeSmall,
//                   color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
//                 ),
//               ),
//
//               Text(PriceConverter.convertPrice(bookingDetails.totalBookingAmount ?? 0,isShowLongPrice:true),
//                 style: robotoBold.copyWith(
//                   fontSize: Dimensions.fontSizeSmall,
//                   color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
// }



import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/booking_details/model/booking_details_model.dart';

import '../../booking_request/view/new_booking_list_screen.dart';
import '../model/booking_details_model.dart';

class BookingInformationView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;
  final IconData? icon;
  final String? subTitle;
  const BookingInformationView({super.key,this.subTitle, this.icon,required this.bookingDetails, required this.isSubBooking}) ;

  @override
  Widget build(BuildContext context) {

    final bookingController = Get.put(BookingController());

    final expiryDate = bookingDetails.endDate ?? "";



    print("Expiry Date: $expiryDate");
    print("BookingResponse: ${bookingController.bookingResponse}");
    print("Content: ${bookingController.bookingResponse?.content}");
    print("Bookings: ${bookingController.bookingResponse?.content?.bookings}");
    print("Data: ${bookingController.bookingResponse?.content?.bookings?.data}");


    return  GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){

      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Row(children: [
                Text(
                  '${'Booking'.tr} # ${bookingDetails.readableId}',
                  overflow: TextOverflow.ellipsis,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.9),
                    decoration: TextDecoration.none,
                  ),
                ),
                if (isSubBooking)
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: const Icon(Icons.repeat, color: Colors.white, size: 12),
                  ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Get.isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : ColorResources.buttonBackgroundColorMap[bookingDetails.bookingStatus],
              ),
              child: Center(
                child: Text(
                  bookingDetails.bookingStatus?.tr ?? "",
                  style: robotoMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Get.isDarkMode
                        ? Theme.of(context).primaryColorLight
                        : ColorResources.buttonTextColorMap[bookingDetails.bookingStatus],
                  ),
                ),
              ),
            ),
          ]),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          BookingItem(
            icon: Icons.calendar_month,
            //img: Images.iconCalendar,
            title: '${'Booking Date'.tr} : ',
            subTitle: DateConverter.dateMonthYearTime(
              DateConverter.isoUtcStringToLocalDate(bookingDetails.createdAt!),
            ),
          ),

          if (bookingDetails.serviceSchedule != null) const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          if (bookingDetails.serviceSchedule != null)
            BookingItem(
              icon: Icons.calendar_view_month,
              //img: Images.iconCalendar,
              title: '${'Scheduled Date'.tr} : ',
              subTitle: ' ${DateConverter.dateMonthYearTime(DateTime.tryParse(bookingDetails.serviceSchedule!))}',
            ),

          if (bookingDetails.slot != null)
            BookingItem(
              icon: Icons.access_time,

              title: '${'Slot'.tr} : ',
              subTitle: ' ${(bookingDetails.slot!)}',
            ),


          // Example for vehicle details section
          if (bookingDetails.vehicle != null) ...[
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              "Vehicle Information".tr,
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            BookingItem(
              icon: Icons.directions_car,
              title: "${'Vehicle Model'.tr} : ",
              subTitle: bookingDetails.vehicle?.model ?? "",
            ),
            SizedBox(height: 3,),
            BookingItem(
              icon: Icons.palette,
              title: "${'Vehicle Color'.tr} : ",
              subTitle: bookingDetails.vehicle?.color ?? "",
            ),
            SizedBox(height: 3,),
            BookingItem(
              icon: Icons.confirmation_number,
              title: "${'Vehicle Number'.tr} : ",
              subTitle: bookingDetails.vehicle?.vehicleNo ?? "",
            ),
            // BookingItem(
            //   icon: Icons.phone,
            //   // title: "${'contact_numberrrrrrrrrr'.tr} : ",
            //   subTitle: bookingDetails.ServiceAddress?.contactPersonNumber ?? "",
            // ),

            SizedBox(height: 3,),


            (expiryDate != null && expiryDate.isNotEmpty)
                ? BookingItem(
              icon: Icons.confirmation_number,
              title: "${'Expiry Date'.tr} : ",
              subTitle: expiryDate,
            )
                : SizedBox.shrink(),

            SizedBox(height: 3),


            BookingItem(
              icon: Icons.phone,
              title: 'Contact Number'.tr,
              subTitle: (bookingDetails.vehicle?.contactNo != null &&
                  bookingDetails.vehicle!.contactNo!.trim().length >=6)
                  ? bookingDetails.vehicle!.contactNo!
                  : bookingDetails.serviceAddress?.contactPersonNumber ??
                  bookingDetails.subBooking?.serviceAddress?.contactPersonNumber ??
                  'contact_number_not_found'.tr,
            ),


            SizedBox(height: 3,),

            (bookingDetails.subCategoryId != '01c87dde-f46a-4b9c-b852-2de93d804ac7' &&
                bookingDetails.vehicle?.additionalDetails != null &&
                bookingDetails.vehicle!.additionalDetails!.isNotEmpty)
                ? BookingItem(
              icon: Icons.info_outline,
              title: "${'Additional Details'.tr} : ",
              subTitle: bookingDetails.vehicle!.additionalDetails!,
            )
                : SizedBox.shrink(),

          ],

          SizedBox(height: 3,),

          BookingItem(
            icon: Icons.location_city,
            title: 'Service Address'.tr,
            subTitle: bookingDetails.serviceAddress?.address ??
                bookingDetails.subBooking?.serviceAddress?.address ??
                'address_not_found'.tr,
            date: '', // optional
          ),

          const SizedBox(height:Dimensions.paddingSizeDefault),
          Text("Payment Method".tr,
            style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          const SizedBox(height:Dimensions.paddingSizeExtraSmall),

          Text("${bookingDetails.paymentMethod!.tr} ${ bookingDetails.partialPayments !=null  && bookingDetails.partialPayments!.isNotEmpty ? "&_wallet_balance".tr: ""}",
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:.5))),
          const SizedBox(height:Dimensions.paddingSizeExtraSmall),

          (bookingDetails.paymentMethod !="cash_after_service" && bookingDetails.paymentMethod !="offline_payment") ?
          Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeExtraSmall),
            child: Text("${'Transaction Id'.tr} : ${bookingDetails.transactionId}",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            ),
          ):const SizedBox.shrink(),

          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
            child: RichText(
              text: TextSpan(text: "${'Payment Status'.tr} : ",
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                children: <TextSpan>[
                  TextSpan(
                    text: bookingDetails.partialPayments != null && bookingDetails.partialPayments!.isNotEmpty && bookingDetails.isPaid == 0 ? "partially_paid".tr :  bookingDetails.isPaid == 0 ? "unpaid".tr : "paid".tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: bookingDetails.partialPayments != null && bookingDetails.partialPayments!.isNotEmpty && bookingDetails.isPaid == 0 ? Theme.of(context).primaryColor : bookingDetails.isPaid == 0 ?
                      Theme.of(context).colorScheme.error: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ),

          Row(
            children: [
              Text("${'amount'.tr} : ",
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
                ),
              ),

              Text(PriceConverter.convertPrice(bookingDetails.totalBookingAmount ?? 0,isShowLongPrice:true),
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}