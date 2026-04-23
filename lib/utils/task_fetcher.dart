import 'package:pig_counter/api/index.dart';
import 'package:pig_counter/models/api/task.dart';

Future<List<Task>> fetchEmployeeTasksWithDetails(int employeeId) async {
  final listResponse = await API.Task.byEmployee(employeeId);
  if (!listResponse.ok) {
    throw StateError(
      listResponse.message.isNotEmpty ? listResponse.message : "获取任务失败",
    );
  }

  final summaries = listResponse.data;
  if (summaries.isEmpty) return const [];

  final details = await Future.wait(
    summaries.map((summary) async {
      try {
        final detailResponse = await API.Task.detail(summary.id);
        if (detailResponse.ok) {
          return detailResponse.data;
        }
      } catch (_) {
        // 如果详情失败，回退到摘要，保证任务列表可展示
      }
      return summary;
    }),
  );

  return details;
}
