import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../expense_controller/expense_controller.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  // Expense controller se data lene ke liye
  final expenseController = Get.find<ExpenseController>();

  var firstName = "User".obs;
  var lastName = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Database se user ka naam lana
  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Note: Make sure aapki 'profiles' table mein ye columns hain
        final data = await supabase
            .from('profiles')
            .select('first_name, last_name')
            .eq('id', user.id)
            .single();

        firstName.value = data['first_name'] ?? "User";
        lastName.value = data['last_name'] ?? "";
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading(false);
    }
  }

  // --- Dynamic Stats Getters ---

  // Full Name logic
  String get fullName => "${firstName.value} ${lastName.value}".trim();

  // Avatar ke liye first character
  String get firstChar => firstName.value.isNotEmpty
      ? firstName.value[0].toUpperCase()
      : "U";

  // Total Transactions count from ExpenseController
  String get totalTransactions => expenseController.recentTransactions.length.toString();

  // Unique Categories count
  String get totalCategories {
    final categories = expenseController.recentTransactions
        .map((tx) => tx['category'])
        .toSet(); // toSet() duplicate values remove kar deta hai
    return categories.length.toString();
  }
}