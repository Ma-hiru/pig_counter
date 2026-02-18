enum UploadType { none, image, video }

class Pen {
  int penId;
  String penName;
  int count;
  int manualCount;
  String picturePath;
  String outputPicturePath;
  bool status;
  UploadType type;

  Pen({
    required this.penId,
    required this.penName,
    required this.count,
    required this.manualCount,
    required this.picturePath,
    required this.outputPicturePath,
    required this.status,
    required this.type,
  });

  factory Pen.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Pen");
    }
    return Pen(
      penId: json["penId"] ?? 0,
      penName: json["penName"] ?? "",
      count: json["count"] ?? 0,
      manualCount: json["manualCount"] ?? 0,
      picturePath: json["picturePath"] ?? "",
      outputPicturePath: json["outputPicturePath"] ?? "",
      status: json["status"] ?? false,
      type: parseUploadType(json["type"]),
    );
  }

  static UploadType parseUploadType(dynamic type) {
    switch (type) {
      case "image":
        return UploadType.image;
      case "video":
        return UploadType.video;
      default:
        return UploadType.none;
    }
  }
}

class Building {
  int buildingId;
  String buildingName;
  List<Pen> pens;

  Building({
    required this.buildingId,
    required this.buildingName,
    required this.pens,
  });

  factory Building.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Building");
    }
    return Building(
      buildingId: json["buildingId"] ?? 0,
      buildingName: json["buildingName"] ?? "",
      pens: ((json["pens"] ?? []) as List<dynamic>).map(Pen.fromJson).toList(),
    );
  }
}

class BaseTask {
  final int id;
  final String taskName;
  final int employeeId;
  final String startTime;
  final String endTime;
  final bool valid;

  const BaseTask({
    required this.id,
    required this.taskName,
    required this.employeeId,
    required this.startTime,
    required this.endTime,
    required this.valid,
  });

  factory BaseTask.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for BaseTask");
    }
    return BaseTask(
      id: json["id"] ?? 0,
      taskName: json["taskName"] ?? "",
      employeeId: json["employeeId"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      valid: json["valid"] ?? false,
    );
  }
}

class Task extends BaseTask {
  List<Building> buildings;

  Task({
    required super.id,
    required super.taskName,
    required super.employeeId,
    required super.startTime,
    required super.endTime,
    required super.valid,
    required this.buildings,
  });

  factory Task.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Task");
    }
    return Task(
      id: json["id"] ?? 0,
      taskName: json["taskName"] ?? "",
      employeeId: json["employeeId"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      valid: json["valid"] ?? false,
      buildings: ((json["buildings"] ?? []) as List<dynamic>)
          .map(Building.fromJson)
          .toList(),
    );
  }
}
