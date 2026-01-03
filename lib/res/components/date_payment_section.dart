import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Logic ke liye GetX add kiya
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../view_models/controller/theme_controller/theme_controller.dart'; // Apna path check kar lein

class DateAndPaymentSection extends StatefulWidget {
  const DateAndPaymentSection({super.key});

  @override
  _DateAndPaymentSectionState createState() => _DateAndPaymentSectionState();
}

class _DateAndPaymentSectionState extends State<DateAndPaymentSection> {
  DateTime _selectedDateTime = DateTime(2024, 6, 12, 9, 30);
  String _selectedPayment = 'Cash';

  // Controller find karein
  final themeController = Get.find<ThemeController>();

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = DateFormat('MMMM d, yyyy - hh:mm a').format(_selectedDateTime);

    // Obx add kiya taaki switch hote hi ye screen update ho jaye
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      // Dynamic Colors Logic (No design change)
      final cardColor = isDark ? const Color(0xFF27272A) : Colors.white;
      final textPrimary = isDark ? Colors.white : const Color(0xFF18181B);
      final textSecondary = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
      final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary, // Dynamic color
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor, // Dynamic card color
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.calendar,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formattedDateTime,
                    style: TextStyle(fontSize: 16, color: textPrimary), // Dynamic color
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary, // Dynamic color
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPayment = 'Cash';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardColor, // Dynamic card color
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.attach_money,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cash', style: TextStyle(color: textPrimary)), // Dynamic color
                            Text(
                              'Default',
                              style: TextStyle(fontSize: 12, color: textSecondary), // Dynamic color
                            ),
                          ],
                        ),
                        const Spacer(),
                        Radio<String>(
                          value: 'Cash',
                          groupValue: _selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              _selectedPayment = value!;
                            });
                          },
                          activeColor: Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPayment = 'Card';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardColor, // Dynamic card color
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Card', style: TextStyle(color: textPrimary)), // Dynamic color
                            Text(
                              '****48',
                              style: TextStyle(fontSize: 12, color: textSecondary), // Dynamic color
                            ),
                          ],
                        ),
                        const Spacer(),
                        Radio<String>(
                          value: 'Card',
                          groupValue: _selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              _selectedPayment = value!;
                            });
                          },
                          activeColor: Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}