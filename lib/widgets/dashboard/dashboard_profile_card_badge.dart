import 'package:flutter/material.dart';

import '../../constants/font.dart';
import '../../constants/ui.dart';

class DashboardProfileCardBadge extends StatelessWidget {
  final String label;

  const DashboardProfileCardBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(
        horizontal: UIConstants.gapSize.md,
        vertical: UIConstants.gapSize.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: .circular(FontConstants.fontSize.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: FontConstants.fontSize.xs,
          fontWeight: FontWeight.w500,
          fontFamily: FontConstants.fontFamily,
        ),
      ),
    );
  }
}
