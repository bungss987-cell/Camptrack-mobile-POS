import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asset.dart';

class AssetService {
  static const String baseUrl =
      "http://localhost:3000/api/assets";

  Future<List<Asset>> getAssets() async {
    final response =
        await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List data = body["data"];

      return data
          .map((e) => Asset.fromJson(e))
          .toList();
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}