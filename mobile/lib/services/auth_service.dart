import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AuthService {
  static String get baseUrl => '${AppConfig.baseUrl}/auth';

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        if (_token != null) "Authorization": "Bearer $_token",
      };

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    ).timeout(AppConfig.connectionTimeout);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body["data"];
    }

    throw Exception(body["message"] ?? "Login gagal");
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "address": address,
      }),
    ).timeout(AppConfig.connectionTimeout);

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body["data"];
    }

    throw Exception(body["message"] ?? "Registrasi gagal");
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _headers,
    ).timeout(AppConfig.connectionTimeout);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body["data"];
    }

    throw Exception(body["message"] ?? "Gagal mengambil profil");
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      }),
    ).timeout(AppConfig.connectionTimeout);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body["data"];
    }

    throw Exception(body["message"] ?? "Gagal update profil");
  }
}
