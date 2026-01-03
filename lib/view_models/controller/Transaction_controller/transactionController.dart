import 'package:get/get.dart';
import '../expense_controller/expense_controller.dart';

class TransactionsController extends GetxController {
  final expenseController = Get.find<ExpenseController>();

  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;

  // Fix: Nullable error se bachne ke liye List<dynamic> specify kiya hai
  List<dynamic> get filteredTransactions {
    // Agar recentTransactions null ho ya empty, toh empty list return karein
    List<dynamic> list = List.from(expenseController.recentTransactions);

    if (list.isEmpty) return [];

    // 1. Search filter
    if (searchQuery.value.isNotEmpty) {
      list = list.where((tx) {
        final description = tx['description']?.toString().toLowerCase() ?? "";
        final category = tx['category']?.toString().toLowerCase() ?? "";
        final query = searchQuery.value.toLowerCase();
        return description.contains(query) || category.contains(query);
      }).toList();
    }

    // 2. Chip filter
    if (selectedFilter.value == 'Income') {
      list = list.where((tx) => tx['type'] == 'income').toList();
    } else if (selectedFilter.value == 'Expense') {
      list = list.where((tx) => tx['type'] == 'expense').toList();
    } else if (selectedFilter.value != 'All') {
      list = list.where((tx) => tx['category'] == selectedFilter.value).toList();
    }

    return list;
  }

  void changeFilter(String title) {
    selectedFilter.value = title;
  }
}