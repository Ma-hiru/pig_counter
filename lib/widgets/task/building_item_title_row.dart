import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../constants/ui.dart';
import '../../models/api/task.dart';

class BuildingItemTitleRow extends StatelessWidget {
  final Building building;
  final bool expanded;
  final VoidCallback? onTap;

  const BuildingItemTitleRow({
    super.key,
    required this.building,
    required this.expanded,
    this.onTap,
  });

  Widget buildTitleRowIndicator() {
    return Stack(
      alignment: .center,
      children: [
        CircularProgressIndicator(
          value: building.progress,
          strokeWidth: UIConstants.uiSize.xs - 2,
          backgroundColor: Colors.grey.shade200,
          color: building.completed
              ? ColorConstants.successColor
              : ColorConstants.themeColor,
        ),
        Text(
          "${(building.progress * 100).round()}%",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: FontConstants.fontSize.xs - 2,
            fontFamily: FontConstants.fontFamily,
            color: building.completed
                ? ColorConstants.successColor
                : ColorConstants.themeColor,
          ),
        ),
      ],
    );
  }

  Widget buildTitleRowArrow() {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 300),
      child: Icon(
        LucideIcons.chevron_down,
        size: UIConstants.uiSize.md,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget buildTitleRowText() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          building.name,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.sm,
            fontWeight: FontWeight.w600,
            color: ColorConstants.defaultTextColor,
          ),
        ),
        SizedBox(height: UIConstants.gapSize.xs),
        Text(
          "${building.completedPenCount} / ${building.totalPens} 栏已完成",
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontSize: FontConstants.fontSize.xs,
            color: ColorConstants.defaultTextColor.withAlpha(100),
          ),
        ),
      ],
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
            // 圆形进度指示器
            SizedBox(
              width: UIConstants.uiSize.xxl,
              height: UIConstants.uiSize.xxl,
              child: buildTitleRowIndicator(),
            ),
            SizedBox(width: UIConstants.gapSize.lg),
            // 名称 + 副标题
            Expanded(child: buildTitleRowText()),
            // 展开箭头
            buildTitleRowArrow(),
          ],
        ),
      ),
    );
  }
}
