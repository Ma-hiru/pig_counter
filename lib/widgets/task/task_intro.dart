import 'package:flutter/material.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/widgets/task/task_intro_detail.dart';
import 'package:pig_counter/widgets/task/task_intro_header.dart';
import 'package:pig_counter/widgets/task/task_intro_info.dart';

class TaskIntro extends StatefulWidget {
  final Task taskData;

  const TaskIntro({super.key, required this.taskData});

  @override
  State<TaskIntro> createState() => _TaskIntroState();
}

class _TaskIntroState extends State<TaskIntro> {
  void onTapDetailPen(Building building, Pen pen) {
    Navigator.pushNamed(
      context,
      RoutesPathConstants.upload,
      arguments: UploadRouteParam(
        task: widget.taskData,
        building: building,
        pen: pen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      elevation: 1,
      margin: .only(bottom: UIConstants.gapSize.md),
      shape: RoundedRectangleBorder(
        borderRadius: .circular(UIConstants.borderRadius),
      ),
      color: Colors.white,
      child: Container(
        padding: .all(UIConstants.gapSize.sm),
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            TaskIntroHeader(taskData: widget.taskData),
            Divider(
              height: UIConstants.gapSize.lg,
              thickness: 1,
              color: Colors.grey[300],
            ),
            TaskIntroInfo(taskData: widget.taskData),
            Divider(
              height: UIConstants.gapSize.lg,
              thickness: 1,
              color: Colors.grey[300],
            ),
            TaskIntroDetail(taskData: widget.taskData, onTap: onTapDetailPen),
          ],
        ),
      ),
    );
  }
}
