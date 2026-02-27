import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class DashboardSummaryCards extends StatelessWidget {
  final List<Task> taskList;

  const DashboardSummaryCards({super.key, required this.taskList});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayTasks = taskList.where((t) {
      final start = t.startTimeObject;
      return start.year == today.year &&
          start.month == today.month &&
          start.day == today.day;
    }).toList();
    final dueTodayTasks = taskList.where((t) {
      final end = t.endTimeObject;
      return end.year == today.year &&
          end.month == today.month &&
          end.day == today.day;
    }).toList();

    final int totalPigs = taskList.fold(
      0,
      (s, t) =>
          s +
          t.buildings.fold(
            0,
            (bs, b) => bs + b.pens.fold(0, (ps, p) => ps + p.aiCount),
          ),
    );
    final int inProgress = taskList
        .where((t) => !t.completed && !t.outdate)
        .length;
    final int overdueCount = taskList
        .where((t) => t.outdate && !t.completed)
        .length;
    final int completedCount = taskList.where((t) => t.completed).length;

    final items = [
      _CardData(
        icon: LucideIcons.list_check,
        label: "今日任务",
        value: todayTasks.length,
        unit: "个",
        color: ColorConstants.themeColor,
      ),
      _CardData(
        icon: LucideIcons.calendar_clock,
        label: "今日截止",
        value: dueTodayTasks.length,
        unit: "个",
        color: const Color(0xFFFF7043),
      ),
      _CardData(
        icon: LucideIcons.circle_check_big,
        label: "已完成",
        value: completedCount,
        unit: "个",
        color: ColorConstants.successColor,
      ),
      _CardData(
        icon: LucideIcons.timer,
        label: "进行中",
        value: inProgress,
        unit: "个",
        color: const Color(0xFF7B5EA7),
      ),
      _CardData(
        icon: LucideIcons.circle_alert,
        label: "已超期",
        value: overdueCount,
        unit: "个",
        color: ColorConstants.errorColor,
      ),
      _CardData(
        icon: LucideIcons.cpu,
        label: "AI 识别",
        value: totalPigs,
        unit: "头",
        color: const Color(0xFF2196F3),
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: UIConstants.gapSize.lg,
      mainAxisSpacing: UIConstants.gapSize.lg,
      childAspectRatio: 0.85,
      children: items.map((d) => _SummaryCard(data: d)).toList(),
    );
  }
}

class _CardData {
  final IconData icon;
  final String label;
  final int value;
  final String unit;
  final Color color;

  const _CardData({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });
}

class _SummaryCard extends StatelessWidget {
  final _CardData data;

  const _SummaryCard({required this.data});

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
              color: data.color.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(data.icon, size: 12, color: data.color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${data.value} ${data.unit}",
                style: TextStyle(
                  fontSize: FontConstants.fontSize.sm,
                  fontWeight: FontWeight.w700,
                  color: data.color,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
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
