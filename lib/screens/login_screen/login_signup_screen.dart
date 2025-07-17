import 'package:flutter/material.dart';
import 'package:music_app/screens/home_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool showLoginForm = true;
  final _formKey = GlobalKey<FormState>();

  // Login form controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Signup form controllers
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Password visibility states
  bool _loginPasswordVisible = false;
  bool _signupPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background with curved design (same as before)
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.35,
                  child: ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            showLoginForm
                                ? 'assets/images/electric_guitar.webp'
                                : 'assets/images/singer_for_signup.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          SingleChildScrollView(
            child: SafeArea(
              child: SizedBox(
                height: screenHeight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sony Logo
                      Image.asset(
                        isDarkMode
                            ? 'assets/images/sony_white.png'
                            : 'assets/images/sony_white.png',
                        height: 80,
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      // Login or Signup Form
                      Card(
                        elevation: 4,
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: showLoginForm
                              ? _buildLoginForm(isDarkMode)
                              : _buildSignupForm(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Log in',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 30),

          // Email Field
          TextFormField(
            controller: _loginEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or username';
              }
              if (!value.contains('@') && !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return 'Please enter a valid email or username';
              }
              return null;
            },
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Enter email or username',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            ),
          ),
          const SizedBox(height: 20),

          // Password Field with visibility toggle
          TextFormField(
            controller: _loginPasswordController,
            obscureText: !_loginPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              suffixIcon: IconButton(
                icon: Icon(
                  _loginPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: isDarkMode ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _loginUser();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New User?',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showLoginForm = false;
                    _formKey.currentState?.reset();
                  });
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

// Continue with Google Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Implement Google sign-in logic here
                print("Continue with Google pressed");
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: 24,
              ),
              label: Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode? Colors.white : Colors.black,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: isDarkMode? Colors.black : Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildSignupForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 30),

          // Email Field
          TextFormField(
            controller: _signupEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            ),
          ),
          const SizedBox(height: 20),

          // Password Field with visibility toggle
          TextFormField(
            controller: _signupPasswordController,
            obscureText: !_signupPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
                return 'Password must contain letters and numbers';
              }
              return null;
            },
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              suffixIcon: IconButton(
                icon: Icon(
                  _signupPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _signupPasswordVisible = !_signupPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Confirm Password Field with visibility toggle
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _signupPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signupUser();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showLoginForm = true;
                    _formKey.currentState?.reset();
                  });
                },
                child: Text(
                  'Log in',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

// Continue with Google Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Implement Google sign-in logic here
                print("Continue with Google pressed");
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: 24,
              ),
              label: Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode? Colors.white : Colors.black,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: isDarkMode? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser() {
    final email = _loginEmailController.text;
    final password = _loginPasswordController.text;
    print('Logging in with email: $email, password: $password');
  }

  void _signupUser() {
    final email = _signupEmailController.text;
    final password = _signupPasswordController.text;
    print('Signing up with email: $email, password: $password');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3/4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}