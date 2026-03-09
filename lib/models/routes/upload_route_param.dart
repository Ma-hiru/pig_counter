import '../api/task.dart';

class UploadRouteParam {
  final Task task;
  final Building building;
  final Pen pen;

  const UploadRouteParam({
    required this.task,
    required this.building,
    required this.pen,
  });

  factory UploadRouteParam.empty() {
    return UploadRouteParam(task: .empty(), building: .empty(), pen: .empty());
  }

  UploadRouteParam copyWith({Task? task, Building? building, Pen? pen}) {
    return UploadRouteParam(
      task: task ?? this.task,
      building: building ?? this.building,
      pen: pen ?? this.pen,
    );
  }
}
