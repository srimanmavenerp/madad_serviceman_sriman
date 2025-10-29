import 'dart:convert';

class DashboardBookingDetails {
  String responseCode;
  String message;
  List<Content> content;
  List<dynamic> errors;

  DashboardBookingDetails({
    required this.responseCode,
    required this.message,
    required this.content,
    required this.errors,
  });

  factory DashboardBookingDetails.fromJson(Map<String, dynamic> json) {
    List<Content> bookings = [];

    if (json["content"] is List) {
      for (var item in json["content"]) {
        if (item is Map && item.containsKey("bookings")) {
          final bookingList = item["bookings"];
          if (bookingList is List) {
            bookings = bookingList
                .map((x) => Content.fromJson(x as Map<String, dynamic>))
                .toList();
          }
          break;
        }
      }
    }

    return DashboardBookingDetails(
      responseCode: json["response_code"] ?? "",
      message: json["message"] ?? "",
      content: bookings,
      errors: json["errors"] ?? [],
    );
  }
}

class Content {
  String id;
  int readableId;
  String customerId;
  String providerId;
  String zoneId;
  String bookingStatus;
  int isPaid;
  String paymentMethod;
  String transactionId;
  double totalBookingAmount;
  double totalTaxAmount;
  double totalDiscountAmount;
  String serviceSchedule;
  String slot;
  String serviceAddressId;
  String serviceVehicleDetailsId;
  DateTime createdAt;
  DateTime updatedAt;
  String categoryId;
  String subCategoryId;
  String? planId;
  String? startDate;
  String? endDate;
  String servicemanId;
  double totalCampaignDiscountAmount;
  double totalCouponDiscountAmount;
  String? couponCode;
  int isChecked;
  double additionalCharge;
  double additionalTaxAmount;
  double additionalDiscountAmount;
  double additionalCampaignDiscountAmount;
  String removedCouponAmount;
  List<dynamic> evidencePhotos;
  String bookingOtp;
  int isGuest;
  int isVerified;
  double extraFee;
  double totalReferralDiscountAmount;
  int isRepeated;
  String? assignedBy;
  String serviceLocation;
  String serviceAddressLocation;
  dynamic serviceData;
  List<dynamic> repeats;
  List<dynamic> evidencePhotosFullPath;
  SubCategory subCategory;
  Vehicle vehicle;
  List<BookingOccurrence> bookingOccurrences;

  Content({
    required this.id,
    required this.readableId,
    required this.customerId,
    required this.providerId,
    required this.zoneId,
    required this.bookingStatus,
    required this.isPaid,
    required this.paymentMethod,
    required this.transactionId,
    required this.totalBookingAmount,
    required this.totalTaxAmount,
    required this.totalDiscountAmount,
    required this.serviceSchedule,
    required this.slot,
    required this.serviceAddressId,
    required this.serviceVehicleDetailsId,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.subCategoryId,
    this.planId,
    this.startDate,
    this.endDate,
    required this.servicemanId,
    required this.totalCampaignDiscountAmount,
    required this.totalCouponDiscountAmount,
    this.couponCode,
    required this.isChecked,
    required this.additionalCharge,
    required this.additionalTaxAmount,
    required this.additionalDiscountAmount,
    required this.additionalCampaignDiscountAmount,
    required this.removedCouponAmount,
    required this.evidencePhotos,
    required this.bookingOtp,
    required this.isGuest,
    required this.isVerified,
    required this.extraFee,
    required this.totalReferralDiscountAmount,
    required this.isRepeated,
    this.assignedBy,
    required this.serviceLocation,
    required this.serviceAddressLocation,
    this.serviceData,
    required this.repeats,
    required this.evidencePhotosFullPath,
    required this.subCategory,
    required this.vehicle,
    required this.bookingOccurrences,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"] ?? "",
    readableId: json["readable_id"] ?? 0,
    customerId: json["customer_id"] ?? "",
    providerId: json["provider_id"] ?? "",
    zoneId: json["zone_id"] ?? "",
    bookingStatus: json["booking_status"] ?? "",
    isPaid: json["is_paid"] ?? 0,
    paymentMethod: json["payment_method"] ?? "",
    transactionId: json["transaction_id"] ?? "",
    totalBookingAmount: (json["total_booking_amount"] as num?)?.toDouble() ?? 0,
    totalTaxAmount: (json["total_tax_amount"] as num?)?.toDouble() ?? 0,
    totalDiscountAmount: (json["total_discount_amount"] as num?)?.toDouble() ?? 0,
    serviceSchedule: json["service_schedule"] ?? "",
    slot: json["slot"] ?? "",
    serviceAddressId: json["service_address_id"] ?? "",
    serviceVehicleDetailsId: json["service_vehicle_details_id"] ?? "",
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
    categoryId: json["category_id"] ?? "",
    subCategoryId: json["sub_category_id"] ?? "",
    planId: json["plan_id"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    servicemanId: json["serviceman_id"] ?? "",
    totalCampaignDiscountAmount:
    (json["total_campaign_discount_amount"] as num?)?.toDouble() ?? 0,
    totalCouponDiscountAmount:
    (json["total_coupon_discount_amount"] as num?)?.toDouble() ?? 0,
    couponCode: json["coupon_code"],
    isChecked: json["is_checked"] ?? 0,
    additionalCharge:
    (json["additional_charge"] as num?)?.toDouble() ?? 0,
    additionalTaxAmount:
    (json["additional_tax_amount"] as num?)?.toDouble() ?? 0,
    additionalDiscountAmount:
    (json["additional_discount_amount"] as num?)?.toDouble() ?? 0,
    additionalCampaignDiscountAmount:
    (json["additional_campaign_discount_amount"] as num?)?.toDouble() ?? 0,
    removedCouponAmount: json["removed_coupon_amount"] ?? "",
    evidencePhotos: json["evidence_photos"] != null
        ? List<dynamic>.from(json["evidence_photos"])
        : [],
    bookingOtp: json["booking_otp"] ?? "",
    isGuest: json["is_guest"] ?? 0,
    isVerified: json["is_verified"] ?? 0,
    extraFee: (json["extra_fee"] as num?)?.toDouble() ?? 0,
    totalReferralDiscountAmount:
    (json["total_referral_discount_amount"] as num?)?.toDouble() ?? 0,
    isRepeated: json["is_repeated"] ?? 0,
    assignedBy: json["assigned_by"],
    serviceLocation: json["service_location"] ?? "",
    serviceAddressLocation: json["service_address_location"] ?? "",
    serviceData: json["service_data"],
    repeats: json["repeats"] != null ? List<dynamic>.from(json["repeats"]) : [],
    evidencePhotosFullPath:
    json["evidence_photos_full_path"] != null
        ? List<dynamic>.from(json["evidence_photos_full_path"])
        : [],
    subCategory: json["sub_category"] != null
        ? SubCategory.fromJson(json["sub_category"] as Map<String, dynamic>)
        : SubCategory.empty(),
    vehicle: json["vehicle"] != null
        ? Vehicle.fromJson(json["vehicle"] as Map<String, dynamic>)
        : Vehicle.empty(),
    bookingOccurrences: json["booking_occurrences"] != null
        ? (json["booking_occurrences"] as List)
        .map((x) => BookingOccurrence.fromJson(x as Map<String, dynamic>))
        .toList()
        : [],
  );
}

class SubCategory {
  String id;
  String name;
  dynamic imageFullPath;
  List<Translation> translations;

  SubCategory({
    required this.id,
    required this.name,
    this.imageFullPath,
    required this.translations,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    imageFullPath: json["image_full_path"],
    translations: json["translations"] != null
        ? List<Translation>.from((json["translations"] as List)
        .map((x) => Translation.fromJson(x as Map<String, dynamic>)))
        : [],
  );

  static SubCategory empty() =>
      SubCategory(id: "", name: "", translations: []);
}

class Translation {
  int id;
  String translationableType;
  String translationableId;
  String locale;
  String key;
  String value;

  Translation({
    required this.id,
    required this.translationableType,
    required this.translationableId,
    required this.locale,
    required this.key,
    required this.value,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
    id: json["id"] ?? 0,
    translationableType: json["translationable_type"] ?? "",
    translationableId: json["translationable_id"] ?? "",
    locale: json["locale"] ?? "",
    key: json["key"] ?? "",
    value: json["value"] ?? "",
  );
}

class Vehicle {
  int? id;
  String userId;
  String brand;
  String type;
  String model;
  String color;
  String vehicleNo;
  String contactNo;
  dynamic additionalDetails;
  DateTime? createdAt;
  DateTime? updatedAt;

  Vehicle({
    this.id,
    required this.userId,
    required this.brand,
    required this.type,
    required this.model,
    required this.color,
    required this.vehicleNo,
    required this.contactNo,
    this.additionalDetails,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"] as int?,
    userId: json["user_id"] ?? "",
    brand: json["brand"] ?? "",
    type: json["type"] ?? "",
    model: json["model"] ?? "",
    color: json["color"] ?? "",
    vehicleNo: json["vehicle_no"] ?? "",
    contactNo: json["contact_no"] ?? "",
    additionalDetails: json["additional_details"],
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
  );

  static Vehicle empty() => Vehicle(
    userId: "",
    brand: "",
    type: "",
    model: "",
    color: "",
    vehicleNo: "",
    contactNo: "",
  );
}

class BookingOccurrence {
  int id;
  String bookingId;
  DateTime date;
  String status;
  String note;
  List<String> images;
  String color;
  String label;
  DateTime createdAt;
  DateTime updatedAt;

  BookingOccurrence({
    required this.id,
    required this.bookingId,
    required this.date,
    required this.status,
    required this.note,
    required this.images,
    required this.color,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingOccurrence.fromJson(Map<String, dynamic> json) =>
      BookingOccurrence(
        id: json["id"] ?? 0,
        bookingId: json["booking_id"] ?? "",
        date: json["date"] != null
            ? DateTime.tryParse(json["date"] as String) ?? DateTime.now()
            : DateTime.now(),
        status: json["status"] ?? "",
        note: json["note"] ?? "",
        images: json["images"] != null
            ? List<String>.from(json["images"])
            : [],
        color: json["color"] ?? "",
        label: json["label"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"] as String) ??
            DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"] as String) ??
            DateTime.now()
            : DateTime.now(),
      );
}