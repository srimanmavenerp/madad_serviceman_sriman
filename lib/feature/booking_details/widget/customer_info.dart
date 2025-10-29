// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:get/get.dart';
//
// class BookingDetailsCustomerInfo extends StatelessWidget {
//   final BookingDetailsContent bookingDetails;
//   const BookingDetailsCustomerInfo({super.key, required this.bookingDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<BookingDetailsController>(
//       builder: (bookingDetailsController) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor.withValues(alpha: 0.5),
//             boxShadow:
//                 Get.find<ThemeController>().darkTheme ? null : lightShadow,
//           ),
//           margin:
//               const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
//           padding: const EdgeInsets.symmetric(
//               vertical: Dimensions.paddingSizeDefault,
//               horizontal: Dimensions.paddingSizeDefault),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (bookingDetails.cusRev != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: Dimensions.paddingSizeSmall),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color:
//                           Theme.of(context).cardColor, // card-like background
//                       borderRadius:
//                           BorderRadius.circular(Dimensions.radiusDefault),
//                       boxShadow: Get.find<ThemeController>().darkTheme
//                           ? null
//                           : lightShadow, // Optional box shadow for non-dark theme
//                     ),
//                     padding:
//                         const EdgeInsets.all(Dimensions.paddingSizeDefault),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Customer Review:'.tr, // Label for the review
//                           style: robotoMedium.copyWith(
//                             fontSize: Dimensions.fontSizeDefault,
//                             color: Colors.black, // Black color for label text
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         Text(
//                           bookingDetails.cusRev?.tr ??
//                               'No Review Available'
//                                   .tr, // Review text or fallback
//                           style: robotoRegular.copyWith(
//                             fontSize: Dimensions.fontSizeDefault,
//                             color: Colors.black, // Black color for review text
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               // Show review if exists
//               if (bookingDetails.smanReview != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: Dimensions.paddingSizeSmall),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color:
//                           Theme.of(context).cardColor, // card-like background
//                       borderRadius:
//                           BorderRadius.circular(Dimensions.radiusDefault),
//                       boxShadow: Get.find<ThemeController>().darkTheme
//                           ? null
//                           : lightShadow, // Optional box shadow for non-dark theme
//                     ),
//                     padding:
//                         const EdgeInsets.all(Dimensions.paddingSizeDefault),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Review:'.tr, // Label for the review
//                           style: robotoMedium.copyWith(
//                             fontSize: Dimensions.fontSizeDefault,
//                             color: Colors.black, // Black color for label text
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         Text(
//                           bookingDetails.smanReview?.tr ??
//                               'No Review Available'
//                                   .tr, // Review text or fallback
//                           style: robotoRegular.copyWith(
//                             fontSize: Dimensions.fontSizeDefault,
//                             color: Colors.black, // Black color for review text
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               // Show review section if the status is "completed"
//               if (bookingDetails.bookingStatus == "completed")
//                 if (bookingDetails.smanReview == null)
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Add Review'.tr,
//                           style: robotoMedium.copyWith(
//                             fontSize: Dimensions.fontSizeDefault,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         // Review input field
//                         TextField(
//                           controller: bookingDetailsController.review,
//                           decoration: InputDecoration(
//                             hintText: "Write Review".tr,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   Dimensions.radiusDefault),
//                             ),
//                           ),
//                           maxLines: 4,
//                         ),
//                         const SizedBox(height: Dimensions.paddingSizeSmall),
//                         // Submit button
//                         CustomButton(
//                           btnTxt: "Submit".tr,
//                           onPressed: () async {
//                             if (bookingDetailsController
//                                 .review.text.isNotEmpty) {
//                               // Submit the review
//                               await bookingDetailsController.serviceReview(
//                                 bookingDetails.id!,
//                                 bookingDetailsController.review.text,
//                               );
//
//                               // Clear the review text field after submission
//                               bookingDetailsController.review.clear();
//
//                               // Show success message
//                               showCustomSnackBar("review_submitted".tr,
//                                   type: ToasterMessageType.success);
//
//                               // Trigger UI update (to show the new review, if necessary)
//                               bookingDetailsController.update();
//                             } else {
//                               showCustomSnackBar("Please Write a Review".tr,
//                                   type: ToasterMessageType.info);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//               Text(
//                 "customer_info".tr,
//                 style: robotoMedium.copyWith(
//                     fontSize: Dimensions.fontSizeDefault,
//                     color: Theme.of(context).primaryColor),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeDefault),
//               BottomCard(
//                 name: bookingDetails.serviceAddress?.contactPersonName ??
//                     bookingDetails
//                         .subBooking?.serviceAddress?.contactPersonName ??
//                     "${bookingDetails.customer?.firstName ?? ""} ${bookingDetails.customer?.lastName ?? ""}",
//                 phone: bookingDetails.serviceAddress?.contactPersonNumber ??
//                     bookingDetails
//                         .subBooking?.serviceAddress?.contactPersonNumber ??
//                     bookingDetails.customer?.phone ??
//                     bookingDetails.customer?.email ??
//                     "",
//                 image: bookingDetails.customer?.profileImageFullPath ??
//                     bookingDetails.subBooking?.customer?.profileImageFullPath ??
//                     "",
//                 address: bookingDetails.serviceAddress?.address ??
//                     bookingDetails.subBooking?.serviceAddress?.address ??
//                     'address_not_found'.tr,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// //   void showCustomSnackBar(String message, {ToasterMessageType type = ToasterMessageType.info}) {
// //     if (!Get.isSnackbarOpen) {
// //       Get.snackbar(
// //         '', // No title
// //         message,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: type == ToasterMessageType.success ? Colors.green : Colors.red,
// //         colorText: Colors.white,
// //         borderRadius: 10,
// //         margin: const EdgeInsets.all(10),
// //         duration: const Duration(seconds: 3),
// //       );
// //     }
// //   }
// }




import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/feature/booking_details/model/booking_details_model.dart';
class BookingDetailsCustomerInfo extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  const BookingDetailsCustomerInfo({super.key, required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (bookingDetailsController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.5),
            boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow,
          ),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeDefault,
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Combined Customer and Serviceman Review
              if (bookingDetails.cusRev != null || bookingDetails.smanReview != null)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow,
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Review
                      if (bookingDetails.cusRev != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Customer Review:'.tr,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                bookingDetails.cusRev?.tr ?? 'No Review Available'.tr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      // Serviceman Review
                      // if (bookingDetails.smanReview != null) ...[
                      //   if (bookingDetails.cusRev != null)
                      //     const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      //   Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Expanded(
                      //         flex: 2,
                      //         child: Text(
                      //           'Review:'.tr,
                      //           style: robotoMedium.copyWith(
                      //             fontSize: Dimensions.fontSizeDefault,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         flex: 3,
                      //         child: Text(
                      //           bookingDetails.smanReview?.tr ?? 'No Review Available'.tr,
                      //           style: robotoRegular.copyWith(
                      //             fontSize: Dimensions.fontSizeDefault,
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ],
                    ],
                  ),
                ),

              // Show review section if the status is "completed" and no serviceman review exists
              if (bookingDetails.bookingStatus == "completed" && bookingDetails.smanReview == null)
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Review'.tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      TextField(
                        controller: bookingDetailsController.review,
                        decoration: InputDecoration(
                          hintText: "Write Review".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      CustomButton(
                        btnTxt: "Submit".tr,
                        onPressed: () async {
                          if (bookingDetailsController.review.text.isNotEmpty) {
                            // await bookingDetailsController.serviceReview(
                            //   bookingDetails.id!,
                            //   bookingDetailsController.review.text,
                            // );
                            bookingDetailsController.review.clear();
                            showCustomSnackBar("review_submitted".tr, type: ToasterMessageType.success);
                            bookingDetailsController.update();
                          } else {
                            showCustomSnackBar("Please Write a Review".tr, type: ToasterMessageType.info);
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}