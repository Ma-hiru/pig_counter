import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

class DashboardMenuSectionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool flat;
  final String? subtitle;
  final VoidCallback? onTap;

  Color get labelColor => flat ? iconColor : ColorConstants.defaultTextColor;

  const DashboardMenuSectionItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.flat = false,
    this.subtitle,
    this.onTap,
  });

  Widget buildIcon() {
    return Icon(icon, size: UIConstants.uiSize.md + 2, color: iconColor);
  }

  Widget buildText() {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.sm,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: UIConstants.gapSize.xs),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: FontConstants.fontSize.xs,
              fontFamily: FontConstants.fontFamily,
              color: ColorConstants.defaultTextColor.withAlpha(
                (255 * 0.7).toInt(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildArrow() {
    if (flat) return SizedBox.shrink();
    return Icon(
      Icons.chevron_right,
      size: UIConstants.uiSize.md + 2,
      color: Colors.grey.shade400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .symmetric(
          horizontal: UIConstants.gapSize.xl,
          vertical: UIConstants.gapSize.lg,
        ),
        child: Row(
          children: [
            buildIcon(),
            SizedBox(width: UIConstants.gapSize.xl),
            Expanded(child: buildText()),
            buildArrow(),
          ],
        ),
      ),
    );
  }
}
