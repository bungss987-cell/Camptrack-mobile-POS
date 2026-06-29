import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class TransactionService {
  static String get baseUrl => '${AppConfig.baseUrl}/transactions';

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        if (_token != null) "Authorization": "Bearer $_token",
      };

  Future<int> createTransaction({
    required int assetId,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required int quantity,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({
        "assetId": assetId,
        "customerName": customerName,
        "customerPhone": customerPhone,
        "customerAddress": customerAddress,
        "quantity": quantity,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      }),
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body["data"]["id"];
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody["message"] ?? "Gagal membuat transaksi");
  }

  Future<void> returnTransaction(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/return"),
      headers: _headers,
      body: jsonEncode({}),
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody["message"] ?? "Gagal memproses pengembalian");
    }
  }

  Future<void> payTransaction({
    required int id,
    required String paymentMethod,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/pay"),
      headers: _headers,
      body: jsonEncode({
        "paymentMethod": paymentMethod,
      }),
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody["message"] ?? "Gagal memproses pembayaran");
    }
  }
}
