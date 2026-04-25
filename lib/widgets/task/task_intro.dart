import 'package:flutter/material.dart';
import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/constants/color.dart';
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
  final Future<void> Function()? onTaskUpdated;

  const TaskIntro({
    super.key,
    required this.taskData,
    this.onTap,
    this.disableDetail,
    this.onTaskUpdated,
  });

  @override
  State<TaskIntro> createState() => _TaskIntroState();
}

class _TaskIntroState extends State<TaskIntro> {
  bool _completing = false;

  bool _isPenReadyForCompletion(Pen pen) {
    return pen.status ||
        pen.mediaId > 0 ||
        pen.hasRemoteMedia ||
        pen.isProcessing;
  }

  String? _validateTaskBeforeComplete(Task task) {
    if (task.totalPens <= 0) {
      return "当前任务还没有分配栏舍，暂时不能完成";
    }

    if (task.buildings.isEmpty) {
      if (task.uploadedPenCount < task.assignedPenCount) {
        return "还有栏舍未上传媒体，请先完成上传后再提交任务";
      }
      return null;
    }

    final pendingPens = <String>[];
    for (final building in task.buildings) {
      for (final pen in building.pens) {
        if (_isPenReadyForCompletion(pen)) continue;
        final buildingName = building.name.isNotEmpty ? building.name : "楼栋";
        final penName = pen.name.isNotEmpty ? pen.name : "栏舍";
        pendingPens.add("$buildingName/$penName");
      }
    }

    if (pendingPens.isEmpty) return null;

    final preview = pendingPens.take(3).join("、");
    if (pendingPens.length == 1) {
      return "还有栏舍未上传：$preview";
    }
    return "还有 ${pendingPens.length} 个栏舍未上传，例如：$preview";
  }

  Future<Task> _refreshTaskQuietly(Task task) async {
    try {
      final detailResult = await API.Task.detail(task.id);
      if (detailResult.ok) {
        return detailResult.data;
      }
    } catch (_) {}
    return task;
  }

  Future<Task> _ensureTaskReady(Task task) async {
    Task latestTask = task;
    if (!latestTask.taskStatusValue.isPending) {
      return _refreshTaskQuietly(latestTask);
    }
    try {
      await API.Task.receive(latestTask.id);
    } catch (_) {}
    return _refreshTaskQuietly(latestTask);
  }

  Future<void> onTapDetailPen(Building building, Pen pen) async {
    Task latestTask = await _ensureTaskReady(widget.taskData);

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

  Future<void> onTapDeadPigPen(Building building, Pen pen) async {
    Task latestTask = await _ensureTaskReady(widget.taskData);

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
      RoutesPathConstants.deadPig,
      arguments: UploadRouteParam(
        task: latestTask,
        building: targetBuilding,
        pen: targetPen,
      ),
    );
  }

  Future<void> completeTask() async {
    if (_completing) return;
    setState(() => _completing = true);
    try {
      final latestTask = await _ensureTaskReady(widget.taskData);
      final validateMessage = _validateTaskBeforeComplete(latestTask);
      if (validateMessage != null) {
        Toast.showToast(.error(validateMessage));
        return;
      }
      final completeResult = await API.Task.complete(latestTask.id);
      if (!completeResult.ok) {
        Toast.showToast(
          .error(
            completeResult.message.isNotEmpty
                ? completeResult.message
                : "完成任务失败",
          ),
        );
        return;
      }
      Toast.showToast(.success("任务已提交完成"));
      await widget.onTaskUpdated?.call();
    } catch (_) {
      Toast.showToast(.error("完成任务失败，请稍后重试"));
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  Widget buildTaskAction() {
    if (widget.disableDetail == true || widget.taskData.completed) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: UIConstants.gapSize.md),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ColorConstants.themeColor,
                foregroundColor: ColorConstants.textColorOnTheme,
                disabledBackgroundColor: ColorConstants.themeColor.withAlpha(
                  140,
                ),
                disabledForegroundColor: ColorConstants.textColorOnTheme
                    .withAlpha(190),
              ),
              onPressed: _completing ? null : completeTask,
              child: Text(_completing ? "提交中..." : "完成任务"),
            ),
          ),
        ],
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
              TaskIntroDetail(
                taskData: widget.taskData,
                onTap: onTapDetailPen,
                onTapDeadPig: onTapDeadPigPen,
              ),
            buildTaskAction(),
          ],
        ),
      ),
    );
  }
}
