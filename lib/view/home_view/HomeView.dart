import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../view_models/controller/profile_controller/profileController.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';
import '../../view_models/controller/expense_controller/expense_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final profileController = Get.put(ProfileController());
  final themeController = Get.find<ThemeController>();
  final expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : const Color(0xFFFAFAFA);
      final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => expenseController.fetchTransactions(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(textPrimary, textSecondary),
                  const SizedBox(height: 24),
                  _balanceCard(expenseController.totalBalance.value, cardColor, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 24),
                  _statsRow(cardColor, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 28),
                  _sectionHeader("Spending Categories", textPrimary),
                  const SizedBox(height: 16),
                  _horizontalCategories(cardColor, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 28),
                  _sectionHeader("Recent Transactions", textPrimary),
                  const SizedBox(height: 12),
                  _transactionList(cardColor, textPrimary, textSecondary, isDark),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _statsRow(Color cc, Color tp, Color ts, bool id) => Row(
    children: [
      _box("Income", "+\$${expenseController.totalIncome.value.toStringAsFixed(0)}", Icons.trending_up, Colors.green, cc, tp, ts, id),
      const SizedBox(width: 16),
      _box("Expenses", "-\$${expenseController.totalExpense.value.toStringAsFixed(0)}", Icons.trending_down, Colors.red, cc, tp, ts, id),
    ],
  );

  Widget _box(String t, String a, IconData i, Color c, Color cc, Color tp, Color ts, bool id) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cc, borderRadius: BorderRadius.circular(24), boxShadow: _shadow(id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(i, color: c, size: 20),
          ),
          const SizedBox(height: 16),
          Text(t, style: TextStyle(color: ts, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(a, style: TextStyle(color: tp, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );

  Widget _header(Color tp, Color ts) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Welcome back,", style: TextStyle(color: ts)),
        Text(profileController.firstName.value, style: TextStyle(color: tp, fontSize: 24, fontWeight: FontWeight.bold)),
      ]),
      CircleAvatar(radius: 22, backgroundColor: Colors.deepPurple, child: Text(profileController.firstChar, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    ],
  );

  Widget _balanceCard(double b, Color cc, Color tp, Color ts, bool id) => Container(
    width: double.infinity, padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: id ? null : const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
      color: id ? cc : null, borderRadius: BorderRadius.circular(32), boxShadow: _shadow(id),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Total Balance", style: TextStyle(color: id ? ts : Colors.white70)),
      const SizedBox(height: 4),
      Text("\$${NumberFormat('#,##0.00').format(b)}", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: id ? tp : Colors.white)),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.auto_graph, color: Colors.white, size: 14), Text(" Live Tracking", style: TextStyle(color: Colors.white, fontSize: 12))]),
      ),
    ]),
  );

  Widget _horizontalCategories(Color cc, Color tp, Color ts, bool id) {
    double totalExp = expenseController.totalExpense.value;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, clipBehavior: Clip.none,
        itemCount: expenseController.categoryConfig.length,
        itemBuilder: (context, index) {
          final cat = expenseController.categoryConfig[index];
          double catAmount = expenseController.categoryTotals[cat['name']] ?? 0.0;
          double progress = totalExp > 0 ? (catAmount / totalExp) : 0.0;
          return Container(
            width: 140, margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cc, borderRadius: BorderRadius.circular(24), boxShadow: _shadow(id)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(cat['icon'], color: cat['color'], size: 24),
              const SizedBox(height: 12),
              Text(cat['name'], style: TextStyle(color: ts, fontSize: 12)),
              Text("\$${catAmount.toStringAsFixed(0)}", style: TextStyle(color: tp, fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              LinearProgressIndicator(value: progress, color: cat['color'], backgroundColor: id ? Colors.grey[800] : Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            ]),
          );
        },
      ),
    );
  }

  Widget _transactionList(Color cc, Color tp, Color ts, bool id) {
    final transactions = expenseController.recentTransactions;
    if (transactions.isEmpty) return const Center(child: Text("No transactions yet"));
    return ListView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 5 ? 5 : transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final config = expenseController.categoryConfig.firstWhere((c) => c['name'] == tx['category'], orElse: () => expenseController.categoryConfig.last);
        return _tile(tx['description'] == "" ? tx['category'] : tx['description'], tx['category'], "${tx['type'] == 'income' ? '+' : '-'}\$${tx['amount']}", config['icon'], tx['type'] == 'income' ? Colors.green : Colors.red, cc, tp, ts, id);
      },
    );
  }

  Widget _tile(String t, String c, String a, IconData i, Color cl, Color cc, Color tp, Color ts, bool id) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: cc, borderRadius: BorderRadius.circular(20), boxShadow: _shadow(id)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: cl.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(i, color: cl, size: 20)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(color: tp, fontWeight: FontWeight.w600)), Text(c, style: TextStyle(color: ts, fontSize: 12))]),
      ]),
      Text(a, style: TextStyle(color: cl, fontWeight: FontWeight.bold)),
    ]),
  );

  List<BoxShadow> _shadow(bool id) => [BoxShadow(color: id ? Colors.black45 : Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))];
  Widget _sectionHeader(String t, Color tp) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: tp)), const Text("See All", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500))]);
}