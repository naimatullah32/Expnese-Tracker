import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String amount;
  final double progress;
  final IconData icon;
  final Color color;
  final bool isDark;

  const CategoryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.progress,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF18181B) : Colors.white;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}
