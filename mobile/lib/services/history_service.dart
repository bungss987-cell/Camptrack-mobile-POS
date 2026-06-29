import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';

class HistoryService {
  static const String baseUrl =
      "http://localhost:3000/api/transactions";

  Future<List<TransactionModel>> getHistory() async {
    final response =
        await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List data = body["data"];

      return data
          .map((e) => TransactionModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}