import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../view_models/controller/expense_controller/expense_controller.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';

class AddExpenseView extends StatelessWidget {
  AddExpenseView({super.key});

  final themeController = Get.find<ThemeController>();
  final expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA);
      final cardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Transaction",
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 24),

                // Amount Input Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      Text("Amount", style: TextStyle(color: textSecondary)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("\$", style: TextStyle(fontSize: 36, color: textPrimary)),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: expenseController.amountController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 36, color: textPrimary),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: "0.00"),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Transaction Type Switcher
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _typeButton("expense", "Expense", Colors.redAccent, expenseController),
                          const SizedBox(width: 12),
                          _typeButton("income", "Income", Colors.greenAccent.shade700, expenseController),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text("Category", style: TextStyle(color: textPrimary)),
                const SizedBox(height: 15),
                // YAHAN AAPKA WIDGET HAI
                CategoryButtons(cardColor: cardColor, textPrimary: textPrimary, textSecondary: textSecondary),

                const SizedBox(height: 24),
                Text("Description", style: TextStyle(color: textPrimary)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: expenseController.noteController,
                    style: TextStyle(color: textPrimary),
                    decoration: const InputDecoration(
                        hintText: 'Add notes...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        prefixIcon: Icon(Iconsax.note_21, color: Colors.grey)),
                  ),
                ),

                const SizedBox(height: 24),
                const DateAndPaymentSection(),

                const SizedBox(height: 30),
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: expenseController.isLoading.value ? null : () => expenseController.addExpense(),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: expenseController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Transaction", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _typeButton(String type, String label, Color color, ExpenseController controller) {
    return Obx(() {
      bool isSelected = controller.transactionType.value == type;
      return ElevatedButton(
        onPressed: () {
          controller.transactionType.value = type;
          // Switch karte waqt pehli category select kar dein taaki UI update ho
          controller.selectedCategory.value = controller.currentCategories[0]['name'];
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey.withOpacity(0.2),
          elevation: isSelected ? 4 : 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
      );
    });
  }
}

// AAPKA CATEGORY WIDGET (With Switch Logic)
class CategoryButtons extends StatelessWidget {
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;
  CategoryButtons({super.key, required this.cardColor, required this.textPrimary, required this.textSecondary});

  final controller = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Ye controller se sahi categories uthayega (Income ya Expense)
      final activeCategories = controller.currentCategories;

      return SizedBox(
        height: 100, // Container ki height set ki hai taaki scroll area ban sakay
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scroll enable kiya
          itemCount: activeCategories.length,
          clipBehavior: Clip.none, // Shadows ya corners cut na hon
          itemBuilder: (context, index) {
            final cat = activeCategories[index];

            return Obx(() {
              bool isActive = controller.selectedCategory.value == cat['name'];
              return GestureDetector(
                onTap: () => controller.selectedCategory.value = cat['name'],
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // Smooth transition ke liye
                  width: 100,
                  margin: const EdgeInsets.only(right: 12), // Har item ke beech gap
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.deepPurple : cardColor,
                    borderRadius: BorderRadius.circular(20),
                    // Active item par thoda shadow taaki scroll mein alag dikhay
                    boxShadow: isActive ? [
                      BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4)
                      )
                    ] : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          cat['icon'],
                          color: isActive ? Colors.white : textSecondary
                      ),
                      const SizedBox(height: 5),
                      Text(
                          cat['name'],
                          style: TextStyle(
                              color: isActive ? Colors.white : textPrimary,
                              fontSize: 12,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal
                          )
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}

class DateAndPaymentSection extends StatelessWidget {
  const DateAndPaymentSection({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExpenseController>();
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final textPrimary = isDark ? Colors.white : Colors.black;
      final cardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date & Time", style: TextStyle(color: textPrimary)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (picked != null) controller.selectedDateTime.value = picked;
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [const Icon(Iconsax.calendar, color: Colors.grey), const SizedBox(width: 10), Text(DateFormat('yyyy-MM-dd').format(controller.selectedDateTime.value), style: TextStyle(color: textPrimary))]),
            ),
          ),
          const SizedBox(height: 20),
          Text("Payment Method", style: TextStyle(color: textPrimary)),
          Row(children: [
            _payTile("Cash", Icons.money, controller, cardColor, textPrimary),
            const SizedBox(width: 10),
            _payTile("Card", Icons.credit_card, controller, cardColor, textPrimary),
          ])
        ],
      );
    });
  }

  Widget _payTile(String val, IconData icon, ExpenseController controller, Color cardColor, Color textPrimary) {
    return Expanded(
      child: Obx(() => GestureDetector(
        onTap: () => controller.paymentMethod.value = val,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: controller.paymentMethod.value == val ? Colors.deepPurple.withOpacity(0.2) : cardColor,
            border: Border.all(color: controller.paymentMethod.value == val ? Colors.deepPurple : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [Icon(icon, color: controller.paymentMethod.value == val ? Colors.deepPurple : Colors.grey), const SizedBox(width: 8), Text(val, style: TextStyle(color: textPrimary))]),
        ),
      )),
    );
  }
}