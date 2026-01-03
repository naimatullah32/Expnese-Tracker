import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/auth_controller/authController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  final AuthController authController = Get.put(AuthController());
  final themeController = Get.find<ThemeController>(); // Added Theme Controller

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontFamily: AppFonts.TenorSans,
                        fontSize: 26,
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    6.heightBox,
                    Text(
                      "Login to your account",
                      style: TextStyle(color: textSecondary),
                    ),
                    30.heightBox,

                    _cardTextField(
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      controller: emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                      validator: (v) => v!.isEmpty ? "Please enter your email" : null,
                    ),

                    16.heightBox,

                    _cardTextField(
                      isDark: isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: hidePassword,
                      suffix: IconButton(
                        icon: Icon(
                          hidePassword ? Icons.visibility_off : Icons.visibility,
                          color: textSecondary,
                        ),
                        onPressed: () => setState(() => hidePassword = !hidePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Please enter password";
                        if (v.length < 8) return "Password must be at least 8 characters";
                        return null;
                      },
                    ),

                    10.heightBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => Get.toNamed(RouteName.forgotPasswordView),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                    24.heightBox,

                    AuthButton(
                      text: "Login",
                      onTap: () async {
                        if (!formKey.currentState!.validate()) return;
                        Get.dialog(
                          const Center(child: SpinKitCircle(color: Colors.white, size: 50.0)),
                          barrierDismissible: false,
                        );
                        try {
                          await authController.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          Get.back();
                          Get.snackbar("Success", "You have successfully logged in", backgroundColor: Colors.green, colorText: Colors.white);
                          Get.offAllNamed(RouteName.homeView);
                        } catch (e) {
                          Get.back();
                          Get.snackbar("Login Failed", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },
                    ),

                    25.heightBox,
                    Row(
                      children: [
                        Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                        10.widthBox,
                        Text("OR", style: TextStyle(color: textSecondary)),
                        10.widthBox,
                        Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                      ],
                    ),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(Icons.facebook, Colors.blue, isDark),
                        16.widthBox,
                        _socialImageButton("assets/images/google.png", isDark),
                      ],
                    ),
                    30.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: TextStyle(color: textSecondary)),
                        InkWell(
                          onTap: () => Get.toNamed(RouteName.SignUp),
                          child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary)),
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

  Widget _cardTextField({
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Widget? suffix,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 12, offset: const Offset(0, 6)),
        ],
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

  Widget _socialButton(IconData icon, Color color, bool isDark) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
      child: Icon(icon, color: color, size: 30),
    );
  }

  Widget _socialImageButton(String image, bool isDark) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
      padding: const EdgeInsets.all(10),
      child: Image.asset(image),
    );
  }
}