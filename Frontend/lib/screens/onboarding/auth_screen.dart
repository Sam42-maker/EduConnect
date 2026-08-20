import 'package:frontend/services/api_client.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/progress_step_indicator.dart';
import '../../services/api_client.dart';
import 'akademik_screen.dart';
import '../home/main_navigation_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role;
  final bool initialLogin;

  const AuthScreen({Key? key, required this.role, this.initialLogin = false})
    : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  
  bool isRecaptchaVerified = false;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialLogin;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _customAlertMessage;
  bool _showForgotDialog = false;
  final TextEditingController _resetEmailController = TextEditingController();
  bool _isResetting = false;

  void _showCustomAlert(String message) {
    setState(() {
      _customAlertMessage = message;
    });
  }

  void _showForgotPasswordDialog() {
    setState(() {
      _showForgotDialog = true;
    });
  }

  Widget _buildInPageCustomAlert() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/models/Connie_think.png',
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'lib/models/Connie_app.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _customAlertMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Tutup',
                  onPressed: () => setState(() => _customAlertMessage = null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInPageForgotDialog() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Lupa Password?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Masukkan email Anda. Kami akan menghasilkan password baru secara otomatis.'),
                const SizedBox(height: 16),
                TextField(
                  controller: _resetEmailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => setState(() => _showForgotDialog = false), child: const Text('Batal')),
                    const SizedBox(width: 8),
                    _isResetting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B5C43)),
                            onPressed: () async {
                              if (_resetEmailController.text.trim().isEmpty) return;
                              setState(() => _isResetting = true);
                              final result = await ApiClient.forgotPassword(_resetEmailController.text.trim());
                              
                              setState(() {
                                _isResetting = false;
                                _showForgotDialog = false;
                              });

                              if (result['newPassword'] != null) {
                                _showCustomAlert('Password berhasil direset!\n\nPassword baru Anda:\n${result['newPassword']}');
                              } else {
                                _showCustomAlert(result['message'] ?? 'Gagal mereset password');
                              }
                            },
                            child: const Text('Reset', style: TextStyle(color: Colors.white)),
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF2B5C43);
    const Color brandSecondary = Color(0xFFD7E8D5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          Column(
            children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: brandColor),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: brandSecondary),
                      child: Center(
                        child: Image.asset(
                          'lib/models/Connie_app.png',
                          width: 56,
                          height: 56,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'EduConnect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: const ProgressStepIndicator(currentStep: 3),
          ),

          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      'As ${widget.role}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!isLogin) ...[
                      CustomTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        hintText: 'Enter Name',
                      ),
                      const SizedBox(height: 16),
                    ],
                    CustomTextField(
                      controller: _emailController,
                      label: 'Alamat Gmail',
                      hintText: 'nama@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter Password',
                      isPassword: true,
                    ),

                    if (isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF2B5C43), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (!isLogin) ...[
                      const CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Enter Password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isRecaptchaVerified,
                            activeColor: const Color(0xFF2B5C43),
                            onChanged: (bool? value) {
                              setState(() {
                                isRecaptchaVerified = value ?? false;
                              });
                            },
                          ),
                          const Text('Saya bukan robot (Mock)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Image.asset('lib/models/Connie_app.png', width: 40, height: 40),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Lanjut',
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              final fullName = _fullNameController.text.trim();

                              if (email.isEmpty || password.isEmpty || (!isLogin && fullName.isEmpty)) {
                                _showCustomAlert('Ups! Semua kolom wajib diisi ya.');
                                return;
                              }

                              if (!isLogin && password.length < 8) {
                                _showCustomAlert('Ups! Password minimal harus 8 karakter.');
                                return;
                              }

                              if (!isRecaptchaVerified) {
                                _showCustomAlert('Ups! Tolong centang kotak reCAPTCHA (Saya bukan robot).');
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              Map<String, dynamic> result;
                              if (isLogin) {
                                result = await ApiClient.login(
                                  email: email,
                                  password: password,
                                );
                              } else {
                                result = await ApiClient.register(
                                  fullName: fullName,
                                  email: email,
                                  password: password,
                                  role: widget.role,
                                );
                              }

                              setState(() {
                                isLoading = false;
                              });

                              if (result.containsKey('token') || result['message']?.contains('berhasil') == true) {
                                // Sukses
                                if (!mounted) return;
                                
                                String displayName = 'Mahasiswa';
                                if (fullName.isNotEmpty) {
                                  displayName = fullName;
                                } else if (result['user'] != null) {
                                  displayName = result['user']['name'] ?? result['user']['email'] ?? 'Mahasiswa';
                                }

                                if (isLogin) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainNavigationScreen(
                                        userName: displayName,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AkademikScreen(
                                        userName: displayName,
                                        role: widget.role,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // Gagal -> Tampilkan custom alert
                                if (!mounted) return;
                                _showCustomAlert(result['message'] ?? 'Login gagal');
                              }
                            },
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? "Don't have an account? "
                              : "Sudah punya akun? ",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
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
          ),
          ],
          ),
          
          if (_customAlertMessage != null)
            _buildInPageCustomAlert(),

          if (_showForgotDialog)
            _buildInPageForgotDialog(),
        ],
      ),
    );
  }
}
