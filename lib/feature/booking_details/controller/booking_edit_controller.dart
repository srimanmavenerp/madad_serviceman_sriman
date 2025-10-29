


import '../model/booking_details_model.dart';
import 'dart:convert';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';

class RowData {
  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  RxInt quantity = 1.obs;
  TextEditingController discountController = TextEditingController(); // New: Discount value
  RxString discountType = 'none'.obs; // New: Discount type ('none', 'amount', 'percent')
}

class BookingEditController extends GetxController implements GetxService {
  final BookingDetailsRepo bookingDetailsRepo;
  BookingEditController({required this.bookingDetailsRepo});



  var textFieldList = <RowData>[].obs;

  void addTextFields() {
    textFieldList.add(RowData());
  }

  void removeTextField(int index) {
    textFieldList.removeAt(index);
  }

  void clearTextFields() {
    for (var row in textFieldList) {
      row.firstController.clear();
      row.secondController.clear();
      row.quantity.value = 1;
      row.discountController.clear();
      row.discountType.value = 'none';
    }
    textFieldList.clear();
  }

  void incrementTextFieldQuantity(int index) {
    textFieldList[index].quantity.value++;
  }

  void decrementTextFieldQuantity(int index) {
    if (textFieldList[index].quantity.value > 1) {
      textFieldList[index].quantity.value--;
    }
  }

  // RxList<Map<String, dynamic>> serviceData = <Map<String, dynamic>>[].obs;


  RxList<Map<String, dynamic>> serviceData = <Map<String, dynamic>>[].obs;
  bool _hasModifiedServices = false; // Track if user has modified services

  // void setServiceData(List<Map<String, dynamic>> data) {
  //   serviceData.clear();
  //   serviceData.addAll(data);
  //
  // }

  void setServiceData(List<Map<String, dynamic>> newData) {
    serviceData.clear();
    serviceData.addAll(newData);
  }
  void removeServiceData(int index) {
    serviceData.removeAt(index);
  }

  void resetServiceData() {
    serviceData.clear();
  }

  void appendServiceData(List<Map<String, dynamic>> newData) {
    serviceData.addAll(newData);
  }

  // void addServiceData(Map<String, dynamic> data) {
  //   // Calculate discounted price before adding
  //   double basePrice = double.tryParse(data['service_amount'].toString()) ?? 0;
  //   double? discount = double.tryParse(data['discount']?.toString() ?? '') ?? 0;
  //   String? discountType = data['discount_type'] != 'none' ? data['discount_type'] : null;
  //
  //   double discountedPrice = _calculateDiscountedPrice(basePrice, discount, discountType);
  //
  //   serviceData.add({
  //     'service_name': data['service_name'],
  //     'service_amount': discountedPrice.toString(), // Store discounted price
  //     'quantity': data['quantity'],
  //     'service_thumbnail': data['service_thumbnail'] ?? '',
  //     'discount': discount != 0 ? discount.toString() : null,
  //     'discount_type': discountType,
  //   });
  // }

  void addServiceData(Map<String, dynamic> data) {
    // Calculate discounted price
    double basePrice = double.tryParse(data['service_amount'].toString()) ?? 0;
    double? discount = double.tryParse(data['discount']?.toString() ?? '') ?? 0;
    String? discountType = data['discount_type'] != 'none' ? data['discount_type'] : null;

    double discountedPrice = _calculateDiscountedPrice(basePrice, discount, discountType);

    serviceData.add({
      'service_name': data['service_name'],
      'service_amount': discountedPrice.toString(),
      'quantity': data['quantity'] ?? '1',
      'service_thumbnail': data['service_thumbnail'] ?? '',
      'discount': discount != 0 ? discount.toString() : null,
      'discount_type': discountType ?? 'none',
    });
  }



  void incrementServiceQuantity(int index) {
    int quantity = int.parse(serviceData[index]['quantity'] ?? '1');
    serviceData[index]['quantity'] = (quantity + 1).toString();
    serviceData.refresh();
  }

  void decrementServiceQuantity(int index) {
    int quantity = int.parse(serviceData[index]['quantity'] ?? '1');
    if (quantity > 1) {
      serviceData[index]['quantity'] = (quantity - 1).toString();
      serviceData.refresh();
    }
  }

  // New: Calculate discounted price based on PriceConverter logic
  double _calculateDiscountedPrice(double price, double? discount, String? discountType) {
    if (discount != null && discountType != null && discount > 0) {
      if (discountType == 'amount') {
        price = price - discount;
      } else if (discountType == 'percent') {
        price = price - ((discount / 100) * price);
      }
    }
    return price < 0 ? 0 : price; // Ensure price is non-negative
  }

  @override
  void onInit() {
    super.onInit();
    initializedControllerValue(Get.find<BookingDetailsController>()
        .bookingDetails
        ?.bookingContent
        ?.bookingDetailsContent ??
        BookingDetailsContent());
    if (Get.find<SplashController>()
        .configModel
        ?.content
        ?.serviceManCanCancelBooking ==
        0 ||
        Get.find<SplashController>()
            .configModel
            ?.content
            ?.providerServicemanCanCancelBooking ==
            0) {
      statusTypeList.remove('canceled');
    }
  }

  final List<String> statusTypeList = [
    "ongoing",
    "completed",
    "canceled",
  ];

  String _bookingStatus = '';
  String get selectedBookingStatus => _bookingStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _statusUpdateLoading = false;
  bool get statusUpdateLoading => _statusUpdateLoading;

  String initialBookingStatus = 'pending';

  bool _isCartButtonActive = false;
  bool get isCartButtonActive => _isCartButtonActive;

  bool _paymentStatusPaid = true;
  bool get paymentStatusPaid => _paymentStatusPaid;

  String? _scheduleTime;
  String? get scheduleTime => _scheduleTime;

  String? _previousScheduleTime;

  BookingDetailsContent? _bookingDetailsContent;
  BookingDetailsContent? get bookingDetailsContent => _bookingDetailsContent;

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  List<ServiceModel>? _serviceList;
  List<ServiceModel>? get serviceList => _serviceList;

  List<BookingPriceItem>? bookingPriceList;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  TimeOfDay _selectedTimeOfDay = TimeOfDay.now();
  TimeOfDay get selectedTimeOfDay => _selectedTimeOfDay;

  get bookingDetails => null;

  void initializedControllerValue(BookingDetailsContent? bookingDetailsContent,
      {bool shouldUpdate = true}) {
    initialBookingStatus = bookingDetailsContent?.bookingStatus ?? "";
    _paymentStatusPaid = bookingDetailsContent?.isPaid == 1 ? true : false;

    _bookingStatus = bookingDetailsContent?.bookingStatus ?? "";
    _scheduleTime = bookingDetailsContent?.serviceSchedule;
    _previousScheduleTime = bookingDetailsContent?.serviceSchedule;
    serviceData.clear();

    _initializedCartValue(
        bookingDetailsContent?.details, bookingDetailsContent);

    if (bookingDetailsContent?.serviceData != null) {
      List<Map<String, dynamic>> serverData = bookingDetailsContent!.serviceData!
          .map((e) => e.toJson())
          .toList();
      List<Map<String, dynamic>> mergedData = [];
      for (var serverItem in serverData) {
        var existingItem = serviceData.firstWhereOrNull(
                (item) =>
            item['service_name'] == serverItem['service_name'] &&
                item['service_amount'] == serverItem['service_amount']);
        double basePrice =
            double.tryParse(serverItem['service_amount'].toString()) ?? 0;
        double? discount =
            double.tryParse(serverItem['discount']?.toString() ?? '') ?? 0;
        String? discountType =
        serverItem['discount_type'] != 'none' ? serverItem['discount_type'] : null;
        double discountedPrice = _calculateDiscountedPrice(basePrice, discount, discountType);

        mergedData.add({
          'service_name': serverItem['service_name'],
          'service_amount': discountedPrice.toString(),
          'quantity': existingItem != null
              ? existingItem['quantity']
              : serverItem['quantity'] ?? '1',
          'service_thumbnail': serverItem['service_thumbnail'] ?? '',
          'discount': discount != 0 ? discount.toString() : null,
          'discount_type': discountType,
        });
      }
      setServiceData(mergedData);
    }

    if (shouldUpdate) {
      update();
    }
  }

  void _initializedCartValue(List<ItemService>? bookedCartList,
      BookingDetailsContent? bookingDetailsContent) {
    _cartList = [];
    bookedCartList?.forEach((element) {
      CartModel cartModel = CartModel(
        id: "",
        isNewItem: false,
        serviceId: element.serviceId,
        variantKey: element.variantKey,
        serviceName: element.serviceName,
        quantity: element.quantity,
        serviceThumbnail: element.service?.thumbnailFullPath ?? "",
        serviceCost: element.serviceCost,
        totalCost: (element.totalCost ?? 0) -
            (element.overallCouponDiscountAmount ?? 0),
        taxAmount: element.taxAmount,
        campaignDiscountAmount: element.campaignDiscountAmount,
        discountAmount: element.discountAmount,
      );
      _cartList.add(cartModel);
    });
  }


  void replaceAllServices(List<Map<String, dynamic>> newServices) {
    serviceData.clear();
    serviceData.addAll(newServices);
    _hasModifiedServices = true; // Mark that services have been modified
    update();
  }
  bool shouldShowExistingServices() {
    return !_hasModifiedServices && serviceData.isNotEmpty;
  }

 /* Future<void> getServiceListBasedOnSubcategory(
      {required String subCategoryId})
  async {
    Response response = await bookingDetailsRepo
        .getServiceListBasedOnSubcategory(subCategoryId);
    if (response.statusCode == 200) {
      List<dynamic> list = response.body['content']['data'];
      _serviceList = [];
      for (var service in list) {
        _serviceList?.add(ServiceModel.fromJson(service));
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }*/


  Future<void> getServiceListBasedOnSubcategory(
      {required String subCategoryId}) async {
    Response response = await bookingDetailsRepo
        .getServiceListBasedOnSubcategory(subCategoryId);
    if (response.statusCode == 200) {
      List<dynamic> list = response.body['content']['data'];
      _serviceList = [];
      for (var service in list) {
        _serviceList?.add(ServiceModel.fromJson(service));
      }
    } else {
      // ApiChecker.checkApi(response);  //Balu
    }
    update();
  }
  Future<void> removeCartServiceFromServer(
      {CartModel? cart, String? bookingId, String? zoneId}) async {
    Response response = await bookingDetailsRepo.removeCartServiceFromServer(
        cart: cart, bookingId: bookingId, zoneId: zoneId);
    if (response.statusCode == 200) {
      _cartList.remove(cart);
    }
    update();
  }

  Future<void> updateBooking(

      {String? bookingId,
        String? subBookingId,
        String? zoneId,
        required bool isSubBooking}) async {
    _statusUpdateLoading = true;
    update();



    List<Map<String, String?>> updatedBookedServiceList = [];
    for (var element in _cartList) {
      updatedBookedServiceList.add({
        "service_id": element.serviceId,
        "variant_key": element.variantKey,
        "quantity": element.quantity.toString(),
      });
    }

    List<Map<String, String>> dynamicTextFieldData = serviceData
        .map((data) => {
      "service_name": data["service_name"].toString(),
      "service_amount": data["service_amount"].toString(),
      "quantity": data["quantity"].toString(),
      "service_thumbnail": data["service_thumbnail"].toString(),
      "discount": data["discount"]?.toString() ?? '',
      "discount_type": data["discount_type"]?.toString() ?? 'none',
    })
        .toList();

    Response response = await bookingDetailsRepo.updateBooking(
      bookingId: bookingId,
      subBookingId: subBookingId,
      zoneId: zoneId,
      paymentStatus: paymentStatusPaid ? "1" : "0",
      isSubBooking: isSubBooking,
      bookingStatus: _bookingStatus,
      serviceSchedule: _scheduleTime,
      serviceInfo: jsonEncode(updatedBookedServiceList),
      serviceData: jsonEncode({"data": dynamicTextFieldData}),
    );

    if (response.statusCode == 200) {
      await Get.find<BookingDetailsController>().getBookingDetails(
        bookingID: subBookingId ?? bookingId ?? "",
        isSubBooking: isSubBooking,
      );
      initializedControllerValue(
        Get.find<BookingDetailsController>().bookingDetails?.bookingContent?.bookingDetailsContent,
      );
      showCustomSnackBar(response.body['message'].toString().capitalizeFirst,
          type: ToasterMessageType.success);
    } else {
      ApiChecker.checkApi(response);
    }
    _statusUpdateLoading = false;
    update();
  }

  void addCartItem(CartModel cartModel) {
    bool availableToCart = false;
    for (int i = 0; i < _cartList.length; i++) {
      if (_cartList[i].variantKey == cartModel.variantKey) {
        availableToCart = true;
        _cartList[i].quantity =
            (_cartList[i].quantity ?? 0) + (cartModel.quantity ?? 0);
        _cartList[i].totalCost =
            (_cartList[i].totalCost ?? 0) + (cartModel.totalCost ?? 0);
        break;
      }
    }
    if (!availableToCart) {
      _cartList.add(cartModel);
    }
  }

  void updateCartItemQuantity(CartModel? cart, int cartIndex,
      {bool increment = true}) async {
    _isLoading = true;
    update();

    List<Map<String, String>> variationList = [];
    String zoneId = Get.find<BookingDetailsController>()
        .bookingDetails
        ?.bookingContent
        ?.bookingDetailsContent
        ?.zoneId ??
        Get.find<BookingDetailsController>()
            .bookingDetails
            ?.bookingContent
            ?.bookingDetailsContent
            ?.subBooking
            ?.zoneId ??
        "";

    int quantity;
    if (increment) {
      quantity = (cart?.quantity ?? 0) + 1;
    } else {
      quantity = (cart?.quantity ?? 0) - 1;
    }

    if (quantity <= 0 && cart?.isNewItem == true) {
      _cartList.remove(cart);
    } else {
      variationList.add({
        "service_id": cart?.serviceId ?? "",
        "variant_key": cart?.variantKey ?? "",
        "quantity": quantity.toString()
      });

      Response response = await bookingDetailsRepo.getBookingPriceList(
          zoneId, jsonEncode(variationList));
      if (response.statusCode == 200 &&
          response.body["response_code"] == "default_200") {
        bookingPriceList =
            BookingPrice.fromJson(response.body).bookingPriceContent ?? [];

        bookingPriceList?.forEach((element) {
          _cartList[cartIndex].totalCost = element.totalCost;
          _cartList[cartIndex].quantity = element.quantity;
        });
      }
    }
    _isLoading = false;
    update();
  }

  void updatedVariationQuantity(int serviceIndex, int variationIndex,
      {bool increment = true}) {
    if (increment) {
      int quantity =
          _serviceList![serviceIndex].variations![variationIndex].quantity + 1;
      _serviceList![serviceIndex].variations![variationIndex].quantity = quantity;
    } else {
      int quantity =
          _serviceList![serviceIndex].variations![variationIndex].quantity - 1;
      _serviceList![serviceIndex].variations![variationIndex].quantity = quantity;
    }

    for (int i = 0; i < _serviceList![serviceIndex].variations!.length; i++) {
      if (_serviceList![serviceIndex].variations![i].quantity > 0) {
        _isCartButtonActive = true;
        break;
      } else {
        _isCartButtonActive = false;
      }
    }
    update();
  }

  Future<void> addMultipleCartItem(int serviceIndex) async {
    List<Map<String, String>> variationList = [];
    for (int i = 0; i < _serviceList![serviceIndex].variations!.length; i++) {
      if (_serviceList![serviceIndex].variations![i].quantity > 0) {
        Variations variations = _serviceList![serviceIndex].variations![i];
        variationList.add({
          "service_id": variations.serviceId ?? "",
          "variant_key": variations.variantKey ?? "",
          "quantity": variations.quantity.toString()
        });
      }
    }
    await getBookingPriceList(jsonEncode(variationList),
        thumbnail: _serviceList![serviceIndex].thumbnailFullPath);
  }

  Future<void> getBookingPriceList(String serviceInfo,
      {String? thumbnail}) async {
    _isLoading = true;
    update();

    Response response = await bookingDetailsRepo.getBookingPriceList(
        Get.find<BookingDetailsController>()
            .bookingDetails
            ?.bookingContent
            ?.bookingDetailsContent
            ?.zoneId ??
            "",
        serviceInfo);
    if (response.statusCode == 200 &&
        response.body["response_code"] == "default_200") {
      bookingPriceList =
          BookingPrice.fromJson(response.body).bookingPriceContent ?? [];

      bookingPriceList?.forEach((element) {
        addCartItem(CartModel(
          id: "",
          isNewItem: true,
          serviceId: element.serviceId,
          serviceName: element.serviceName,
          variantKey: element.variantKey,
          quantity: element.quantity,
          serviceThumbnail: thumbnail ?? "",
          serviceCost: element.serviceCost,
          totalCost: element.totalCost,
        ));
      });
    }
    _isLoading = false;
    update();
  }

  void resetSelectedServiceVariationQuantity(int serviceIndex) {
    if (_serviceList?[serviceIndex] != null &&
        _serviceList?[serviceIndex].variations != null) {
      for (int variationIndex = 0;
      variationIndex < _serviceList![serviceIndex].variations!.length;
      variationIndex++) {
        _serviceList![serviceIndex].variations![variationIndex].quantity = 0;
      }
      _isCartButtonActive = false;
    }
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Get.isDarkMode
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColor,
                onPrimary: Get.isDarkMode
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).cardColor,
                onSurface: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.8),
                surface: Theme.of(context).cardColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            child: child!,
          );
        },
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      _selectedDate = picked;
      selectTimeOfDay();
    }
  }

  Future<void> selectTimeOfDay() async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!, initialTime: TimeOfDay.now());

    if (pickedTime != null) {
      _selectedTimeOfDay = pickedTime;
      if (DateTime.tryParse(
          "${DateConverter.dateTimeStringToDate(_selectedDate.toString())} ${DateConverter.timeToTimeString(_selectedTimeOfDay)}")!
          .isBefore(DateTime.now())) {
        showCustomSnackBar("schedule_time_must_be_after_current_time".tr,
            type: ToasterMessageType.info);
        _scheduleTime = _previousScheduleTime;
      } else {
        _scheduleTime =
        "${DateConverter.dateTimeStringToDate(_selectedDate.toString())} ${DateConverter.timeToTimeString(_selectedTimeOfDay)}";
      }
      update();
    }
  }

  void changeBookingStatusDropDownValue(String status) {
    _bookingStatus = status;
    update();
  }

  void togglePaymentStatus() {
    _paymentStatusPaid = !_paymentStatusPaid;
    update();
  }

  void removeCartItem(int index) {
    _cartList.removeAt(index);
    update();
  }
}