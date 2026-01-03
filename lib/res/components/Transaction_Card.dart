// widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX import kiya
import '../../models/TransactionModel/transaction_model.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart'; // Apna path check kar lein

class TransactionCard extends StatelessWidget {
  final TransactionItem item;

  TransactionCard({super.key, required this.item});

  // Theme Controller ko find karein
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isIncome = item.amount > 0;

    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      // Dynamic Colors
      final cardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black87;
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor, // Fixed: Ab ye dark mode mein visible hoga
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textPrimary, // Dynamic text color
                      ),
                    ),
                    Text(
                      item.category,
                      style: TextStyle(
                        color: textSecondary, // Dynamic sub-text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${item.amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isIncome ? Colors.greenAccent.shade700 : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  item.time,
                  style: TextStyle(
                    color: textSecondary, // Dynamic time color
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}