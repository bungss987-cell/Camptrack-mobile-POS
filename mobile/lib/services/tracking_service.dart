import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class TrackingService {
  static String get baseUrl => '${AppConfig.baseUrl}/shipment';

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        if (_token != null) "Authorization": "Bearer $_token",
      };

  Future<Map<String, dynamic>?> getShipmentByTracking(
      String trackingNumber) async {
    if (trackingNumber.isEmpty || trackingNumber == "-") {
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$trackingNumber'),
      headers: _headers,
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    }

    return null;
  }
}
