import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2700),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color lightGreen = Color(0xFFB8F7B4);
    const Color darkGreen = Color(0xFF1B4332);
    const Color brandColor = Color(0xFF2B5C43);
    const Color brandSecondary = Color(0xFFD7E8D5);

    return Scaffold(
      backgroundColor: lightGreen,
      body: Stack(
        children: [
          Column(
            children: [
              // --- HEADER SECTION ---
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: brandColor),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Row(
                      children: [
                        // Logo Badge (Kotak kecil)
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
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- MAIN CONTENT WITH TWO LAYERS ---
              Expanded(
                child: Row(
                  children: [
                    // Left side - Light Green
                    Expanded(flex: 35, child: Container(color: lightGreen)),

                    // Right side - Dark Green
                    Expanded(flex: 50, child: Container(color: darkGreen)),
                  ],
                ),
              ),
            ],
          ),

          // --- CENTERED CONTENT OVERLAY ---
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Connie_app.png',
                      width: 160,
                      height: 160,
                    ),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Edu',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B4332),
                          ),
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
