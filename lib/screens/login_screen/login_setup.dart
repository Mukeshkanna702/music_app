import 'dart:async';
import 'package:flutter/material.dart';

class LoginSetup extends StatefulWidget {
  const LoginSetup({super.key});

  @override
  State<LoginSetup> createState() => _LoginSetupState();
}

class _LoginSetupState extends State<LoginSetup> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/images/music_1.jpg',
    'assets/images/music_2.jpg',
    'assets/images/music_3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startSlider();
  }

  void _startSlider() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _currentPage++;
      if (_currentPage >= _images.length) {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          // You can add your login form here over the background
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Optional dark overlay
              child: Center(
                child: Text(
                  'Login Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
