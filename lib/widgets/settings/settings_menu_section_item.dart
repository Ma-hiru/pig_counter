import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';

class SettingsMenuSectionItem extends StatelessWidget {
  final String label;
  final bool flat;
  final Color? flatColor;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;

  const SettingsMenuSectionItem({
    super.key,
    required this.label,
    this.flat = false,
    this.flatColor,
    this.subtitle,
    this.value,
    this.onTap,
  });

  Widget buildLabel() {
    final labelColor = flat
        ? flatColor ?? ColorConstants.errorColor
        : ColorConstants.defaultTextColor;
    return Column(
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

  List<Widget> buildValue() {
    if (value == null) return [];
    return [
      SizedBox(width: UIConstants.gapSize.sm),
      Text(
        value!,
        style: TextStyle(
          fontSize: FontConstants.fontSize.xs + 2,
          fontFamily: FontConstants.fontFamily,
          color: ColorConstants.secondaryTextColor,
        ),
      ),
    ];
  }

  List<Widget> buildArrow() {
    if (flat) return [];
    return [
      SizedBox(width: UIConstants.gapSize.sm),
      Icon(
        Icons.chevron_right,
        size: UIConstants.uiSize.md + 2,
        color: Colors.grey.shade400,
      ),
    ];
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
            Expanded(child: buildLabel()),
            ...buildValue(),
            ...buildArrow(),
          ],
        ),
      ),
    );
  }
}
