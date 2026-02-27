import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:pig_counter/constants/color.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class TaskIntroHeader extends StatelessWidget {
  final Task taskData;

  const TaskIntroHeader({super.key, required this.taskData});

  bool get isException => taskData.outdate && !taskData.completed;

  Color get progressColor {
    if (isException) {
      return ColorConstants.errorColor;
    }
    if (taskData.progress >= 1.0) {
      return ColorConstants.successColor;
    }
    return ColorConstants.themeColor;
  }

  IconData get progressIcon {
    if (isException) return LucideIcons.circle_alert;
    if (taskData.progress >= 1.0) return LucideIcons.circle_check;
    return LucideIcons.circle_dot;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: progressColor.withAlpha(20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: .only(right: UIConstants.gapSize.sm),
                child: Icon(
                  progressIcon,
                  size: FontConstants.fontSize.sm,
                  color: progressColor,
                ),
              ),
              Text(
                taskData.name,
                style: TextStyle(
                  color: progressColor,
                  fontFamily: FontConstants.fontFamily,
                  fontSize: FontConstants.fontSize.md,
                  height: 1.2,
                  fontWeight: .w500,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
          Text(
            "${(taskData.progress * 100).round()}%",
            style: TextStyle(
              color: progressColor,
              fontFamily: FontConstants.fontFamily,
              fontSize: FontConstants.fontSize.sm,
              height: 1.2,
              fontWeight: .w500,
              overflow: .ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
