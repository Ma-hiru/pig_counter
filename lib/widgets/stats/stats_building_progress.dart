import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/widgets/stats/stats_section_title.dart';

class StatsBuildingProgress extends StatelessWidget {
  final Task taskData;

  const StatsBuildingProgress({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionTitle(title: "各栋进度", icon: LucideIcons.chart_bar),
        SizedBox(height: UIConstants.gapSize.lg),
        ...taskData.buildings.map((b) => _BuildingProgressCard(building: b)),
      ],
    );
  }
}

class _BuildingProgressCard extends StatelessWidget {
  final Building building;

  const _BuildingProgressCard({required this.building});

  @override
  Widget build(BuildContext context) {
    final done = building.pens.where((p) => p.status).length;
    final total = building.pens.length;
    final ratio = total == 0 ? 0.0 : done / total;
    final Color barColor = ratio >= 1.0
        ? ColorConstants.successColor
        : ColorConstants.themeColor;

    return Container(
      margin: EdgeInsets.only(bottom: UIConstants.gapSize.lg),
      padding: EdgeInsets.all(UIConstants.gapSize.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                building.name,
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.defaultTextColor,
                ),
              ),
              Text(
                "$done / $total 栏",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.xs + 2,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: UIConstants.gapSize.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: barColor,
            ),
          ),
          SizedBox(height: UIConstants.gapSize.md),
          Row(
            children: [
              _MiniTag(
                label:
                    "AI: ${building.pens.fold(0, (s, p) => s + p.aiCount)} 头",
                color: const Color(0xFF2196F3),
              ),
              SizedBox(width: UIConstants.gapSize.md),
              _MiniTag(
                label:
                    "人工: ${building.pens.fold(0, (s, p) => s + p.manualCount)} 头",
                color: const Color(0xFFFF7043),
              ),
              const Spacer(),
              Text(
                "${(ratio * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
