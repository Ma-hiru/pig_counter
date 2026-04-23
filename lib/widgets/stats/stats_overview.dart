import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/stats/stats_section_title.dart';

class StatsOverview extends StatelessWidget {
  final Task taskData;

  const StatsOverview({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const StatsSectionTitle(
          title: "概览",
          icon: LucideIcons.layout_dashboard,
        ),
        SizedBox(height: UIConstants.gapSize.lg),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: UIConstants.gapSize.md,
          mainAxisSpacing: UIConstants.gapSize.md,
          childAspectRatio: 1,
          children: [
            _StatCard(
              icon: LucideIcons.layout_grid,
              label: "总栋数",
              value: taskData.totalBuildings.toString(),
              unit: "栋",
              color: ColorConstants.themeColor,
            ),
            _StatCard(
              icon: LucideIcons.fence,
              label: "总栏位",
              value: taskData.totalPens.toString(),
              unit: "栏",
              color: const Color(0xFF7B5EA7),
            ),
            _StatCard(
              icon: LucideIcons.circle_check_big,
              label: "已完成",
              value: taskData.completedPens.toString(),
              unit: "栏",
              color: ColorConstants.successColor,
            ),
            _StatCard(
              icon: LucideIcons.gauge,
              label: "任务进度",
              value: (taskData.progress * 100).toStringAsFixed(0),
              unit: "%",
              color: taskData.progress >= 1
                  ? ColorConstants.successColor
                  : ColorConstants.themeColor,
            ),
            _StatCard(
              icon: LucideIcons.cpu,
              label: "AI 识别",
              value: taskData.aiCount.toString(),
              unit: "头",
              color: const Color(0xFF2196F3),
            ),
            _StatCard(
              icon: LucideIcons.user_round_check,
              label: "人工确认",
              value: taskData.manualCount.toString(),
              unit: "头",
              color: const Color(0xFFFF7043),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(UIConstants.gapSize.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(UIConstants.borderRadius),
        border: .all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: .all(UIConstants.gapSize.md),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: .circular(UIConstants.borderRadius),
            ),
            child: Icon(icon, size: UIConstants.uiSize.md, color: color),
          ),
          Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: UIConstants.gapSize.xs,
            children: [
              Text(
                "$value $unit",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontConstants.fontFamily,
                  color: color,
                ),
                maxLines: 1,
                overflow: .ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.xs,
                  fontFamily: FontConstants.fontFamily,
                  color: ColorConstants.secondaryTextColor,
                ),
                maxLines: 1,
                overflow: .ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
