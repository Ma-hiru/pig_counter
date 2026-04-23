import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/utils/fetch.dart';

import '../models/api/response.dart';

class TaskAPI {
  List<Task> _parseTaskPage(dynamic data) {
    if (data is! Map<String, dynamic>) return [];
    return ((data["list"] ?? []) as List<dynamic>).map(Task.fromJSON).toList();
  }

  Future<ResponseData<List<Task>>> byEmployee(int employeeId) {
    return fetch.get(APIConstants.task.byEmployee(employeeId), _parseTaskPage);
  }

  Future<ResponseData<List<Task>>> page({
    required int pageNum,
    required int pageSize,
  }) {
    return fetch.get(
      APIConstants.task.page,
      _parseTaskPage,
      queryParameters: {"pageNum": pageNum, "pageSize": pageSize},
    );
  }

  Future<ResponseData<Task>> detail(int taskId) {
    return fetch.get(APIConstants.task.detail(taskId), Task.fromJSON);
  }

  Future<ResponseData<Null>> receive(int taskId) {
    return fetch.post(APIConstants.task.receive(taskId), null, data: {});
  }

  Future<ResponseData<Null>> complete(int taskId) {
    return fetch.post(APIConstants.task.complete(taskId), null, data: {});
  }

  Future<ResponseData<Null>> success(int taskId) {
    return complete(taskId);
  }
}
