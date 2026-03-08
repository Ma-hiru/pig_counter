import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

import 'dashboard_menu_section_item.dart';

class DashboardMenuSection extends StatelessWidget {
  final String title;
  final List<DashboardMenuSectionItem> items;

  const DashboardMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  Widget buildSectionTitle() {
    return Padding(
      padding: .only(
        left: UIConstants.gapSize.sm,
        bottom: UIConstants.gapSize.md,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontConstants.fontSize.xs,
          fontWeight: FontWeight.w600,
          color: ColorConstants.secondaryTextColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildMenuItems(int index, DashboardMenuSectionItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        item,
        if (index < items.length - 1)
          Divider(
            height: 1,
            indent:
                UIConstants.gapSize.xl + // _MenuTile left padding
                UIConstants
                    .gapSize
                    .xl + // _MenuTile icon right padding(SizedBox)
                (UIConstants.uiSize.md + 2), // _MenuTile icon size
            color: Colors.grey.shade100,
          ),
      ],
    );
  }

  Widget buildSectionContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: Colors.grey.shade200),
      ),
      clipBehavior: .antiAlias,
      child: Column(
        children: items.indexed
            .map((entry) => buildMenuItems(entry.$1, entry.$2))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [buildSectionTitle(), buildSectionContent()],
    );
  }
}
