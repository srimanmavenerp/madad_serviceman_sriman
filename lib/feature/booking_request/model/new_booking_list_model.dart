import 'dart:convert';

class BookingResponse {
  final String? responseCode;
  final String? message;
  final Content? content;

  BookingResponse({
    this.responseCode,
    this.message,
    this.content,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      responseCode: json['response_code'],
      message: json['message'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
    );
  }
}

class Content {
  final BookingPagination? bookings;
  final List<Service>? services; // Add this line

  Content({
    this.bookings,
    this.services, // Add this line
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      bookings: json['bookings'] != null ? BookingPagination.fromJson(json['bookings']) : null,
      services: (json['services'] as List<dynamic>?)?.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList(), // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookings': bookings?.toJson(),
      'services': services?.map((e) => e.toJson()).toList(), // Add this line
    };
  }
}

class BookingPagination {
  final int currentPage;
  final List<Booking> data; // Remove 'late' keyword
  final int? lastPage;
  final int? total;
  final int? perPage;

  BookingPagination({
    required this.currentPage,
    required this.data,
    this.lastPage,
    this.total,
    this.perPage,
  });

  factory BookingPagination.fromJson(Map<String, dynamic> json) {
    return BookingPagination(
      currentPage: json['current_page'] as int? ?? 1,
      data: (json['data'] as List<dynamic>?)
          ?.map((i) => Booking.fromJson(i as Map<String, dynamic>))
          .toList() ?? [],
      lastPage: json['last_page'] as int?,
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
      'last_page': lastPage,
      'total': total,
      'per_page': perPage,
    };
  }
}
// class Content {
//   final List<Booking>? bookings;
//   final int? total;
//
//   Content({
//     this.bookings,
//     this.total,
//   });
//
//   factory Content.fromJson(Map<String, dynamic> json) {
//     return Content(
//       bookings: json['bookings'] != null
//           ? (json['bookings'] as List).map((i) => Booking.fromJson(i)).toList()
//           : null,
//       total: json['total'],
//     );
//   }
// }

class BookingContent {
  final List<Booking>? bookings;
  final List<Service>? services;

  BookingContent({
    this.bookings,
    this.services,
  });

  factory BookingContent.fromJson(Map<String, dynamic> json) {
    return BookingContent(
      bookings: (json['bookings'] as List<dynamic>?)?.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList(),
      services: (json['services'] as List<dynamic>?)?.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookings': bookings?.map((e) => e.toJson()).toList(),
      'services': services?.map((e) => e.toJson()).toList(),
    };
  }
}

class Booking {
  final String? id;
  final int? readableId;
  final String? customerId;
  final String? providerId;
  final String? zoneId;
  final String? bookingStatus;
  final int? isPaid;
  final String? paymentMethod;
  final String? transactionId;
  final double? totalBookingAmount;
  final double? totalTaxAmount;
  final double? totalDiscountAmount;
  final String? serviceSchedule;
  final String? slot;
  final String? serviceAddressId;
  final String? serviceVehicleDetailsId;
  final String? createdAt;
  final String? updatedAt;
  final String? categoryId;
  final String? subCategoryId;
  final String? planId;
  final String? startDate;
  final String? endDate;
  final String? servicemanId;
  final double? totalCampaignDiscountAmount;
  final double? totalCouponDiscountAmount;
  final String? couponCode;
  final int? isChecked;
  final double? additionalCharge;
  final double? additionalTaxAmount;
  final double? additionalDiscountAmount;
  final double? additionalCampaignDiscountAmount;
  final String? removedCouponAmount;
  final List<dynamic>? evidencePhotos;
  final String? bookingOtp;
  final int? isGuest;
  final int? isVerified;
  final double? extraFee;
  final double? totalReferralDiscountAmount;
  final int? isRepeated;
  final String? assignedBy;
  final String? serviceLocation;
  final ServiceAddressLocation? serviceAddressLocation;
  final dynamic serviceData;
  final List<dynamic>? repeats;
  final List<dynamic>? evidencePhotosFullPath;
  final SubCategory? Service;
  final Vehicle? vehicle;
  final List<dynamic>? bookingOccurrences;

  Booking({
    this.id,
    this.readableId,
    this.customerId,
    this.providerId,
    this.zoneId,
    this.bookingStatus,
    this.isPaid,
    this.paymentMethod,
    this.transactionId,
    this.totalBookingAmount,
    this.totalTaxAmount,
    this.totalDiscountAmount,
    this.serviceSchedule,
    this.slot,
    this.serviceAddressId,
    this.serviceVehicleDetailsId,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.subCategoryId,
    this.planId,
    this.startDate,
    this.endDate,
    this.servicemanId,
    this.totalCampaignDiscountAmount,
    this.totalCouponDiscountAmount,
    this.couponCode,
    this.isChecked,
    this.additionalCharge,
    this.additionalTaxAmount,
    this.additionalDiscountAmount,
    this.additionalCampaignDiscountAmount,
    this.removedCouponAmount,
    this.evidencePhotos,
    this.bookingOtp,
    this.isGuest,
    this.isVerified,
    this.extraFee,
    this.totalReferralDiscountAmount,
    this.isRepeated,
    this.assignedBy,
    this.serviceLocation,
    this.serviceAddressLocation,
    this.serviceData,
    this.repeats,
    this.evidencePhotosFullPath,
    this.Service,
    this.vehicle,
    this.bookingOccurrences,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      readableId: json['readable_id'] as int?,
      customerId: json['customer_id'] as String?,
      providerId: json['provider_id'] as String?,
      zoneId: json['zone_id'] as String?,
      bookingStatus: json['booking_status'] as String?,
      isPaid: json['is_paid'] as int?,
      paymentMethod: json['payment_method'] as String?,
      transactionId: json['transaction_id'] as String?,
      totalBookingAmount: (json['total_booking_amount'] as num?)?.toDouble(),
      totalTaxAmount: (json['total_tax_amount'] as num?)?.toDouble(),
      totalDiscountAmount: (json['total_discount_amount'] as num?)?.toDouble(),
      serviceSchedule: json['service_schedule'] as String?,
      slot: json['slot'] as String?,
      serviceAddressId: json['service_address_id'] as String?,
      serviceVehicleDetailsId: json['service_vehicle_details_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      categoryId: json['category_id'] as String?,
      subCategoryId: json['sub_category_id'] as String?,
      planId: json['plan_id'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      servicemanId: json['serviceman_id'] as String?,
      totalCampaignDiscountAmount: (json['total_campaign_discount_amount'] as num?)?.toDouble(),
      totalCouponDiscountAmount: (json['total_coupon_discount_amount'] as num?)?.toDouble(),
      couponCode: json['coupon_code'] as String?,
      isChecked: json['is_checked'] as int?,
      additionalCharge: (json['additional_charge'] as num?)?.toDouble(),
      additionalTaxAmount: (json['additional_tax_amount'] as num?)?.toDouble(),
      additionalDiscountAmount: (json['additional_discount_amount'] as num?)?.toDouble(),
      additionalCampaignDiscountAmount: (json['additional_campaign_discount_amount'] as num?)?.toDouble(),
      removedCouponAmount: json['removed_coupon_amount'] as String?,
      evidencePhotos: json['evidence_photos'] as List<dynamic>?,
      bookingOtp: json['booking_otp'] as String?,
      isGuest: json['is_guest'] as int?,
      isVerified: json['is_verified'] as int?,
      extraFee: (json['extra_fee'] as num?)?.toDouble(),
      totalReferralDiscountAmount: (json['total_referral_discount_amount'] as num?)?.toDouble(),
      isRepeated: json['is_repeated'] as int?,
      assignedBy: json['assigned_by'] as String?,
      serviceLocation: json['service_location'] as String?,
      serviceAddressLocation: json['service_address_location'] != null
          ? ServiceAddressLocation.fromJson(
          jsonDecode(json['service_address_location'] is String
              ? json['service_address_location']
              : jsonEncode(json['service_address_location'])) as Map<String, dynamic>)
          : null,
      serviceData: json['service_data'],
      repeats: json['repeats'] as List<dynamic>?,
      evidencePhotosFullPath: json['evidence_photos_full_path'] as List<dynamic>?,
      Service: json['sub_category'] != null
          ? SubCategory.fromJson(json['sub_category'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>) : null,
      bookingOccurrences: json['booking_occurrences'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'readable_id': readableId,
      'customer_id': customerId,
      'provider_id': providerId,
      'zone_id': zoneId,
      'booking_status': bookingStatus,
      'is_paid': isPaid,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'total_booking_amount': totalBookingAmount,
      'total_tax_amount': totalTaxAmount,
      'total_discount_amount': totalDiscountAmount,
      'service_schedule': serviceSchedule,
      'slot': slot,
      'service_address_id': serviceAddressId,
      'service_vehicle_details_id': serviceVehicleDetailsId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'plan_id': planId,
      'start_date': startDate,
      'end_date': endDate,
      'serviceman_id': servicemanId,
      'total_campaign_discount_amount': totalCampaignDiscountAmount,
      'total_coupon_discount_amount': totalCouponDiscountAmount,
      'coupon_code': couponCode,
      'is_checked': isChecked,
      'additional_charge': additionalCharge,
      'additional_tax_amount': additionalTaxAmount,
      'additional_discount_amount': additionalDiscountAmount,
      'additional_campaign_discount_amount': additionalCampaignDiscountAmount,
      'removed_coupon_amount': removedCouponAmount,
      'evidence_photos': evidencePhotos,
      'booking_otp': bookingOtp,
      'is_guest': isGuest,
      'is_verified': isVerified,
      'extra_fee': extraFee,
      'total_referral_discount_amount': totalReferralDiscountAmount,
      'is_repeated': isRepeated,
      'assigned_by': assignedBy,
      'service_location': serviceLocation,
      'service_address_location': serviceAddressLocation != null ? jsonEncode(serviceAddressLocation!.toJson()) : null,
      'service_data': serviceData,
      'repeats': repeats,
      'evidence_photos_full_path': evidencePhotosFullPath,
      'sub_category': Service?.toJson(),
      'vehicle': vehicle?.toJson(),
      'booking_occurrences': bookingOccurrences,
    };
  }
}

class ServiceAddressLocation {
  final int? id;
  final String? userId;
  final String? lat;
  final String? lon;
  final String? city;
  final String? street;
  final String? zipCode;
  final String? country;
  final String? address;
  final String? parkingDetails;
  final String? createdAt;
  final String? updatedAt;
  final String? addressType;
  final String? contactPersonName;
  final String? contactPersonNumber;
  final String? addressLabel;
  final String? zoneId;
  final int? isGuest;
  final String? house;
  final String? floor;

  ServiceAddressLocation({
    this.id,
    this.userId,
    this.lat,
    this.lon,
    this.city,
    this.street,
    this.zipCode,
    this.country,
    this.address,
    this.parkingDetails,
    this.createdAt,
    this.updatedAt,
    this.addressType,
    this.contactPersonName,
    this.contactPersonNumber,
    this.addressLabel,
    this.zoneId,
    this.isGuest,
    this.house,
    this.floor,
  });

  factory ServiceAddressLocation.fromJson(Map<String, dynamic> json) {
    return ServiceAddressLocation(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      lat: json['lat'] as String?,
      lon: json['lon'] as String?,
      city: json['city'] as String?,
      street: json['street'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      address: json['address'] as String?,
      parkingDetails: json['parking_details'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      addressType: json['address_type'] as String?,
      contactPersonName: json['contact_person_name'] as String?,
      contactPersonNumber: json['contact_person_number'] as String?,
      addressLabel: json['address_label'] as String?,
      zoneId: json['zone_id'] as String?,
      isGuest: json['is_guest'] as int?,
      house: json['house'] as String?,
      floor: json['floor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lat': lat,
      'lon': lon,
      'city': city,
      'street': street,
      'zip_code': zipCode,
      'country': country,
      'address': address,
      'parking_details': parkingDetails,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'address_type': addressType,
      'contact_person_name': contactPersonName,
      'contact_person_number': contactPersonNumber,
      'address_label': addressLabel,
      'zone_id': zoneId,
      'is_guest': isGuest,
      'house': house,
      'floor': floor,
    };
  }
}

class SubCategory {
  final String? id;
  final String? name;
  final String? imageFullPath;
  final List<Translation>? translations;

  SubCategory({
    this.id,
    this.name,
    this.imageFullPath,
    this.translations,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      imageFullPath: json['image_full_path'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_full_path': imageFullPath,
      'translations': translations?.map((e) => e.toJson()).toList(),
    };
  }
}

class Vehicle {
  final int? id;
  final String? userId;
  final String? brand;
  final String? type;
  final String? model;
  final String? color;
  final String? vehicleNo;
  final String? contactNo;
  final String? additionalDetails;
  final String? createdAt;
  final String? updatedAt;

  Vehicle({
    this.id,
    this.userId,
    this.brand,
    this.type,
    this.model,
    this.color,
    this.vehicleNo,
    this.contactNo,
    this.additionalDetails,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      brand: json['brand'] as String?,
      type: json['type'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      vehicleNo: json['vehicle_no'] as String?,
      contactNo: json['contact_no'] as String?,
      additionalDetails: json['additional_details'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'brand': brand,
      'type': type,
      'model': model,
      'color': color,
      'vehicle_no': vehicleNo,
      'contact_no': contactNo,
      'additional_details': additionalDetails,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Service {
  final String? id;
  final String? name;
  final String? thumbnailFullPath;
  final String? coverImageFullPath;
  final List<Translation>? translations;

  Service({
    this.id,
    this.name,
    this.thumbnailFullPath,
    this.coverImageFullPath,
    this.translations,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String?,
      name: json['name'] as String?,
      thumbnailFullPath: json['thumbnail_full_path'] as String?,
      coverImageFullPath: json['cover_image_full_path'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail_full_path': thumbnailFullPath,
      'cover_image_full_path': coverImageFullPath,
      'translations': translations?.map((e) => e.toJson()).toList(),
    };
  }
}

class Translation {
  final int? id;
  final String? translationableType;
  final String? translationableId;
  final String? locale;
  final String? key;
  final String? value;

  Translation({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] as int?,
      translationableType: json['translationable_type'] as String?,
      translationableId: json['translationable_id'] as String?,
      locale: json['locale'] as String?,
      key: json['key'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationable_type': translationableType,
      'translationable_id': translationableId,
      'locale': locale,
      'key': key,
      'value': value,
    };
  }
}