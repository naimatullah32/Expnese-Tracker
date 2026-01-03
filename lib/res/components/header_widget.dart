import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String name;
  final bool isDark;

  const HeaderWidget({super.key, required this.name, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good morning,",
                style: TextStyle(color: textSecondary)),
            Text(name,
                style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary)),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    );
  }
}
