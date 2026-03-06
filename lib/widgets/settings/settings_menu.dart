import 'package:flutter/material.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';

class SettingsMenuSection extends StatelessWidget {
  final String title;
  final List<SettingsMenuItem> items;

  const SettingsMenuSection({
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
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.indexed.map((entry) {
              final index = entry.$1;
              final item = entry.$2;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SettingsTile(item: item),
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
        ),
      ],
    );
  }
}

class SettingsMenuItem {
  final String label;
  final String? subtitle;
  final String? value;
  final bool destructive;
  final VoidCallback? onTap;

  const SettingsMenuItem({
    required this.label,
    this.subtitle,
    this.value,
    this.destructive = false,
    this.onTap,
  });
}

class _SettingsTile extends StatelessWidget {
  final SettingsMenuItem item;

  const _SettingsTile({required this.item});

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
            if (item.value != null) ...[
              SizedBox(width: UIConstants.gapSize.md),
              Text(
                item.value!,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
            ],
            if (!item.destructive) ...[
              SizedBox(width: UIConstants.gapSize.sm),
              Icon(
                Icons.chevron_right,
                size: UIConstants.uiSize.md + 2,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
