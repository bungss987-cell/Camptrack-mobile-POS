import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl =
      "http://localhost:3000/api/transactions";

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
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "assetId": assetId,
        "customerName": customerName,
        "customerPhone": customerPhone,
        "customerAddress": customerAddress,
        "quantity": quantity,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
  final body = jsonDecode(response.body);
  return body["data"]["id"];
}

throw Exception(response.body);
  }

  Future<void> returnTransaction(int id) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id/return"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({}),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> payTransaction({
  required int id,
  required String paymentMethod,
}) async {
  final response = await http.put(
    Uri.parse("$baseUrl/$id/pay"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "paymentMethod": paymentMethod,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(response.body);
  }
}
}