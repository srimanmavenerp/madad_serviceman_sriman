// APIiiiiiiiiiiiiiiiiiiiii Service

// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../model/new_booking_list_model.dart';
//
// class BookingService {
//   static const String _baseUrl = 'https://madadservices.com/api/v1/serviceman/booking/list';
//
//   Future<BookingResponse> fetchBookings({
//     required String token,
//     int limit = 100,
//     int offset = 1,
//     String bookingStatus = 'pending',
//     String slot = '5am to 9am',
//     String serviceId = '10646e61-1a40-4b4f-a388-2ae804e2e301',
//     String fromDate = '01-07-2025',
//     String toDate = '01-07-2025',
//   }) async {
//     final uri = Uri.parse(_baseUrl).replace(queryParameters: {
//       'limit': limit.toString(),
//       'offset': offset.toString(),
//       'booking_status': bookingStatus,
//       'slot': slot,
//       'service_id': serviceId,
//       'from_date': fromDate,
//       'to_date': toDate,
//     });
//
//     final headers = {
//       'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5NWZhYWFjNi1jMWQyLTRkNGMtYmViMS0wNDE5NmRkMmZhOGUiLCJqdGkiOiJmZDU2OTljZTIwOGVhNTQyOGVkMmYxZjExYmZhZDk4ZDg2Y2NlZGFlNjI3Mzc0ZWNiYzE0OGJlY2NkODliNzJiYzMyOTkwMDlkZTUwNzEyNiIsImlhdCI6MTc1NDAzMjY5MS4yODYxMDk5MjQzMTY0MDYyNSwibmJmIjoxNzU0MDMyNjkxLjI4NjExMjA3MDA4MzYxODE2NDA2MjUsImV4cCI6MTc4NTU2ODY5MS4yODE3Mjk5MzY1OTk3MzE0NDUzMTI1LCJzdWIiOiIyNDAxNmRlNi03OTFjLTQxYTgtYTczMS03N2I1NGRlYWZlYTciLCJzY29wZXMiOltdfQ.nkuSqkKCbm-guZsueTRxSS9rQOYuRWq7b63iqp5Ol6K9Elq13LKmFQrEVs8BYRrB4F6OxdGQr7hh-FHBF8kL1LmJpBT1MkOtv9N46WpcFmi7oLTVUg048f6UW61l43cjwjtzPp7ZrRmgGOaxx_bTeWEDc5jvlMuN__8Fc3ENnxiO8oZoxuWxLq0rId6t1w0oLH2AI_kmRBVCJtjzml3m5f1hcOn1lRsKbdykmw-dhUZbjckOQHO8Z-nKhCXGfAwK7uG27NtOUkVss2YLwdOIQnpnzixcAOsWZ--zO773QYQF_878p0zB7nq5bcFr3P2_PZBLK6-iZS69YtIzNFeDoecpNR3og1MlCFULnIZO9j9w88iGisjaVDW9z_6nj7F5jmq_eayXDawkdz6k7nfgn9Zl4Dz3uTcxggNlDBZpECXienYhnnoz7JdB2sExfu2A0IDQYeKL6Pugvm083Motp-HN2tWQ038EHvv67S2nRiMIlbSqxJohAtf-SwNR_nIPcpU5J8dbmA4SYJ5OzKooRCqAEXH2FwR72qFzQKBSqwX0bgTesVD-jdnt5zS1VgUtDPU-LxFrtFrKOPl8C7pnlk9n12447MWsNw3-EdfwuejvPim-EGtqHV5YCqyvb-0O54-6gVe9ovnTWWlgMSb6RjN5Y_60uM-yxJWM2grYUMU',
//       'Content-Type': 'application/json',
//     };
//
//     try {
//       final response = await http.get(uri, headers: headers);
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         return BookingResponse.fromJson(jsonData);
//       } else {
//         throw Exception('Failed to load bookings: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching bookings: $e');
//     }
//   }
// }
