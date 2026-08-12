import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import 'auth_screen.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  // Secara default, peran 'Student' akan terpilih lebih dulu
  String _selectedRole = 'Student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF2B5C43),
        ), // Tombol Back Hijau
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Choosee', // Sesuai desain UI di gambar
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
              const SizedBox(height: 20),

              // Kartu Pilihan "Student"
              GestureDetector(
                onTap: () => setState(() => _selectedRole = 'Student'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    // Warna berubah jika dipilih
                    color: _selectedRole == 'Student'
                        ? const Color(0xFFD7E8D5)
                        : Colors.white,
                    border: Border.all(
                      color: _selectedRole == 'Student'
                          ? const Color(0xFF2B5C43)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 80,
                        color: Color(0xFF2B5C43),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Student',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _selectedRole == 'Student'
                              ? const Color(0xFF2B5C43)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Kartu Pilihan "Mentor"
              GestureDetector(
                onTap: () => setState(() => _selectedRole = 'Mentor'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: _selectedRole == 'Mentor'
                        ? const Color(0xFFD7E8D5)
                        : Colors.white,
                    border: Border.all(
                      color: _selectedRole == 'Mentor'
                          ? const Color(0xFF2B5C43)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 80,
                        color: Color(0xFF2B5C43),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Mentor',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _selectedRole == 'Mentor'
                              ? const Color(0xFF2B5C43)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Tombol Lanjut menuju AuthScreen membawa data role yang dipilih
              CustomButton(
                text: 'Lanjut',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthScreen(role: _selectedRole),
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
