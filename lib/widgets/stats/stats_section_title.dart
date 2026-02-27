import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

class StatsSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const StatsSectionTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: ColorConstants.themeColor),
        SizedBox(width: UIConstants.gapSize.md),
        Text(
          title,
          style: TextStyle(
            fontSize: FontConstants.fontSize.md,
            fontWeight: FontWeight.w700,
            color: ColorConstants.defaultTextColor,
          ),
        ),
      ],
    );
  }
}
