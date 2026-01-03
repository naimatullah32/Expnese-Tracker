import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/controller/auth_controller/authController.dart';
import '../../view_models/controller/profile_controller/profileController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';
import '../../view_models/controller/expense_controller/expense_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final authController = Get.find<AuthController>();
  final profileController = Get.put(ProfileController());
  final themeController = Get.find<ThemeController>();
  final expenseController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA);
      final cardColor = isDark ? const Color(0xFF18181B) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      final List<BoxShadow> dynamicShadow = [
        BoxShadow(
          color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ];

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    // Theme Switcher Button
                    GestureDetector(
                      onTap: () => themeController.toggleTheme(),
                      child: _iconButton(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        cardColor,
                        isDark ? Colors.amber : Colors.indigo,
                        dynamicShadow,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// MAIN PROFILE CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: dynamicShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurple, Colors.indigo],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              profileController.firstChar,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController.fullName,
                                  style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  authController.supabase.auth.currentUser?.email ?? "User Email",
                                  style: TextStyle(color: textSecondary, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),

                      /// STATS (Connected to Controllers)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statItem(profileController.totalTransactions, "Transactions", textPrimary, textSecondary),
                          _statItem(profileController.totalCategories, "Categories", textPrimary, textSecondary),
                          _statItem("Active", "Status", textPrimary, textSecondary),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// QUICK STATS GRID
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _quickStat(Icons.trending_up, "\$${expenseController.totalIncome.value.toStringAsFixed(0)}", "Income",
                        Colors.green, cardColor, textPrimary, textSecondary, dynamicShadow),
                    _quickStat(Icons.trending_down, "\$${expenseController.totalExpense.value.toStringAsFixed(0)}", "Spent",
                        Colors.redAccent, cardColor, textPrimary, textSecondary, dynamicShadow),
                    _quickStat(Icons.account_balance,"\$${expenseController.totalBalance.value.toStringAsFixed(0)}", "Total Balance",
                        Colors.blue, cardColor, textPrimary, textSecondary, dynamicShadow),
                  ],
                ),

                const SizedBox(height: 28),

                /// ACCOUNT SETTINGS SECTION
                _sectionHeader("Account Settings", textPrimary),
                const SizedBox(height: 12),
                _menuItem("Personal Info", Icons.person_outline, cardColor, textPrimary, textSecondary, dynamicShadow),
                _menuItem("Notification Settings", Icons.notifications_none, cardColor, textPrimary, textSecondary, dynamicShadow),
                _menuItem("App Privacy", Icons.lock_outline, cardColor, textPrimary, textSecondary, dynamicShadow),

                const SizedBox(height: 28),

                /// LOGOUT ACTION
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: "Logout",
                      middleText: "Are you sure you want to sign out?",
                      textConfirm: "Yes",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        Get.back(); // Dialog band karein
                        authController.logout(); // Logout call karein
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.red.withOpacity(0.1) : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.2)),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Sign Out",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  /// -------------------- WIDGET HELPERS --------------------

  Widget _sectionHeader(String title, Color textPrimary) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );
  }

  Widget _iconButton(IconData icon, Color cardColor, Color color, List<BoxShadow> shadow) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), boxShadow: shadow),
      child: Icon(icon, color: color),
    );
  }

  Widget _statItem(String value, String label, Color textPrimary, Color textSecondary) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: textSecondary)),
      ],
    );
  }

  Widget _quickStat(IconData icon, String value, String label, Color color,
      Color cardColor, Color textPrimary, Color textSecondary, List<BoxShadow> shadow) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), boxShadow: shadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
          Text(label, style: TextStyle(color: textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, Color cardColor, Color textPrimary, Color textSecondary, List<BoxShadow> shadow) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), boxShadow: shadow),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: textSecondary, size: 22),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
            ],
          ),
          Icon(Icons.chevron_right, color: textSecondary),
        ],
      ),
    );
  }
}