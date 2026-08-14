import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_step_indicator.dart';

import '../main_navigation_screen.dart';

class EndScreen extends StatelessWidget {
  final String userName;

  const EndScreen({Key? key, this.userName = 'Anindya Putri'})
    : super(key: key);

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
                      width: 56,
                      height: 56,
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
            child: const ProgressStepIndicator(currentStep: 5),
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7E8D5),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/Connie_app.png',
                              width: 130,
                              height: 130,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Selamat\nBelajar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2B5C43),
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'Mulai ➔',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MainNavigationScreen(userName: userName),
                          ),
                          (route) => false,
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
