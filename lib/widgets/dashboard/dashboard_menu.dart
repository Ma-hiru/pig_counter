import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

class DashboardMenuSection extends StatelessWidget {
  final String title;
  final List<DashboardMenuItem> items;

  const DashboardMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: UIConstants.gapSize.sm,
            bottom: UIConstants.gapSize.md,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ColorConstants.secondaryTextColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.indexed.map((entry) {
              final i = entry.$1;
              final item = entry.$2;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuTile(item: item),
                  if (i < items.length - 1)
                    Divider(height: 1, indent: 44, color: Colors.grey.shade100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DashboardMenuItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool destructive;

  const DashboardMenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.onTap,
    this.destructive = false,
  });
}

class _MenuTile extends StatelessWidget {
  final DashboardMenuItem item;

  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final labelColor = item.destructive
        ? ColorConstants.errorColor
        : ColorConstants.defaultTextColor;

    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: UIConstants.gapSize.xl,
          vertical: UIConstants.gapSize.lg,
        ),
        child: Row(
          children: [
            // 图标背景
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, size: 14, color: item.iconColor),
            ),
            SizedBox(width: UIConstants.gapSize.lg),
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: FontConstants.fontSize.sm,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: ColorConstants.secondaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // 箭头
            if (!item.destructive)
              Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
