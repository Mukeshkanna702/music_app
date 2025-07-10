import 'package:flutter/material.dart';
import 'package:music_app/screens/login_screen/login_signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _logoPositionAnimation;
  late Animation<double> _logoScaleAnimation;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Logo moves from center to top-left
    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // Center
      end: const Offset(-0.9, -0.9), // Top-left
    ).animate(_animation);

    // Logo scales down slightly
    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(_animation);

    // Start animation after a small delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward().then((_) {
        setState(() {
          _showButton = true; // Show button when animation completes
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with guitar
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/man_guitar.avif'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Initial white screen with centered Sony logo
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: 1 - _animation.value,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Image.asset(
                      isDark
                          ? 'assets/images/sony_text_white.png'
                          : 'assets/images/sony.png',
                      width: 100,
                    ),
                  ),
                ),
              );
            },
          ),

          // Animated curved white shape
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipPath(
                clipper: AnimatedLeftCurveClipper(_animation.value),
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: isDark ? Colors.grey[900] : Colors.white,
                ),
              );
            },
          ),

          // Animated Sony logo moving from center to top-left
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment(
                    _logoPositionAnimation.value.dx,
                    _logoPositionAnimation.value.dy),
                child: Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child:Image.asset(
                    isDark
                        ? 'assets/images/sony_text_white.png'
                        : 'assets/images/sony.png',
                    width: 160,
                  ),
                ),
              );
            },
          ),

          // "Let's start" button (only shows after animation completes)
          if (_showButton)
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_showButton)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginSignupScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // First show the text
                            AnimatedOpacity(
                              opacity: _showButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: const Text(
                                "Let's start",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7A0B0B),
                                ),
                              ),
                            ),
                            // Then show the icon with a small delay
                            AnimatedOpacity(
                              opacity: _showButton ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Color(0xFF7A0B0B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AnimatedLeftCurveClipper extends CustomClipper<Path> {
  final double animationValue;

  AnimatedLeftCurveClipper(this.animationValue);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.5, 0);

    // Animated top outward bulge
    path.quadraticBezierTo(
      size.width * (0.5 + 0.1 * animationValue),
      size.height * 0.15 * animationValue,
      size.width * (0.5 - 0.3 * animationValue),
      size.height * 0.5 * animationValue,
    );

    // Animated bottom inward dip
    path.quadraticBezierTo(
      size.width * (0.5 + 0.4 * animationValue),
      size.height * (0.5 + 0.3 * animationValue),
      size.width * (0.5 + 0.1 * animationValue),
      size.height,
    );

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}