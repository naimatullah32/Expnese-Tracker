// widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class TransactionSearchBar extends StatelessWidget {
  const TransactionSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final cardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black87;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 10,
            )
          ],
        ),
        child: TextField(
          style: TextStyle(color: textPrimary), // Typing text color
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: isDark ? Colors.grey : Colors.black54),
            hintText: 'Search transactions...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      );
    });
  }
}