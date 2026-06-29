import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/asset.dart';

class AssetService {
  static String get baseUrl => '${AppConfig.baseUrl}/assets';

  Future<List<Asset>> getAssets() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List data = body["data"];
      return data.map((e) => Asset.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data aset");
    }
  }

  Future<Asset> getAssetById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    ).timeout(AppConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Asset.fromJson(body["data"]);
    } else {
      throw Exception("Aset tidak ditemukan");
    }
  }
}
