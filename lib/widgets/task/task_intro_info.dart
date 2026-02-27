import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pig_counter/models/api/task.dart';

class TaskIntroInfo extends StatelessWidget {
  final Task taskData;

  const TaskIntroInfo({super.key, required this.taskData});

  Widget buildInfoItem(String title, String content) {
    return Row(children: [Text(title), SizedBox(width: 8), Text(content)]);
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
