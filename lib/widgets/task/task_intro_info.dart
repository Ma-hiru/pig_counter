import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/constants/font.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';

class TaskIntroInfo extends StatelessWidget {
  final Task taskData;

  const TaskIntroInfo({super.key, required this.taskData});

  Widget buildInfoItem(String title, String content) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: FontConstants.fontSize.sm + 1,
          ),
        ),
        SizedBox(width: UIConstants.gapSize.md),
        Text(
          content,
          style: TextStyle(
            fontFamily: FontConstants.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: FontConstants.fontSize.sm + 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInfoItem("任务ID:", taskData.id.toString()),
        buildInfoItem("栏舍数:", taskData.totalPens.toString()),
        buildInfoItem(
          "开始时间:",
          DateFormat("yyyy-MM-dd HH:mm:ss").format(taskData.startTimeObject),
        ),
        buildInfoItem(
          "结束时间:",
          DateFormat("yyyy-MM-dd HH:mm:ss").format(taskData.endTimeObject),
        ),
      ],
    );
  }
}
