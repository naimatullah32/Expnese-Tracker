import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final bool isDark;

  const BalanceCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF18181B) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Balance", style: TextStyle(color: textSecondary)),
          const SizedBox(height: 8),
          Text("\$12,458.50",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.trending_up, color: Colors.green, size: 18),
              SizedBox(width: 4),
              Text("+12.5%", style: TextStyle(color: Colors.green)),
              SizedBox(width: 6),
              Text("from last month",
                  style: TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

