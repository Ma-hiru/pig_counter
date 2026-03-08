import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/widgets/settings/settings_menu_section_item.dart';

class SettingsMenuSection extends StatelessWidget {
  final String title;
  final List<SettingsMenuSectionItem> items;

  const SettingsMenuSection({
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
          fontFamily: FontConstants.fontFamily,
          fontSize: FontConstants.fontSize.xs,
          fontWeight: FontWeight.w600,
          color: ColorConstants.secondaryTextColor,
          letterSpacing: 0.5,
        ),
      ),
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
        children: items.indexed.map((entry) {
          final index = entry.$1;
          final item = entry.$2;
          return Column(
            mainAxisSize: .min,
            children: [
              item,
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: UIConstants.gapSize.xl,
                  color: Colors.grey.shade100,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [buildSectionTitle(), buildSectionContent()],
    );
  }
}
