import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseController extends GetxController {
  final supabase = Supabase.instance.client;

  // UI State
  var isLoading = false.obs;
  var transactionType = 'expense'.obs;
  var selectedCategory = 'Food'.obs;
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  var selectedDateTime = DateTime.now().obs;
  var paymentMethod = 'Cash'.obs;

  // Home Stats & Data
  var totalBalance = 0.0.obs;
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var recentTransactions = <dynamic>[].obs;
  var categoryTotals = <String, double>{}.obs;

  var selectedMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  // Sabse important function
  Future<void> fetchTransactions() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('expenses')
          .select()
          .eq('user_id', user.id)
          .order('date_time', ascending: false);

      recentTransactions.assignAll(response as List);

      // Calculations yahi se trigger hogi
      _calculateStats();
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  void _calculateStats() {
    double income = 0;
    double expense = 0;
    Map<String, double> tempCats = {
      'Food': 0.0, 'Shopping': 0.0, 'Transport': 0.0, 'Home': 0.0,
      'Entertainment': 0.0, 'Travel': 0.0, 'Gifts': 0.0, 'Other': 0.0,
    };

    for (var item in recentTransactions) {
      double amt = double.parse(item['amount'].toString());
      if (item['type'] == 'income') {
        income += amt;
      } else {
        expense += amt;
        String cat = item['category'];
        if (tempCats.containsKey(cat)) {
          tempCats[cat] = (tempCats[cat] ?? 0.0) + amt;
        }
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
    categoryTotals.assignAll(tempCats);
  }

  Future<void> addExpense() async {
    if (amountController.text.isEmpty) {
      Get.snackbar("Error", "Amount is required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      isLoading.value = true;
      await supabase.from('expenses').insert({
        'user_id': supabase.auth.currentUser!.id,
        'amount': double.parse(amountController.text),
        'type': transactionType.value,
        'category': selectedCategory.value,
        'description': noteController.text.trim(),
        'date_time': selectedDateTime.value.toIso8601String(),
        'payment_method': paymentMethod.value,
      });

      amountController.clear();
      noteController.clear();
      await fetchTransactions(); // Refresh data
      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Bar Chart Data ke liye logic
  List<BarChartGroupData> getBarGroups(Color incomeColor, Color expenseColor) {
    // Hum last 6 months ka data calculate kar sakte hain
    // Filhal hum current transactions se dynamic bars bana rahe hain
    return [
        BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: totalIncome.value, color: incomeColor, width: 12, borderRadius: BorderRadius.circular(4)),
        BarChartRodData(toY: totalExpense.value, color: expenseColor, width: 12, borderRadius: BorderRadius.circular(4)),
      ]),
    ];
  }

// Pie Chart Data ke liye logic
  List<PieChartSectionData> getPieSections() {
    final List<Color> colors = [Colors.orange, Colors.blue, Colors.purple, Colors.red, Colors.green, Colors.indigo, Colors.pink, Colors.grey];
    int i = 0;

    return categoryTotals.entries.map((entry) {
      if (entry.value == 0) return PieChartSectionData(value: 0, showTitle: false);
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '\$${entry.value.toInt()}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).where((section) => section.value > 0).toList();
  }

  // Filtered Fetch Function
  Future<void> fetchMonthlyTransactions(DateTime date) async {
    try {
      isLoading.value = true;
      selectedMonth.value = date;

      // Month ki range calculation
      DateTime firstDay = DateTime(date.year, date.month, 1);
      DateTime lastDay = DateTime(date.year, date.month + 1, 0, 23, 59, 59);

      final response = await supabase
          .from('expenses')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .gte('date_time', firstDay.toIso8601String())
          .lte('date_time', lastDay.toIso8601String())
          .order('date_time', ascending: false);

      // Pehle zero set karein taaki animation trigger ho (Optional trick)
      totalIncome.value = 0;
      totalExpense.value = 0;

      recentTransactions.assignAll(response as List);
      _calculateStats();

    } catch (e) {
      debugPrint("Filter Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.amber},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.blue},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.cyan},
    {'name': 'Home', 'icon': Icons.home, 'color': Colors.orange},
    {'name': 'Entertainment', 'icon': Icons.music_note, 'color': Colors.purple},
    {'name': 'Travel', 'icon': Icons.airplanemode_active, 'color': Colors.green},
    {'name': 'Gifts', 'icon': Icons.card_giftcard, 'color': Colors.pink},
    {'name': 'Other', 'icon': Icons.category, 'color': Colors.grey},
  ];

  final List<Map<String, dynamic>> categoryConfig = [
    {'name': 'Food', 'icon': Icons.fastfood, 'color': Colors.amber},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': Colors.blue},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': Colors.cyan},
    {'name': 'Home', 'icon': Icons.home, 'color': Colors.orange},
    {'name': 'Entertainment', 'icon': Icons.music_note, 'color': Colors.purple},
    {'name': 'Travel', 'icon': Icons.airplanemode_active, 'color': Colors.green},
    {'name': 'Gifts', 'icon': Icons.card_giftcard, 'color': Colors.pink},
    {'name': 'Other', 'icon': Icons.category, 'color': Colors.grey},
  ];

  // Income categories
  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Salary', 'icon': Icons.account_balance_wallet, 'color': Colors.green},
    {'name': 'Freelance', 'icon': Icons.laptop_mac, 'color': Colors.indigo},
    {'name': 'Business', 'icon': Icons.storefront, 'color': Colors.teal},
    {'name': 'Investment', 'icon': Icons.show_chart, 'color': Colors.orange},
    {'name': 'Gift', 'icon': Icons.redeem, 'color': Colors.pink},
    {'name': 'Other', 'icon': Icons.add_circle_outline, 'color': Colors.grey},
  ];

// Helper method jo screen par sahi categories dikhayega
  List<Map<String, dynamic>> get currentCategories =>
      transactionType.value == 'income' ? incomeCategories : expenseCategories;
}