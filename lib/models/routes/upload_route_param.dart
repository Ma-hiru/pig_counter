import '../api/task.dart';

class UploadRouteParam {
  final Task task;
  final Pen pen;

  const UploadRouteParam({required this.task, required this.pen});

  factory UploadRouteParam.empty() {
    return UploadRouteParam(task: Task.empty(), pen: Pen.empty());
  }
}
