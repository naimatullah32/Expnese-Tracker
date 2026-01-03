import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final bool isSpecial;

  NavItem({
    required this.label,
    required this.icon,
    this.isSpecial = false,
  });
}
