import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';



class BookingDetailsWidget extends StatefulWidget{
  final String? bookingId;
  final bool isSubBooking;
  const BookingDetailsWidget({super.key, this.bookingId, required this.isSubBooking}) ;

  @override
  State<BookingDetailsWidget> createState() => _BookingDetailsWidgetState();
}

class _BookingDetailsWidgetState extends State<BookingDetailsWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (bookingDetailsController){

        final bookingDetailsModel = bookingDetailsController.bookingDetails;
        final bookingDetails = bookingDetailsController.bookingDetails?.bookingContent?.bookingDetailsContent;

        bool showDeliveryConfirmImage = bookingDetailsController.showPhotoEvidenceField;
        ConfigModel? configModel = Get.find<SplashController>().configModel;

        int isGuest = bookingDetails?.isGuest ?? 0;
        bool isPartial =  (bookingDetails !=null && bookingDetails.partialPayments !=null && bookingDetails.partialPayments!.isNotEmpty) ? true : false ;
        String bookingStatus = bookingDetails?.bookingStatus ?? "";
        bool subBookingPaid = widget.isSubBooking && bookingDetails?.isPaid == 1;

        return bookingDetailsModel == null && bookingDetailsModel?.bookingContent == null ? const BookingDetailsShimmer() :
        bookingDetailsModel != null && bookingDetailsModel.bookingContent == null ? SizedBox(height: Get.height * 0.7, child:  BookingEmptyScreen (bookingId: widget.bookingId ?? "",)): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SingleChildScrollView(
             // scrollDirection: Axis.vertical,
              controller: bookingDetailsController.scrollController,
              child: Column(
                children: [
                  const SizedBox(height:Dimensions.paddingSizeSmall),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withValues(alpha:Get.isDarkMode?0.5:1),
                      boxShadow: Get.find<ThemeController>().darkTheme ? null : shadow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text(
                              '${"booking".tr} # ${bookingDetails?.readableId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: robotoMediumHigh.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                            ),

                            if(widget.isSubBooking) Container(
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: const Icon(Icons.repeat, color: Colors.white,size: 10,),
                            )
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                          (bookingDetails?.bookingStatus!="canceled")?
                          GestureDetector(
                            onTap: () async {
                              _checkPermission(() async {
                                if(bookingDetails?.serviceAddress != null){
                                  Get.dialog(const CustomLoader(),barrierDismissible: false);
                                  await Geolocator.getCurrentPosition().then((position) {
                                    MapUtils.openMap(
                                      double.tryParse(bookingDetails?.serviceAddress?.lat ?? "0") ?? 23.8103,
                                      double.tryParse(bookingDetails?.serviceAddress?.lon ?? "0") ?? 90.4125,
                                      position.latitude , position.longitude,
                                    );
                                  });
                                  Get.back();
                                }else{
                                  showCustomSnackBar("service_address_not_found".tr, type: ToasterMessageType.info);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault,
                                  vertical: Dimensions.paddingSizeExtraSmall+2
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                  color:Colors.grey.withValues(alpha:0.2)
                              ),
                              child: Center(
                                child: Text("view_on_map".tr,
                                  style:robotoMediumLow.copyWith(
                                    color: ColorResources.buttonTextColorMap['accepted'],
                                  ),
                                ),
                              ),
                            ),
                          ): Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeExtraSmall
                            ),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                color:Colors.grey.withValues(alpha:0.2)
                            ),
                            child: Center(
                              child: Text("canceled".tr,
                                style:robotoMediumLow.copyWith(
                                  color: ColorResources.buttonTextColorMap['canceled'],
                                ),
                              ),
                            ),
                          )
                        ]),

                        //Balu

                        // if(configModel?.content?.serviceManCanEditBooking == 1 && bookingDetailsController.bookingDetails?.bookingContent?.providerServicemanCanEditBooking == 1)
                        // Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        //   child: CustomButton(height: 35,btnTxt: "edit_booking".tr, icon: Icons.edit,
                        //     onPressed: (!subBookingPaid &&
                        //         !isPartial &&
                        //         (bookingStatus == "accepted" || bookingStatus == "ongoing") &&
                        //         ((isGuest == 1 && bookingDetails?.paymentMethod != "cash_after_service") ? false : true) &&
                        //         (bookingDetails?.categoryId == '274ceb96-647d-4fd5-8f66-c813fc2d51d6') // <-- Add this check
                        //       )
                        //       ? () {
                        //           Get.to(() => BookingEditScreen(isSubBooking: widget.isSubBooking));
                        //         }
                        //       : null,
                        //     fontSize: Dimensions.fontSizeSmall
                        //     ,),
                        // )),

                        // Column( children: [
                        //   CustomButton(
                        //     height: 35, width: 75, fontSize: Dimensions.fontSizeSmall, btnTxt: "invoice".tr,
                        //     onPressed: () async {
                        //       Get.dialog(const CustomLoader(), barrierDismissible: false);
                        //       String languageCode = Get.find<LocalizationController>().locale.languageCode;
                        //       String uri = "${AppConstants.baseUrl}${widget.isSubBooking ? AppConstants.singleRepeatBookingInvoiceUrl : AppConstants.regularBookingInvoiceUrl}${bookingDetails?.id}/$languageCode";
                        //       if (kDebugMode) {
                        //         print("Uri : $uri");
                        //       }
                        //       await _launchUrl(Uri.parse(uri));
                        //       Get.back();
                        //     },
                        //   ),
                        // ])     /// Balu
                    ]
                      ),
                      if(bookingDetails?.bookingStatus != "canceled")
                        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                          child: RichText(text:  TextSpan(text: '${'booking_status'.tr}:   ',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault-1,
                                color:Theme.of(context).textTheme.bodyLarge!.color,),
                              children: [
                                TextSpan(text: bookingDetails?.bookingStatus!.tr,
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault-1,
                                        color: ColorResources.buttonTextColorMap[bookingDetails?.bookingStatus],
                                        decoration: TextDecoration.none)
                                ),
                              ]),
                          ),
                        ),

                      BookingInformationView(bookingDetails: bookingDetails!, isSubBooking: widget.isSubBooking,),

                    ]),
                  ),
                  BookingDetailsCustomerInfo(bookingDetails: bookingDetails), ////review   Rani


                  BookingSummeryView(bookingDetails: bookingDetails),


                  BookingDetailsProviderInfo(bookingDetails: bookingDetails),   ///////rivew  service man reviwe




                  bookingDetails.photoEvidenceFullPath != null &&  bookingDetails.photoEvidenceFullPath!.isNotEmpty ?
                  Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Text('completed_service_picture'.tr,  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha:0.05),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: ListView.builder(
                          controller: bookingDetailsController.completedServiceImagesScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount:  bookingDetails.photoEvidenceFullPath?.length,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: bookingDetails.photoEvidenceFullPath?[index] ?? "",
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(ImageDetailScreen(
                                        imageList: bookingDetails.photoEvidenceFullPath ?? [],
                                        index: index,
                                        appbarTitle: 'completed_service_picture'.tr,

                                      ),
                                      );
                                    },
                                    child: CustomImage(
                                      image: bookingDetails.photoEvidenceFullPath?[index]??"",
                                      height: 70, width: 120,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ):
                  const SizedBox(),

                  Get.find<SplashController>().configModel?.content?.bookingImageVerification == 1 && showDeliveryConfirmImage && bookingDetails.bookingStatus != 'completed' ? Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('completed_service_picture'.tr,  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha:0.05),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: bookingDetailsController.pickedPhotoEvidence.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == bookingDetailsController.pickedPhotoEvidence.length ? null : bookingDetailsController.pickedPhotoEvidence[index];
                            if(index < 5 && index == bookingDetailsController.pickedPhotoEvidence.length) {
                              return InkWell(
                                onTap: () {
                                  Get.bottomSheet(CameraButtonSheet(bookingId: bookingDetails.id ?? "", isSubBooking: widget.isSubBooking,));
                                },
                                child: Container(
                                  height: 60, width: 70, alignment: Alignment.center, decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                                ),
                                  child:  Icon(Icons.camera_alt_sharp, color: Theme.of(context).primaryColor, size: 32),
                                ),
                              );
                            }
                            return file != null ? Container(
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: GetPlatform.isWeb ? Image.network(
                                    file.path, width: 120, height: 70, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(file.path), width: 120, height: 70, fit: BoxFit.cover,
                                  ),
                                ),
                              ]),
                            ) : const SizedBox();
                          },
                        ),
                      ),
                    ]),
                  ) : const SizedBox(),

                  const SizedBox(height:Dimensions.paddingSizeExtraLarge),
                ],
              ),
            ),),
            bookingDetails.bookingStatus == "accepted" ||  bookingDetails.bookingStatus == "ongoing" ?
            SafeArea(child: StatusChangeDropdownButton(bookingId: bookingDetails.id??"",bookingDetails: bookingDetails ,isSubBooking: widget.isSubBooking,)): const SizedBox(),
          ],
        );
      },
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude'
        '&destination=$destinationLatitude,$destinationLongitude&mode=d';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class BookingEmptyScreen extends StatelessWidget {
  final String? bookingId;
  const BookingEmptyScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      Image.asset(Images.noResults, height: Get.height * 0.1, color: Theme.of(context).primaryColor,),
      const SizedBox(height: Dimensions.paddingSizeLarge,),
      Text("information_not_found".tr, style: robotoRegular,),
      const SizedBox(height: Dimensions.paddingSizeLarge,),

      CustomButton(
        height: 35, width: 120, radius: Dimensions.radiusExtraLarge,
        btnTxt: "go_back".tr, onPressed: () {
        //Get.find<BookingRequestController>().removeBookingItemFromList(bookingId ?? "", shouldUpdate: true , bookingStatus: "");
        Get.back();
      },)

    ],),);
  }
}









