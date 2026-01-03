import 'package:flutter/cupertino.dart';

class TransactionItem {
  final String name;
  final String category;
  final double amount;
  final String time;
  final String date;
  final IconData icon;
  final Color color;

  TransactionItem({
    required this.name,
    required this.category,
    required this.amount,
    required this.time,
    required this.date,
    required this.icon,
    required this.color,
  });
}
