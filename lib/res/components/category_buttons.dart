import 'package:flutter/material.dart';

class CategoryButtons extends StatefulWidget {
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const CategoryButtons({
    super.key,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  int selectedIndex = 0; // Track the selected category

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': Icons.fastfood},
    {'name': 'Shopping', 'icon': Icons.shopping_bag},
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Home', 'icon': Icons.home},
    {'name': 'Entertainment', 'icon': Icons.music_note},
    {'name': 'Travel', 'icon': Icons.airplanemode_active},
    {'name': 'Gifts', 'icon': Icons.card_giftcard},
    {'name': 'Other', 'icon': Icons.category},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust height as needed (for 2 rows + spacing)
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 16,     // Horizontal spacing between buttons
          runSpacing: 16,  // Vertical spacing between rows
          alignment: WrapAlignment.start,
          children: List.generate(categories.length, (index) {
            final item = categories[index];
            final bool isActive = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: isActive
                      ? const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isActive ? null : widget.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      color: isActive ? Colors.white : widget.textSecondary,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'] as String,
                      style: TextStyle(
                        color: isActive ? Colors.white : widget.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}