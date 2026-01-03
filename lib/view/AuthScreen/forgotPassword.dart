import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/auth_controller/authController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});
  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final themeController = Get.find<ThemeController>();

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final textSecondary = isDark
          ? Colors.grey.shade400
          : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontFamily: AppFonts.TenorSans,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  10.heightBox,
                  Text(
                    "Enter your email to receive an OTP code",
                    style: TextStyle(color: textSecondary),
                  ),
                  40.heightBox,
                  _cardTextField(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    controller: emailController,
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                    validator: (v) =>
                        v!.isEmpty ? "Please enter your email" : null,
                  ),
                  35.heightBox,
                  AuthButton(
                    text: "Send OTP",
                    onTap: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await authController.sendResetEmail(
                          emailController.text.trim(),
                        );
                        Get.snackbar(
                          "Email Sent",
                          "Check your email for reset link",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Get.toNamed(RouteName.NewPasswordView);
                      } catch (e) {
                        Get.snackbar(
                          "Error",
                          e.toString(),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _cardTextField({
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.09),
            blurRadius: 12,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textSecondary),
          prefixIcon: Icon(icon, color: textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
