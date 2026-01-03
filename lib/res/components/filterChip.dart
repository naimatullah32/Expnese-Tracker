// widgets/filter_chip.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_models/controller/Transaction_controller/transactionController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class FilterChipItem extends StatelessWidget {
  final String title;
  final TransactionsController controller;

  FilterChipItem({
    super.key,
    required this.title,
    required this.controller,
  });

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.selectedFilter.value == title;
      final isDark = themeController.isDarkMode.value;

      // Colors logic
      final inactiveCardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      final inactiveTextColor = isDark ? Colors.white70 : Colors.black;

      return GestureDetector(
        onTap: () => controller.changeFilter(title),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
              colors: [Colors.purple, Colors.indigo],
            )
                : null,
            color: isActive ? null : inactiveCardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black12,
                  blurRadius: 8
              ),
            ],
          ),
          child: Center( // Center text inside chip
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : inactiveTextColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
  }
}