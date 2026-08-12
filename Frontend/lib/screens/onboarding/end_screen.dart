import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
// import '../home_screen.dart'; // Akan digunakan saat Home Screen sudah dibuat

class EndScreen extends StatelessWidget {
  const EndScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Elemen Visual Maskot & Ucapan Selamat
              Stack(
                alignment: Alignment.center,
                children: [
                  // Latar Belakang Hijau Pastel (Senada dengan desain)
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7E8D5),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  // Konten Teks & Icon Maskot
                  const Column(
                    children: [
                      // TODO: Ganti Icon ini dengan aset gambar burung gagakmu nanti
                      Icon(Icons.school, size: 90, color: Color(0xFF2B5C43)),
                      SizedBox(height: 16),
                      Text(
                        'Selamat\nBelajar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2B5C43),
                          height: 1.2, // Mengatur jarak antar baris agar rapi
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Tombol Akhir untuk Masuk ke Aplikasi Utama
              CustomButton(
                text: 'Mulai ➔',
                onPressed: () {
                  // Praktik Terbaik UX: Gunakan pushAndRemoveUntil agar
                  // pengguna tidak bisa menekan tombol "Back" kembali ke form registrasi
                  // setelah berhasil masuk ke Home Screen.

                  /* TODO: Buka komentar ini saat home_screen.dart sudah siap
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false, // Menghapus semua riwayat halaman sebelumnya
                  );
                  */

                  // Pop-up sementara sebelum HomeScreen dibuat
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hore! Alur Onboarding Selesai! Masuk ke Home...',
                      ),
                      backgroundColor: Color(0xFF2B5C43),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
