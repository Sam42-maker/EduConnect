import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Base URL untuk Chrome Web emulator yang menembak backend lokal
  static const String baseUrl = 'http://34.128.96.164:5000/api';

  // Menyimpan token dan data user ke penyimpanan lokal (Shared Preferences)
  static Future<void> saveUserData(String token, String userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setString('user_id', userId);
    await prefs.setString('user_role', role);
  }

  // Mengambil token untuk otorisasi
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
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

      final data = jsonDecode(response.body);
      
      // Walau register, jika backend mengembalikan id/role, bisa kita simpan. 
      // Tapi backend tidak mengembalikan token di register saat ini.
      // Kita asumsikan token didapat saat login.
      if (response.statusCode == 201 && data['user'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['user']['id'].toString());
        await prefs.setString('user_role', data['user']['role'].toString());
      }

      return data;
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
        await saveUserData(
          data['token'],
          data['user']['id'].toString(),
          data['user']['role'].toString()
        );
      }
      
      return data;
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // Fungsi Lupa Password
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal terhubung ke server: $e'};
    }
  }
}
