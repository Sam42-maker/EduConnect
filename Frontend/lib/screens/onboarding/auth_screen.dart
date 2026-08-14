import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/progress_step_indicator.dart';
import '../../services/api_client.dart';
import 'akademik_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF2B5C43);
    const Color brandSecondary = Color(0xFFD7E8D5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
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
                          'assets/images/Connie_app.png',
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
                        fontSize: 20,
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
                    const SizedBox(height: 16),
                    if (!isLogin) ...[
                      const CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Enter Password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 32),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Lanjut',
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              final fullName = _fullNameController.text.trim();

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
                                // Sukses -> Lanjut ke AkademikScreen (Onboarding selanjutnya)
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AkademikScreen(
                                      userName: fullName.isNotEmpty
                                          ? fullName
                                          : (result['user'] != null ? result['user']['email'] : 'Anindya Putri'),
                                    ),
                                  ),
                                );
                              } else {
                                // Gagal -> Tampilkan snackbar peringatan
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result['message'] ?? 'Login gagal'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
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
    );
  }
}
