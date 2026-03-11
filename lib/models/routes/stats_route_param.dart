import 'package:pig_counter/models/api/task.dart';

class StatsRouteParam {
  final Task task;

  const StatsRouteParam(this.task);

  factory StatsRouteParam.empty() {
    return StatsRouteParam(Task.empty());
  }
}
