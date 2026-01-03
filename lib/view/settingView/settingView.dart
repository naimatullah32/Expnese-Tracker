import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../view_models/controller/theme_controller/theme_controller.dart';
// Apne controller ka sahi path yahan likhein
// import '../../view_models/controller/theme_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller ko find karein (Ensure Get.put() is done in main or previous screen)
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // Current theme state lein
      final bool isDark = themeController.isDarkMode.value;

      // Dynamic Colors
      final bgColor = isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA);
      final cardColor = isDark ? const Color(0xFF18181B) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Settings",
            style: GoogleFonts.inter(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Preferences Section
              _sectionHeader("Preferences", textSecondary),
              _settingsCard(cardColor, [
                _toggleTile(
                  "Dark Mode",
                  Icons.dark_mode_outlined,
                  isDark,
                  textPrimary,
                      (val) => themeController.toggleTheme(),
                ),
                _toggleTile(
                  "Notifications",
                  Icons.notifications_none_rounded,
                  true,
                  textPrimary,
                      (val) {},
                ),
                _navTile("Language", Icons.language_rounded, "English", textPrimary),
              ]),

              const SizedBox(height: 24),

              /// Security Section
              _sectionHeader("Security", textSecondary),
              _settingsCard(cardColor, [
                _navTile("Change Password", Icons.lock_outline_rounded, null, textPrimary),
                _toggleTile("Two-Factor Auth", Icons.shield_outlined, true, textPrimary, (v) {}),
                _toggleTile("Biometric Login", Icons.fingerprint_rounded, false, textPrimary, (v) {}),
              ]),

              const SizedBox(height: 24),

              /// Account Section
              _sectionHeader("Account", textSecondary),
              _settingsCard(cardColor, [
                _navTile("Subscription", Icons.credit_card_rounded, "Premium", textPrimary),
                _navTile("Connected Accounts", Icons.people_outline_rounded, null, textPrimary),
                _navTile("Privacy Policy", Icons.privacy_tip_outlined, null, textPrimary),
              ]),

              const SizedBox(height: 24),

              /// Support Section
              _sectionHeader("Support", textSecondary),
              _settingsCard(cardColor, [
                _navTile("Help Center", Icons.help_outline_rounded, null, textPrimary),
                _navTile("Contact Support", Icons.support_agent_rounded, null, textPrimary),
              ]),

              const SizedBox(height: 24),

              /// Danger Zone
              _sectionHeader("Danger Zone", Colors.redAccent),
              _settingsCard(cardColor, [
                _dangerTile("Clear Cache"),
                _dangerTile("Delete Account"),
              ]),
            ],
          ),
        ),
      );
    });
  }

  // ---------------- SECTION HEADER ----------------
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          color: color,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ---------------- CARD WRAPPER ----------------
  Widget _settingsCard(Color cardColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(children: children),
      ),
    );
  }

  // ---------------- NAV TILE ----------------
  Widget _navTile(String title, IconData icon, String? value, Color textPrimary) {
    return ListTile(
      leading: Icon(icon, color: textPrimary.withOpacity(0.7)),
      title: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value, style: TextStyle(color: textPrimary.withOpacity(0.5), fontSize: 13)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: textPrimary.withOpacity(0.3)),
        ],
      ),
      onTap: () {},
    );
  }

  // ---------------- TOGGLE TILE ----------------
  Widget _toggleTile(String title, IconData icon, bool value, Color textPrimary, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: textPrimary.withOpacity(0.7)),
      title: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
      activeColor: Colors.deepPurpleAccent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  // ---------------- DANGER TILE ----------------
  Widget _dangerTile(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.redAccent, size: 20),
      onTap: () {},
    );
  }
}