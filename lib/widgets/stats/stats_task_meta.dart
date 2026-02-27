import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class StatsTaskMeta extends StatelessWidget {
  final Task taskData;

  const StatsTaskMeta({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat("yyyy-MM-dd HH:mm");
    final bool expired = taskData.outdate && !taskData.completed;

    return Container(
      padding: EdgeInsets.all(UIConstants.gapSize.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            expired ? LucideIcons.circle_alert : LucideIcons.info,
            size: 15,
            color: expired
                ? ColorConstants.errorColor
                : ColorConstants.themeColor,
          ),
          SizedBox(width: UIConstants.gapSize.lg),
          Expanded(
            child: Wrap(
              spacing: UIConstants.gapSize.xl,
              runSpacing: UIConstants.gapSize.sm,
              children: [
                _MetaItem(
                  label: "开始",
                  value: fmt.format(taskData.startTimeObject),
                ),
                _MetaItem(
                  label: "截止",
                  value: fmt.format(taskData.endTimeObject),
                ),
                _MetaItem(
                  label: "状态",
                  value: expired
                      ? "已超期"
                      : taskData.completed
                      ? "已完成"
                      : "进行中",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label：",
            style: const TextStyle(
              fontSize: 12,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorConstants.defaultTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
