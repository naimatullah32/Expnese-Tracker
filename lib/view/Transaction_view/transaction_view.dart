import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../view_models/controller/Transaction_controller/transactionController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class TransactionsView extends StatelessWidget {
  TransactionsView({super.key});

  // Controllers initialize karein
  final transController = Get.put(TransactionsController());
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : const Color(0xffF9FAFB);
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  onChanged: (value) => transController.searchQuery.value = value,
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: "Search transactions...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildChip('All'),
                      _buildChip('Income'),
                      _buildChip('Expense'),
                      _buildChip('Food'),
                      _buildChip('Shopping'),
                      _buildChip('Transport'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Transactions List
                Expanded(
                  child: Obx(() {
                    final list = transController.filteredTransactions;

                    if (list.isEmpty) {
                      return const Center(
                        child: Text("No transactions found",
                            style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return TransactionCard(item: list[index]);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Helper Widget for Chips
  Widget _buildChip(String title) {
    return Obx(() {
      final isActive = transController.selectedFilter.value == title;
      final isDark = themeController.isDarkMode.value;

      return GestureDetector(
        onTap: () => transController.changeFilter(title),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: isActive ? const LinearGradient(colors: [Colors.purple, Colors.indigo]) : null,
            color: isActive ? null : (isDark ? const Color(0xFF27272A) : Colors.white),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [if(!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.black),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> item;
  TransactionCard({super.key, required this.item});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isIncome = item['type'] == 'income';
    final amount = double.tryParse(item['amount'].toString()) ?? 0.0;
    final date = DateTime.tryParse(item['date_time']) ?? DateTime.now();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [if(!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: (isIncome ? Colors.green : Colors.orange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                      isIncome ? Icons.trending_up : Icons.receipt_long,
                      color: isIncome ? Colors.green : Colors.orange
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['description'] == "" ? item['category'] : item['description'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87
                      ),
                    ),
                    Text(item['category'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isIncome ? Colors.greenAccent.shade700 : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}