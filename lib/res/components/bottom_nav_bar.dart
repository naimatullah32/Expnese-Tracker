import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/navBarItem/navbar_item.dart';
import '../../view_models/controller/nav_bar_controller/NavBarController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart'; // ✅ Import karein

class BottomNavBar extends StatelessWidget {
  final bool isDark; // MainView se aa raha hai
  final int activeIndex;

  BottomNavBar({super.key, this.isDark = false, required this.activeIndex});

  final controller = Get.put(BottomNavController());
  final themeController = Get.find<ThemeController>(); // ✅ Live theme access

  final List<NavItem> items = [
    NavItem(label: "Home", icon: Icons.home_rounded),
    NavItem(label: "Analytics", icon: Icons.bar_chart_rounded),
    NavItem(label: "Add", icon: Icons.add, isSpecial: true),
    NavItem(label: "History", icon: Icons.receipt_long_rounded),
    NavItem(label: "Profile", icon: Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ Obx ko yahan lagana zaroori hai taaki poora bar colors change kare
    return Obx(() {
      // Hum direct controller se value utha rahe hain taaki koi mistake na ho
      final dark = themeController.isDarkMode.value;

      final bgColor = dark ? const Color(0xFF18181B) : Colors.white;
      final borderColor = dark ? const Color(0xFF27272A) : const Color(0xFFE5E7EB);
      final inactiveColor = dark ? Colors.grey.shade400 : Colors.grey.shade600;
      final activeColor = dark ? const Color(0xFFA78BFA) : Colors.deepPurple;

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = controller.currentIndex.value == index;

            if (item.isSpecial) {
              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(dark ? 0.4 : 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.label, style: TextStyle(fontSize: 11, color: inactiveColor)),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 24, color: isActive ? activeColor : inactiveColor),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}