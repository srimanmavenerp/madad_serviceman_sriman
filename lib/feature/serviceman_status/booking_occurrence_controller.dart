import 'dart:convert';
import 'package:http/http.dart' as http;

void submitBookingOccurrence() async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie':
    'XSRF-TOKEN=eyJpdiI6IkxCVFNmdWdPNnhXcEZ3N2xRTUhpU3c9PSIsInZhbHVlIjoiVjFDL1NxTkUyREYxaXVQak9KQjBUMG80cHNZbFd3RXhtQ3ZoZnBJTDFYNVFBdjNCSklvMzhrUjhsSG9RajBvWGhoWkZVZ2lpbGFRbGpPWVBGZEU4NmFIc2VQOUtlQXVzOW9DS3hPSmU4Qk5JeXlWR0pqQzhudTNDWUhXM01rQjgiLCJtYWMiOiIwNThiYWEyNjE4NjBjYTY0ZDI1ZTU2YWIzNjQxMWNjMDYyM2FmZTZkM2Y3ZWFmZTJkOTZiM2M2NDNkMjBlMzNmIiwidGFnIjoiIn0%3D; demandium1749019340_session=eyJpdiI6IlYrMmh0ZUtFL24yOUthRDBNN2orQXc9PSIsInZhbHVlIjoiUE9iTTdOUG9kU3Fua3pVMVlyRDFsOFc3YnRHNTIyUzdUeUJZSUl0VlRCNjBCSGZLbXVvOHc2aEtDNXVTUG5RRHgzWXNhRk9pNWZtaDZ0OFhYMWRHZ0hka2hqeGEzellaYk4vNy9FMEV0MFF4TWxMZnVFNm9pZC91NlNwZFhvcTEiLCJtYWMiOiI0ODc2Yjc2YjUxM2Y1NDc3OWFlNjczOTZmM2ZhYWEwYzEzZWUzOWU0MGU5YjNhYWYxMGY1NzIzZjUzNTc0MzAzIiwidGFnIjoiIn0%3D'
  };

  var url = Uri.parse('https://madadservices.com/api/v1/serviceman/booking/booking-occurrences');

  var body = json.encode({
    "booking_id": 5,
    "date": "2025-06-18",
    "status": "completed",
    "note": "Technician completed the service successfully.",
    "label": "Service Completed",
    "images": [
      "https://madadservices.com/storage/app/public/landing-page/2025-06-18-image1.png",
      "https://madadservices.com/storage/app/public/landing-page/2025-06-18-image2.png"
    ]
  });

  var request = http.Request('POST', url);
  request.body = body;
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      print('Responserrrrrrrrrrrrrr: $responseBody');
    } else {
      print('Failed with status code: ${response.statusCode}');
      print('Reasonnnnnnnnnnnnn: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}