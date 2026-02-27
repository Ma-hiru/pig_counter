import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class DashboardTaskList extends StatelessWidget {
  final List<Task> taskList;

  const DashboardTaskList({super.key, required this.taskList});

  Color _accentColor(Task task) {
    if (task.outdate && !task.completed) return ColorConstants.errorColor;
    if (task.completed) return ColorConstants.successColor;
    return ColorConstants.themeColor;
  }

  IconData _icon(Task task) {
    if (task.outdate && !task.completed) return LucideIcons.circle_alert;
    if (task.completed) return LucideIcons.circle_check;
    return LucideIcons.circle_dot;
  }

  String _statusLabel(Task task) {
    if (task.outdate && !task.completed) return "已超期";
    if (task.completed) return "已完成";
    return "进行中";
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat("MM-dd HH:mm");
    final recent = taskList.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: recent.indexed.map((entry) {
          final i = entry.$1;
          final task = entry.$2;
          final color = _accentColor(task);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UIConstants.gapSize.xl,
                  vertical: UIConstants.gapSize.lg,
                ),
                child: Row(
                  children: [
                    Icon(_icon(task), size: 14, color: color),
                    SizedBox(width: UIConstants.gapSize.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.name,
                            style: TextStyle(
                              fontSize: FontConstants.fontSize.sm,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.defaultTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: UIConstants.gapSize.xs),
                          Row(
                            children: [
                              Text(
                                "截止 ${fmt.format(task.endTimeObject)}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              SizedBox(width: UIConstants.gapSize.md),
                              Text(
                                "${task.totalBuildings} 栋 / ${task.totalPens} 栏",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: UIConstants.gapSize.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${task.progress}%",
                          style: TextStyle(
                            fontSize: FontConstants.fontSize.sm,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        SizedBox(height: UIConstants.gapSize.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _statusLabel(task),
                            style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (i < recent.length - 1)
                Divider(height: 1, indent: 44, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }
}
