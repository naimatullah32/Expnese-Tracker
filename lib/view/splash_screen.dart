import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../res/routes/routes_name.dart';
import '../view_models/controller/auth_controller/authController.dart';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  const SplashScreen({Key? key, this.isDark = false}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (authController.currentUser != null) {
      // User is logged in, go to Home
      Get.offAllNamed(RouteName.homeView);
    } else {
      // User not logged in, go to Login
      Get.offAllNamed(RouteName.loginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = widget.isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 160),
          Center(
            child: Image.asset(
              "assets/icons/logo.png",
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Expense Tracker",
            style: GoogleFonts.acme(
              color: textSecondary,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }
}
