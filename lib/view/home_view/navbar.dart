import 'package:expense_tracker/view/Transaction_view/transaction_view.dart';
import 'package:expense_tracker/view/add_expense_view/addExpenseView.dart';
import 'package:expense_tracker/view/analytics_screen/AnalyticsView.dart';
import 'package:expense_tracker/view/profile_view/profileView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../res/components/bottom_nav_bar.dart';
import '../../view_models/controller/nav_bar_controller/NavBarController.dart';
import 'HomeView.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final BottomNavController controller =
  Get.put(BottomNavController()); // ✅ ONLY HERE

  final List<Widget> pages = [
     HomeView(),
    AnalyticsScreen(),
    AddExpenseView(),
    TransactionsView(),
    ProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: BottomNavBar(isDark: false, activeIndex: 0,),
    );
  }
}
// padding: const EdgeInsets.only(top: 10, left: 12,),