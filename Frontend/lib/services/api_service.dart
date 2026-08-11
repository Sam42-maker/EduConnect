import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // URL dinamis: localhost untuk Web, 10.0.2.2 untuk Android Emulator
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/auth';
    } else {
      return 'http://10.0.2.2:5000/api/auth';
    }
  }

  static Future<Map<String, dynamic>> register(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Gagal menghubungi server: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      // Simpan token jika berhasil
      if (response.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
      }
      
      return data;
    } catch (e) {
      return {'message': 'Gagal menghubungi server: $e'};
    }
  }
}
