import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Base URL untuk Chrome Web emulator yang menembak backend lokal
  static const String baseUrl = 'http://localhost:5000/api';

  // Menyimpan token ke penyimpanan lokal (Shared Preferences)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Mengambil token untuk otorisasi
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Fungsi Register (Sign Up)
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // Fungsi Login (Masuk)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      // Jika login berhasil dan dapat token, simpan tokennya
      if (response.statusCode == 200 && data['token'] != null) {
        await saveToken(data['token']);
      }
      
      return data;
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }
}
