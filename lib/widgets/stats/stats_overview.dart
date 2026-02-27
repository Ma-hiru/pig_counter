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
    final int aiTotal = taskData.buildings.fold(
      0,
      (s, b) => s + b.pens.fold(0, (ps, p) => ps + p.aiCount),
    );
    final int manualTotal = taskData.buildings.fold(
      0,
      (s, b) => s + b.pens.fold(0, (ps, p) => ps + p.manualCount),
    );
    final int completedPens = taskData.buildings.fold(
      0,
      (s, b) => s + b.pens.where((p) => p.status).length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          crossAxisSpacing: UIConstants.gapSize.lg,
          mainAxisSpacing: UIConstants.gapSize.lg,
          childAspectRatio: 0.85,
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
              value: completedPens.toString(),
              unit: "栏",
              color: ColorConstants.successColor,
            ),
            _StatCard(
              icon: LucideIcons.gauge,
              label: "任务进度",
              value: taskData.progress.toString(),
              unit: "%",
              color: taskData.progress >= 100
                  ? ColorConstants.successColor
                  : ColorConstants.themeColor,
            ),
            _StatCard(
              icon: LucideIcons.cpu,
              label: "AI 识别",
              value: aiTotal.toString(),
              unit: "头",
              color: const Color(0xFF2196F3),
            ),
            _StatCard(
              icon: LucideIcons.user_round_check,
              label: "人工确认",
              value: manualTotal.toString(),
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
      padding: EdgeInsets.all(UIConstants.gapSize.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$value $unit",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: color,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: ColorConstants.secondaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
