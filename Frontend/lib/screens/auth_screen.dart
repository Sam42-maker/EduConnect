import 'package:flutter/material.dart';
import 'verification_screen.dart';
import 'main_layout.dart';
import '../services/api_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final Color primaryGreen = const Color(0xFF2E5A40);

  // Controllers untuk membaca inputan teks
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submitForm() async {
    // Validasi kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong!'))
      );
      return;
    }

    setState(() => isLoading = true);

    if (isLogin) {
      // PROSES LOGIN
      final result = await ApiService.login(emailController.text, passwordController.text);
      setState(() => isLoading = false);
      
      if (result['token'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Berhasil!')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLayout()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Login gagal')));
      }
    } else {
      // PROSES REGISTER
      if (nameController.text.isEmpty) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama lengkap tidak boleh kosong!')));
        return;
      }

      final result = await ApiService.register(nameController.text, emailController.text, passwordController.text);
      setState(() => isLoading = false);

      if (result['message'] != null && result['message'].toString().contains('berhasil')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi Sukses! OTP telah dibuat.')));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VerificationScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Registrasi gagal')));
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 40, color: primaryGreen),
                  const SizedBox(width: 10),
                  Text(
                    'EduConnect',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                isLogin ? 'Login' : 'Sign Up',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              if (!isLogin) ...[
                _buildTextField('Full Name', 'Enter Name', controller: nameController),
                const SizedBox(height: 16),
                _buildPhoneField(), // Phone UI Dummy
                const SizedBox(height: 16),
              ],

              _buildTextField(isLogin ? 'Email' : 'Alamat Gmail', 'Enter Email', controller: emailController),
              const SizedBox(height: 16),
              _buildTextField('Password', 'Enter Password', isPassword: true, controller: passwordController),
              
              if (!isLogin) ...[
                const SizedBox(height: 16),
                _buildTextField('Confirm Password', 'Enter Password', isPassword: true), // Confirm Password Dummy UI
              ],

              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin ? 'Login' : 'Lanjut',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  isLogin ? 'Or Login with' : 'Or sign up with',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialBtn('G', Colors.red),
                  const SizedBox(width: 16),
                  _buildSocialBtn('f', Colors.blue),
                  const SizedBox(width: 16),
                  _buildSocialBtn('X', Colors.black),
                ],
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "Don't have an account? " : "Sudah punya akun? ",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Sign up' : 'Masuk',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool isPassword = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryGreen)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phone Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
              child: const Text('+62 ▼', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryGreen)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialBtn(String text, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
