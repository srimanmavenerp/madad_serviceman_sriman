// lib/feature/serviceman_status/booking_occurrence_model.dart
class BookingOccurrence {
  final int bookingId;
  final String date;
  final String status;
  final String note;
  final String label;
  final List<String> images;

  BookingOccurrence({
    required this.bookingId,
    required this.date,
    required this.status,
    required this.note,
    required this.label,
    required this.images,
  });

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "date": date,
    "status": status,
    "note": note,
    "label": label,
    "images": images,
  };

  factory BookingOccurrence.fromJson(Map<String, dynamic> json) {
    return BookingOccurrence(
      bookingId: json['booking_id'],
      date: json['date'],
      status: json['status'],
      note: json['note'],
      label: json['label'],
      images: List<String>.from(json['images']),
    );
  }
}