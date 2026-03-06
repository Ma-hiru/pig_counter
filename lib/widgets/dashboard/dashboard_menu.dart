import 'dart:math';

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
      crossAxisAlignment: .start,
      children: [
        Padding(
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
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(UIConstants.borderRadius),
            border: .all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.indexed.map((entry) {
              final index = entry.$1;
              final item = entry.$2;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuTile(item: item),
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
        ? item.iconColor
        : ColorConstants.defaultTextColor;

    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: .symmetric(
          horizontal: UIConstants.gapSize.xl,
          vertical: UIConstants.gapSize.lg,
        ),
        child: Row(
          children: [
            // 图标背景
            Icon(
              item.icon,
              size: UIConstants.uiSize.md + 2,
              color: item.iconColor,
            ),
            SizedBox(width: UIConstants.gapSize.xl),
            // 文字
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontSize: FontConstants.fontSize.sm,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    SizedBox(height: UIConstants.gapSize.xs),
                    Text(
                      item.subtitle!,
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
              ),
            ),
            // 箭头
            if (!item.destructive)
              Icon(
                Icons.chevron_right,
                size: UIConstants.uiSize.md + 2,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }
}
