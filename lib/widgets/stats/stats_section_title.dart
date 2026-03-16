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
      spacing: UIConstants.gapSize.sm,
      children: [
        Icon(icon, size: 15, color: ColorConstants.themeColor),
        Text(
          title,
          style: TextStyle(
            fontWeight: .w700,
            fontSize: FontConstants.fontSize.sm,
            fontFamily: FontConstants.fontFamily,
            color: ColorConstants.defaultTextColor,
          ),
        ),
      ],
    );
  }
}
