import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart';
import '../../view_models/controller/expense_controller/expense_controller.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final themeController = Get.find<ThemeController>();
  final expenseController = Get.find<ExpenseController>();
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _animationValue = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor = isDark ? const Color(0xFF09090B) : Colors.grey[50];
      final cardBg = isDark ? const Color(0xFF1C1C1E) : Colors.white;
      final textPrimary = isDark ? Colors.white : Colors.black87;
      final textSecondary = isDark ? Colors.grey[400] : Colors.grey[600];

      return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(children: [
            _buildHeader(textPrimary, cardBg, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(children: [
                  _spendingSummaryCard(cardBg, textPrimary, textSecondary!, isDark),
                  const SizedBox(height: 16),
                  _animatedBarChartCard(cardBg, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 16),
                  _animatedPieChartCard(cardBg, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 16),
                  _insightsCard(cardBg, textPrimary, textSecondary, isDark),
                ]),
              ),
            ),
          ]),
        ),
      );
    });
  }

  Widget _buildHeader(Color textPrimary, Color cardBg, bool isDark) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Analytics", style: TextStyle(fontSize: 24, color: textPrimary, fontWeight: FontWeight.bold)),
      GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(context: context, initialDate: expenseController.selectedMonth.value, firstDate: DateTime(2020), lastDate: DateTime(2100));
          if (picked != null) {
            setState(() => _animationValue = 0.0);
            await expenseController.fetchMonthlyTransactions(picked);
            setState(() => _animationValue = 1.0);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), boxShadow: [if(!isDark) BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Row(children: [Icon(Icons.calendar_month, size: 16, color: textPrimary), const SizedBox(width: 8), Text(DateFormat('MMMM yyyy').format(expenseController.selectedMonth.value), style: TextStyle(color: textPrimary))]),
        ),
      )
    ]),
  );

  Widget _spendingSummaryCard(Color cardBg, Color tp, Color ts, bool isDark) => Card(
    color: cardBg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
    child: Padding(padding: const EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Total Expenses", style: TextStyle(color: ts)), const SizedBox(height: 4), Text("\$${expenseController.totalExpense.value.toStringAsFixed(2)}", style: TextStyle(fontSize: 28, color: tp, fontWeight: FontWeight.bold))]),
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.auto_graph, color: Colors.deepPurple, size: 30)),
    ])),
  );

  Widget _animatedBarChartCard(Color cardBg, Color tp, Color ts, bool isDark) => Card(
    color: cardBg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Activity Overview", style: TextStyle(color: tp, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      SizedBox(height: 200, child: BarChart(BarChartData(
        gridData: FlGridData(show: false), borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text("\$${v.toInt()}", style: TextStyle(color: ts, fontSize: 10))))),
        barGroups: [BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: expenseController.totalIncome.value * _animationValue, color: Colors.greenAccent, width: 18, borderRadius: BorderRadius.circular(4)), BarChartRodData(toY: expenseController.totalExpense.value * _animationValue, color: Colors.redAccent, width: 18, borderRadius: BorderRadius.circular(4))])],
      ))),
    ])),
  );

  Widget _animatedPieChartCard(Color cardBg, Color tp, Color ts, bool isDark) {
    final sections = expenseController.getPieSections();
    return Card(
      color: cardBg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Spending by Category", style: TextStyle(color: tp, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(height: 200, child: PieChart(PieChartData(sectionsSpace: 4, centerSpaceRadius: 40, sections: sections))),
        const SizedBox(height: 16),
        ...expenseController.categoryTotals.entries.where((e) => e.value > 0).map((e) {
          final config = expenseController.categoryConfig.firstWhere((c) => c['name'] == e.key, orElse: () => {'color': Colors.grey});
          final Color catColor = config['color'];
          return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: catColor, shape: BoxShape.circle)), const SizedBox(width: 10), Text(e.key, style: TextStyle(color: tp, fontWeight: FontWeight.w500))]),
            Text("\$${e.value.toStringAsFixed(0)}", style: TextStyle(color: tp, fontWeight: FontWeight.bold)),
          ]));
        }),
      ])),
    );
  }

  Widget _insightsCard(Color cardBg, Color tp, Color ts, bool isDark) => Card(
    color: cardBg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("AI Insights", style: TextStyle(color: tp, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      _insightItem(Colors.green, "Budget Status", "You are spending within your limits."),
      const Divider(height: 24, thickness: 0.5),
      _insightItem(Colors.orange, "Top Category", "Most spending is in Food."),
    ])),
  );

  Widget _insightItem(Color color, String title, String sub) => Row(children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.lightbulb_outline, color: color, size: 18)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
  ]);
}