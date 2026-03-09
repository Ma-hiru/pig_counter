import 'package:pig_counter/models/api/task.dart';

import '../models/api/response.dart';

class TaskAPI {
  Future<ResponseData<Pen>> pen(int id) async {
    return .success(.empty());
  }

  Future<ResponseData<Building>> building(int id) async {
    return .success(.empty());
  }

  Future<ResponseData<Task>> detail(int id) async {
    return .success(.empty());
  }
}
