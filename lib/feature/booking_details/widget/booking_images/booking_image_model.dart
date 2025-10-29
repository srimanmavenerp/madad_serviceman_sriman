class GetImagesResponse {
  final bool isSuccess;
  final String bookingId;
  final String date; // Changed to String to match API response
  final List<ImageDetails> imageDetails;

  GetImagesResponse({
    required this.isSuccess,
    required this.bookingId,
    required this.date,
    required this.imageDetails,
  });

  factory GetImagesResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing GetImagesResponse: $json'); // Debug response
    return GetImagesResponse(
      isSuccess: json['success'] ?? false,
      bookingId: json['booking_id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      imageDetails: (json['events'] as List<dynamic>? ?? [])
          .map((item) => ImageDetails.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ImageDetails {
  final String date;
  final String status;
  final String label;
  final String color;
  final List<String>? images; // after images
  final List<String>? beforeImages; // before images
  final List<String>? cancelledImages; // cancelled images
  final String note;
  final String updatedAt;
  final String? beforeImagesUploadedAt;
  final String? afterImagesUploadedAt;
  final String? cancelledImagesUploadedAt;

  ImageDetails({
    required this.date,
    required this.status,
    required this.label,
    required this.color,
    this.images,
    this.beforeImages,
    this.cancelledImages,
    required this.note,
    required this.updatedAt,
    this.beforeImagesUploadedAt,
    this.afterImagesUploadedAt,
    this.cancelledImagesUploadedAt,
  });

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    print('Parsing ImageDetails: $json'); // Debug log
    return ImageDetails(
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      color: json['color']?.toString() ?? '#4CAF50',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      beforeImages: json['before_images'] != null
          ? List<String>.from(json['before_images'])
          : [],
      cancelledImages: json['cancelled_images'] != null
          ? List<String>.from(json['cancelled_images'])
          : [],
      note: json['note']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      beforeImagesUploadedAt: json['before_images_uploaded_at']?.toString(),
      afterImagesUploadedAt: json['after_images_uploaded_at']?.toString(),
      cancelledImagesUploadedAt:
          json['cancelled_images_uploaded_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'status': status,
      'label': label,
      'color': color,
      'images': images ?? [],
      'before_images': beforeImages ?? [],
      'cancelled_images': cancelledImages ?? [],
      'note': note,
      'updated_at': updatedAt,
      'before_images_uploaded_at': beforeImagesUploadedAt,
      'after_images_uploaded_at': afterImagesUploadedAt,
      'cancelled_images_uploaded_at': cancelledImagesUploadedAt,
    };
  }
}
