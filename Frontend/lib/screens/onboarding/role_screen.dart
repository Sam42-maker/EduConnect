import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_step_indicator.dart';
import 'auth_screen.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String _selectedRole = 'Student';

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
                      width: 38,
                      height: 38,
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
            child: const ProgressStepIndicator(currentStep: 2),
          ),

          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Choose Role',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'Student'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: _selectedRole == 'Student'
                              ? const Color(0xFF94D1A0)
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFFA69D9D),
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
                    GestureDetector(
                      onTap: () => setState(() => _selectedRole = 'Mentor'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: _selectedRole == 'Mentor'
                              ? const Color(0xFF94D1A0)
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFFA69D9D),
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
                    CustomButton(
                      text: 'Lanjut',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AuthScreen(role: _selectedRole),
                          ),
                        );
                      },
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
