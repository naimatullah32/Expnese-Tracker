import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/auth_controller/authController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  final AuthController authController = Get.put(AuthController());
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontFamily: AppFonts.TenorSans,
                        fontSize: 26,
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    6.heightBox,
                    Text("Fill in your details", style: TextStyle(color: textSecondary)),
                    30.heightBox,

                    _cardField(isDark: isDark, textPrimary: textPrimary, textSecondary: textSecondary, controller: firstName, hint: "First Name", icon: Icons.person_outline, validator: (v) => v!.isEmpty ? "First name required" : null),
                    16.heightBox,
                    _cardField(isDark: isDark, textPrimary: textPrimary, textSecondary: textSecondary, controller: lastName, hint: "Last Name", icon: Icons.person_outline, validator: (v) => v!.isEmpty ? "Last name required" : null),
                    16.heightBox,
                    _cardField(isDark: isDark, textPrimary: textPrimary, textSecondary: textSecondary, controller: email, hint: "Email", icon: Icons.email_outlined, validator: (v) => v!.isEmpty ? "Email required" : null),
                    16.heightBox,
                    _cardField(
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      controller: password,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: hidePassword,
                      suffix: IconButton(
                        icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility, color: textSecondary),
                        onPressed: () => setState(() => hidePassword = !hidePassword),
                      ),
                      validator: (v) => (v == null || v.length < 8) ? "Password must be 8+ chars" : null,
                    ),

                    30.heightBox,
                    AuthButton(
                      text: "Sign Up",
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) return;
                        Get.dialog(const Center(child: SpinKitCircle(color: Colors.purple, size: 50.0)), barrierDismissible: false);

                        try {
                          await authController.signUp(
                            email: email.text.trim(),
                            password: password.text.trim(),
                            firstName: firstName.text.trim(),
                            lastName: lastName.text.trim(),
                            emailRedirectTo: 'https://yourapp.com/welcome',
                          );
                          Get.back();
                          Get.snackbar("Success", "Account created successfully", backgroundColor: Colors.green, colorText: Colors.white);
                          Get.offAllNamed(RouteName.loginView);
                        } catch (e) {
                          Get.back();
                          Get.snackbar("Login Failed", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },
                    ),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ", style: TextStyle(color: textSecondary)),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _cardField({required bool isDark, required Color textPrimary, required Color textSecondary, required TextEditingController controller, required String hint, required IconData icon, Widget? suffix, bool obscure = false, String? Function(String?)? validator}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textSecondary),
          prefixIcon: Icon(icon, color: textSecondary),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}