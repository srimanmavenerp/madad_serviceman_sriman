import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:demandium_serviceman/feature/booking_details/model/booking_details_model.dart';
class BookingDetailsProviderInfo extends StatelessWidget {

  final BookingDetailsContent bookingDetails;
  const BookingDetailsProviderInfo({super.key, required this.bookingDetails}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha:0.5),
          boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow
      ),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [

        Text("provider_info".tr,style:robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColorLight) ,
        ),
        const SizedBox(height:Dimensions.paddingSizeDefault),

        BottomCard(
          name: bookingDetails.provider?.companyName ??  bookingDetails.subBooking?.provider?.companyName ?? "",
          phone: bookingDetails.provider?.companyPhone ?? bookingDetails.subBooking?.provider?.companyPhone ?? "",
          image:  bookingDetails.provider?.logoFullPath ?? bookingDetails.subBooking?.provider?.logoFullPath ?? "",
        ),

        ////////////////////

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
                // if (bookingDetails.cusRev != null)
                //   Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Expanded(
                //         flex: 2,
                //         child: Text(
                //           'Customer Review:'.tr,
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
                //           bookingDetails.cusRev?.tr ?? 'No Review Available'.tr,
                //           style: robotoRegular.copyWith(
                //             fontSize: Dimensions.fontSizeDefault,
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // // Serviceman Review
                if (bookingDetails.smanReview != null) ...[
                  if (bookingDetails.cusRev != null)
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Review:'.tr,
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
                          bookingDetails.smanReview?.tr ?? 'No Review Available'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),


        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(
          "customer_info".tr,
          style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        BottomCard(
          name: bookingDetails.serviceAddress?.contactPersonName ??
              bookingDetails
                  .subBooking?.serviceAddress?.contactPersonName ??
              "${bookingDetails.customer?.firstName ?? ""} ${bookingDetails.customer?.lastName ?? ""}",
          phone: bookingDetails.serviceAddress?.contactPersonNumber ??
              bookingDetails
                  .subBooking?.serviceAddress?.contactPersonNumber ??
              bookingDetails.customer?.phone ??
              bookingDetails.customer?.email ??
              "",
          image: bookingDetails.customer?.profileImageFullPath ??
              bookingDetails.subBooking?.customer?.profileImageFullPath ??
              "",
          address: bookingDetails.serviceAddress?.address ??
              bookingDetails.subBooking?.serviceAddress?.address ??
              'address_not_found'.tr,
        ),




      ]),
    );
  }
}
