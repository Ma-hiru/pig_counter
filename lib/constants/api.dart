class APIBaseConstants {
  static const String prefix = "/api";
}

class UserAPIConstants {
  const UserAPIConstants();

  String get login => "/user/login";
  String get refresh => "/user/refresh";
  String get register => "/user/register";
  String get logout => "/user/logout";

  String detail(int id) => "/user/$id";
}

class TaskAPIConstants {
  const TaskAPIConstants();

  String byEmployee(int employeeId) => "/task/$employeeId";
  String detail(int taskId) => "/task/detail/$taskId";
  String receive(int taskId) => "/task/receive/$taskId";
  String complete(int taskId) => "/task/complete/$taskId";
  String get page => "/task/page";
}

class InventoryMediaAPIConstants {
  const InventoryMediaAPIConstants();

  String get upload => "/inventory/media/upload";
  String get uploadUnbound => "/inventory/media/upload/unbound";
  String get library => "/inventory/media/library";
  String get unbound => "/inventory/media/unbound";
  String get bind => "/inventory/media/bind";
  String get confirm => "/inventory/media/confirm";
  String get unlock => "/inventory/media/unlock";
  String get manualCount => "/inventory/media/manual-count";
  String get summary => "/inventory/media/summary";

  String delete(int mediaId) => "/inventory/media/$mediaId";
}

class DeadPigAPIConstants {
  const DeadPigAPIConstants();

  String get create => "/inventory/dead-pig";
  String get daily => "/inventory/dead-pig/daily";
}

class PenAPIConstants {
  const PenAPIConstants();

  String get overview => "/pen/overview";
}

class APIConstants {
  static const UserAPIConstants user = UserAPIConstants();
  static const TaskAPIConstants task = TaskAPIConstants();
  static const InventoryMediaAPIConstants media = InventoryMediaAPIConstants();
  static const DeadPigAPIConstants deadPig = DeadPigAPIConstants();
  static const PenAPIConstants pen = PenAPIConstants();
}
