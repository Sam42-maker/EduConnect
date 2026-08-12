import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF9F9F9,
      ), // Warna latar terang/putih tulang
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Nanti ganti dengan gambar maskot burung gagak
              const Icon(Icons.menu_book, size: 120, color: Color(0xFF2B5C43)),
              const SizedBox(height: 40),

              const Text(
                'Selamat Datang di\nEduConnect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Platform kolaborasi akademik untuk mahasiswa Indonesia. Temukan rekan belajar yang tepat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 40),

              // Kotak peringatan hijau pastel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7E8D5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Platform ini digunakan untuk tujuan akademik. Dengan mendaftar, kamu menyetujui penggunaan yang bertanggung jawab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const Spacer(),

              // Memanggil komponen tombol dari Fase 1
              CustomButton(
                text: 'Mulai Daftar',
                onPressed: () {
                  // TODO: Arahkan ke RoleScreen (Pilih Mentor/Student) di Fase 3
                },
              ),
              const SizedBox(height: 16),

              // Teks Login di bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Arahkan ke AuthScreen (Login) di Fase 3
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
