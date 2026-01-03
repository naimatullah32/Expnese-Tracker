import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../res/components/gradient_button.dart';
import '../../res/fonts/app_fonts.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final confirm = TextEditingController();
  bool hide1 = true, hide2 = true;
  final themeController = Get.find<ThemeController>();
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

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
                  Text("New Password", style: TextStyle(fontFamily: AppFonts.TenorSans, fontSize: 26, fontWeight: FontWeight.bold, color: textPrimary)),
                  6.heightBox,
                  Text("Set your new password to secure your account", style: TextStyle(color: textSecondary), textAlign: TextAlign.center),
                  40.heightBox,

                  _cardPasswordField(isDark: isDark, textPrimary: textPrimary, textSecondary: textSecondary, controller: pass, hint: "New Password", hide: hide1, toggle: () => setState(() => hide1 = !hide1)),
                  16.heightBox,
                  _cardPasswordField(isDark: isDark, textPrimary: textPrimary, textSecondary: textSecondary, controller: confirm, hint: "Confirm Password", hide: hide2, toggle: () => setState(() => hide2 = !hide2), match: pass),

                  40.heightBox,
                  AuthButton(
                    text: "Change Password",
                    onTap: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await supabase.auth.updateUser(UserAttributes(password: pass.text.trim()));
                        Get.offAllNamed(RouteName.passSuccess);
                      } catch (e) {
                        Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
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

  Widget _cardPasswordField({required bool isDark, required Color textPrimary, required Color textSecondary, required TextEditingController controller, required String hint, required bool hide, required VoidCallback toggle, TextEditingController? match}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.09), blurRadius: 12, offset: const Offset(6, 6))],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: hide,
        style: TextStyle(color: textPrimary),
        validator: (v) {
          if (v == null || v.isEmpty) return "Please enter password";
          if (match != null && v != match.text) return "Passwords do not match";
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textSecondary),
          prefixIcon: Icon(Icons.lock_outline, color: textSecondary),
          suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility_off : Icons.visibility, color: textSecondary), onPressed: toggle),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}