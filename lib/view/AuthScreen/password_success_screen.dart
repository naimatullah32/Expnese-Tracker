import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class PasswordSuccessView extends StatefulWidget {
  const PasswordSuccessView({super.key});

  @override
  State<PasswordSuccessView> createState() => _PasswordSuccessViewState();
}

class _PasswordSuccessViewState extends State<PasswordSuccessView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/Success.json',
                width: 300,
                repeat: true,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                  _controller.forward();
                },
              ),
              30.heightBox,
              Text("Password Changed!", style: TextStyle(fontFamily: AppFonts.TenorSans, fontSize: 26, fontWeight: FontWeight.bold, color: textPrimary)),
              12.heightBox,
              Text(
                "Your password has been reset successfully.\nYou can now login with your new password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textSecondary, fontSize: 15, height: 1.5),
              ),
              40.heightBox,
              AuthButton(
                text: "Back to Login",
                onTap: () => Get.offAllNamed(RouteName.loginView),
              ),
            ],
          ),
        ),
      );
    });
  }
}