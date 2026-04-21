import 'package:pig_counter/models/api/task.dart';
import 'package:pig_counter/utils/fetch.dart';

import '../models/api/response.dart';

class TaskAPI {
  Future<ResponseData<Pen>> pen(int id) async {
    return .success(.empty());
  }

  Future<ResponseData<Building>> building(int id) async {
    return .success(.empty());
  }

  Future<ResponseData<Task>> detail(int taskID) async {
    return fetch.get("/task/detail/$taskID", Task.fromJSON);
  }

  Future<ResponseData<Null>> success(int taskID) {
    return fetch.post("/task/complete/$taskID", null);
  }
}
