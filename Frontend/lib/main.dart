import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const EduConnectApp());
}

class EduConnectApp extends StatelessWidget {
  const EduConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E5A40), // Warna Hijau EduConnect
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // Bisa diganti dengan GoogleFonts jika sudah di-install
      ),
      home: const AuthScreen(),
    );
  }
}
