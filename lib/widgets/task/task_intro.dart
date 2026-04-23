import 'package:flutter/material.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/routes.dart';
import 'package:pig_counter/constants/ui.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/models/routes/upload_route_param.dart';
import 'package:pig_counter/utils/toast.dart';
import 'package:pig_counter/widgets/task/task_intro_detail.dart';
import 'package:pig_counter/widgets/task/task_intro_header.dart';
import 'package:pig_counter/widgets/task/task_intro_info.dart';

class TaskIntro extends StatefulWidget {
  final Task taskData;
  final VoidCallback? onTap;
  final bool? disableDetail;

  const TaskIntro({
    super.key,
    required this.taskData,
    this.onTap,
    this.disableDetail,
  });

  @override
  State<TaskIntro> createState() => _TaskIntroState();
}

class _TaskIntroState extends State<TaskIntro> {
  Future<void> onTapDetailPen(Building building, Pen pen) async {
    Task latestTask = widget.taskData;

    if (latestTask.taskStatusValue.isPending) {
      try {
        final receiveResult = await API.Task.receive(latestTask.id);
        if (!receiveResult.ok) {
          Toast.showToast(
            .error(
              receiveResult.message.isNotEmpty
                  ? receiveResult.message
                  : "接收任务失败",
            ),
          );
          return;
        }

        final detailResult = await API.Task.detail(latestTask.id);
        if (detailResult.ok) {
          latestTask = detailResult.data;
        }
        Toast.showToast(.success("任务已接收"));
      } catch (_) {
        Toast.showToast(.error("接收任务失败，请稍后重试"));
        return;
      }
    }

    Building targetBuilding = building;
    for (final item in latestTask.buildings) {
      if (item.id == building.id) {
        targetBuilding = item;
        break;
      }
    }
    if (targetBuilding.id <= 0 && latestTask.buildings.isNotEmpty) {
      targetBuilding = latestTask.buildings.first;
    }

    Pen targetPen = pen;
    for (final item in targetBuilding.pens) {
      if (item.id == pen.id) {
        targetPen = item;
        break;
      }
    }
    if (targetPen.id <= 0 && targetBuilding.pens.isNotEmpty) {
      targetPen = targetBuilding.pens.first;
    }

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      RoutesPathConstants.upload,
      arguments: UploadRouteParam(
        task: latestTask,
        building: targetBuilding,
        pen: targetPen,
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
            GestureDetector(
              onTap: widget.onTap,
              child: TaskIntroHeader(taskData: widget.taskData),
            ),
            Divider(
              height: UIConstants.gapSize.lg,
              thickness: 1,
              color: Colors.grey[300],
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: TaskIntroInfo(taskData: widget.taskData),
            ),
            if (widget.disableDetail != true)
              Divider(
                height: UIConstants.gapSize.lg,
                thickness: 1,
                color: Colors.grey[300],
              ),
            if (widget.disableDetail != true)
              TaskIntroDetail(taskData: widget.taskData, onTap: onTapDetailPen),
          ],
        ),
      ),
    );
  }
}
