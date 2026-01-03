import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../res/colors/app_color.dart';
import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final List<TextEditingController> otpController = List.generate(
    4,
    (index) => TextEditingController(),
  );

  //--------------Supabase Client---------------

  final supabase = Supabase.instance.client;
  final themeController = Get.find<ThemeController>();

  /// Move focus automatically to next box

  void _nextField(String value, int index) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).nextFocus();
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Title
                  Text(
                    "Verification Code",
                    style: TextStyle(
                      fontFamily: AppFonts.TenorSans,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  10.heightBox,
                  Text(
                    "Please enter the 4-digit code sent to your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  40.heightBox,
                  /// 4 OTP boxes (Card Style)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 60,
                        height: 65,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              blurRadius: 12,
                              offset: const Offset(6, 6),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: otpController[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                          ),
                          onChanged: (value) => _nextField(value, index),
                        ),
                      ),
                    ),
                  ),
                  40.heightBox,
                  // final code = otpController
                  // .map((controller) => controller.text)
                  // .join();
                  /// Verify button
                  AuthButton(
                    text: "Verify OTP",
                    onTap: () async {
                      // 1. Combine the 4 individual characters into one string
                      final code = otpController
                          .map((controller) => controller.text)
                          .join();
                      try {
                        await supabase.auth.verifyOTP(
                          email: Get.arguments,
                          token: code
                              .trim(), // <--- USE 'code' HERE INSTEAD OF 'otpController'
                          type: OtpType.recovery,
                        );
                        Get.snackbar(
                          "Verified",
                          "OTP verified successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Get.toNamed(RouteName.NewPasswordView);
                      } catch (e) {
                        Get.snackbar(
                          "Invalid OTP",
                          e.toString(),
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                  30.heightBox,
                  /// Resend code option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn’t receive the code? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      InkWell(
                        onTap: () {
                          Get.snackbar(
                            "Code Sent",
                            "A new verification code has been sent.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
