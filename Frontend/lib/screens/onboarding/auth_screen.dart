import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
// import 'akademik_screen.dart'; // Akan di-uncomment di Fase 4

class AuthScreen extends StatefulWidget {
  final String role; // Menerima data peran dari RoleScreen
  const AuthScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // State untuk mengontrol tampilan (True = Layar Login, False = Layar Sign Up)
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2B5C43)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul dinamis berdasarkan state
              Text(
                isLogin ? 'Login' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'As ${widget.role}', // Menampilkan peran (Student/Mentor)
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // Memanggil kotak isian dari Fase 1
              // Jika Sign Up (isLogin == false), munculkan input Full Name
              if (!isLogin) ...[
                const CustomTextField(
                  label: 'Full Name',
                  hintText: 'Enter Name',
                ),
                const SizedBox(height: 16),
              ],

              const CustomTextField(
                label: 'Alamat Gmail',
                hintText: 'nama@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              const CustomTextField(
                label: 'Password',
                hintText: 'Enter Password',
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // Jika Sign Up, munculkan konfirmasi password
              if (!isLogin) ...[
                const CustomTextField(
                  label: 'Confirm Password',
                  hintText: 'Enter Password',
                  isPassword: true,
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 32),

              // Tombol utama dari Fase 1
              CustomButton(
                text: 'Lanjut',
                onPressed: () {
                  // TODO: Arahkan ke AkademikScreen (Fase 4)
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const AkademikScreen()));
                },
              ),
              const SizedBox(height: 24),

              // Bagian Toggle UI (Login <-> Sign Up)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "Don't have an account? " : "Sudah punya akun? ",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin; // Membalikkan state layar
                      });
                    },
                    child: Text(
                      isLogin ? 'Sign up' : 'Masuk',
                      style: const TextStyle(
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
