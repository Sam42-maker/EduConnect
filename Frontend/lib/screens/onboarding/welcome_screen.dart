import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'auth_screen.dart';
import 'role_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Image.asset(
                'assets/images/Connie_app.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 32),

              const Text(
                'Selamat Datang di\nEduConnect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Platform kolaborasi akademik untuk mahasiswa Indonesia. Temukan rekan belajar yang tepat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7E8D5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Platform ini digunakan untuk tujuan akademik. Dengan mendaftar, kamu menyetujui penggunaan yang bertanggung jawab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),

              CustomButton(
                text: 'Mulai Daftar',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoleScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2B5C43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF2B5C43)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(
                            role: 'Student',
                            initialLogin: true,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
