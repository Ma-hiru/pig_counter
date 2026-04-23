import 'dart:math';

enum UploadType { none, image, video }

extension UploadTypeExt on UploadType {
  String get name {
    switch (this) {
      case UploadType.image:
        return "image";
      case UploadType.video:
        return "video";
      case UploadType.none:
        return "none";
    }
  }

  static UploadType fromName(String name) {
    switch (name) {
      case "image":
        return UploadType.image;
      case "video":
        return UploadType.video;
      default:
        return UploadType.none;
    }
  }

  static UploadType fromRaw(dynamic raw) {
    return fromName((raw ?? "").toString().toLowerCase());
  }
}

enum TaskStatus { pending, inProgress, completed, unknown }

extension TaskStatusExt on TaskStatus {
  static TaskStatus fromRaw(dynamic raw) {
    final name = (raw ?? "").toString().toUpperCase();
    switch (name) {
      case "PENDING":
        return TaskStatus.pending;
      case "IN_PROGRESS":
      case "PROCESSING":
        return TaskStatus.inProgress;
      case "COMPLETED":
      case "DONE":
        return TaskStatus.completed;
      default:
        return TaskStatus.unknown;
    }
  }

  bool get isPending => this == TaskStatus.pending;

  bool get isInProgress => this == TaskStatus.inProgress;

  bool get isCompleted => this == TaskStatus.completed;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == "true" || lower == "1";
  }
  if (value is int) return value != 0;
  return false;
}

String _toStringSafe(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

DateTime _parseDateTimeOrEpoch(String raw) {
  if (raw.isEmpty) {
    return DateTime.fromMillisecondsSinceEpoch(0).toLocal();
  }
  final normalized = raw.contains("T") ? raw : raw.replaceFirst(" ", "T");
  return DateTime.tryParse(normalized)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0).toLocal();
}

class Pen {
  int id;
  int mediaId;
  int aiCount;
  int manualCount;
  bool status;
  String name;
  String uploadPath;
  String outputPath;
  String thumbnailPath;
  String processingStatus;
  String processingMessage;
  String captureTime;
  UploadType type;
  String localPath;
  UploadType localType;

  Pen({
    required this.id,
    required this.mediaId,
    required this.name,
    required this.aiCount,
    required this.manualCount,
    required this.uploadPath,
    required this.outputPath,
    required this.thumbnailPath,
    required this.processingStatus,
    required this.processingMessage,
    required this.captureTime,
    required this.status,
    required this.type,
    this.localPath = "",
    this.localType = .none,
  });

  bool get hasRemoteMedia => uploadPath.isNotEmpty || outputPath.isNotEmpty;

  bool get isProcessing {
    final normalized = processingStatus.toUpperCase();
    if (normalized == "PENDING" || normalized == "PROCESSING") {
      return true;
    }
    return uploadPath.isNotEmpty && outputPath.isEmpty && !status;
  }

  bool get isFailed => processingStatus.toUpperCase() == "FAILED";

  int get displayCount => manualCount > 0 ? manualCount : aiCount;

  factory Pen.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Pen");
    }
    return Pen(
      id: _toInt(json["penId"] ?? json["id"]),
      mediaId: _toInt(json["mediaId"] ?? json["id"]),
      name: _toStringSafe(json["penName"] ?? json["name"]),
      aiCount: _toInt(json["count"] ?? json["aiCount"]),
      manualCount: _toInt(json["manualCount"]),
      uploadPath: _toStringSafe(json["picturePath"] ?? json["uploadPath"]),
      outputPath: _toStringSafe(
        json["outputPicturePath"] ?? json["outputPath"],
      ),
      thumbnailPath: _toStringSafe(json["thumbnailPath"]),
      processingStatus: _toStringSafe(json["processingStatus"]),
      processingMessage: _toStringSafe(json["processingMessage"]),
      captureTime: _toStringSafe(json["captureTime"]),
      status: _toBool(json["status"]),
      type: parseUploadType(json["mediaType"] ?? json["type"]),
    );
  }

  factory Pen.empty() {
    return Pen(
      id: -1,
      mediaId: 0,
      name: "",
      aiCount: 0,
      manualCount: 0,
      uploadPath: "",
      outputPath: "",
      thumbnailPath: "",
      processingStatus: "",
      processingMessage: "",
      captureTime: "",
      status: false,
      type: UploadType.none,
    );
  }

  Pen copyWith({
    int? id,
    int? mediaId,
    String? name,
    int? aiCount,
    int? manualCount,
    String? uploadPath,
    String? outputPath,
    String? thumbnailPath,
    String? processingStatus,
    String? processingMessage,
    String? captureTime,
    bool? status,
    UploadType? type,
    String? localPath,
    UploadType? localType,
  }) {
    return Pen(
      id: id ?? this.id,
      mediaId: mediaId ?? this.mediaId,
      name: name ?? this.name,
      aiCount: aiCount ?? this.aiCount,
      manualCount: manualCount ?? this.manualCount,
      uploadPath: uploadPath ?? this.uploadPath,
      outputPath: outputPath ?? this.outputPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      processingStatus: processingStatus ?? this.processingStatus,
      processingMessage: processingMessage ?? this.processingMessage,
      captureTime: captureTime ?? this.captureTime,
      status: status ?? this.status,
      type: type ?? this.type,
      localPath: localPath ?? this.localPath,
      localType: localType ?? this.localType,
    );
  }

  static UploadType parseUploadType(dynamic type) {
    return UploadTypeExt.fromRaw(type);
  }
}

class Building {
  int id;
  String name;
  List<Pen> pens;

  Building({required this.id, required this.name, required this.pens});

  int get completedPenCount => pens.where((p) => p.status).length;

  int get totalPens => pens.length;

  double get progress => totalPens == 0 ? 0 : (completedPenCount / totalPens);

  bool get completed => completedPenCount == totalPens && totalPens > 0;

  int get aiCount => pens.fold(0, (s, p) => s + p.aiCount);

  int get manualCount => pens.fold(0, (s, p) => s + p.manualCount);

  factory Building.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Building");
    }
    return Building(
      id: _toInt(json["buildingId"] ?? json["id"]),
      name: _toStringSafe(json["buildingName"] ?? json["name"]),
      pens: ((json["pens"] ?? []) as List<dynamic>).map(Pen.fromJSON).toList(),
    );
  }

  factory Building.empty() {
    return Building(id: -1, name: "", pens: []);
  }
}

class BaseTask {
  final int id;
  final String name;
  final int employeeId;
  final String startTime;
  final String endTime;
  final int orgId;
  final String taskStatus;
  final String issuedAt;
  final String receivedAt;
  final String completedAt;
  final bool valid;

  const BaseTask({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.startTime,
    required this.endTime,
    required this.orgId,
    required this.taskStatus,
    required this.issuedAt,
    required this.receivedAt,
    required this.completedAt,
    required this.valid,
  });

  DateTime get startTimeObject => _parseDateTimeOrEpoch(startTime);

  DateTime get endTimeObject => _parseDateTimeOrEpoch(endTime);

  TaskStatus get taskStatusValue => TaskStatusExt.fromRaw(taskStatus);

  factory BaseTask.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for BaseTask");
    }
    return BaseTask(
      id: _toInt(json["id"]),
      name: _toStringSafe(json["taskName"] ?? json["name"]),
      employeeId: _toInt(json["employeeId"]),
      startTime: _toStringSafe(json["startTime"]),
      endTime: _toStringSafe(json["endTime"]),
      orgId: _toInt(json["orgId"]),
      taskStatus: _toStringSafe(json["taskStatus"]),
      issuedAt: _toStringSafe(json["issuedAt"]),
      receivedAt: _toStringSafe(json["receivedAt"]),
      completedAt: _toStringSafe(json["completedAt"]),
      valid: _toBool(json["valid"] ?? true),
    );
  }

  factory BaseTask.empty() {
    return BaseTask(
      id: -1,
      name: "",
      employeeId: -1,
      startTime: DateTime.now().toUtc().toIso8601String(),
      endTime: DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
      orgId: -1,
      taskStatus: "",
      issuedAt: "",
      receivedAt: "",
      completedAt: "",
      valid: true,
    );
  }
}

class Task extends BaseTask {
  int assignedPenCount;
  int uploadedPenCount;
  int confirmedPenCount;
  int processingPenCount;
  int failedPenCount;
  int unboundMediaCount;
  List<Building> buildings;

  Task({
    required super.id,
    required super.name,
    required super.employeeId,
    required super.startTime,
    required super.endTime,
    required super.orgId,
    required super.taskStatus,
    required super.issuedAt,
    required super.receivedAt,
    required super.completedAt,
    required super.valid,
    this.assignedPenCount = 0,
    this.uploadedPenCount = 0,
    this.confirmedPenCount = 0,
    this.processingPenCount = 0,
    this.failedPenCount = 0,
    this.unboundMediaCount = 0,
    required this.buildings,
  });

  double get progress {
    if (totalPens > 0) {
      return (completedPens / totalPens).clamp(0.0, 1.0);
    }
    if (assignedPenCount > 0) {
      return (confirmedPenCount / assignedPenCount).clamp(0.0, 1.0);
    }
    if (taskStatusValue.isCompleted) return 1;
    if (taskStatusValue.isInProgress) return 0.5;
    return 0;
  }

  int get totalBuildings => buildings.length;

  int get totalPens {
    if (buildings.isNotEmpty) {
      return buildings.fold(0, (sum, building) => sum + building.pens.length);
    }
    return assignedPenCount;
  }

  bool get completed {
    if (taskStatusValue.isCompleted) return true;
    return totalPens > 0 && completedPens >= totalPens;
  }

  int get completedPens {
    if (buildings.isNotEmpty) {
      return buildings.fold(
        0,
        (sum, building) =>
            sum + building.pens.where((pen) => pen.status).length,
      );
    }
    return confirmedPenCount;
  }

  bool get outdate => DateTime.now().isAfter(endTimeObject) && !completed;

  int get aiCount => buildings.fold(0, (s, b) => s + b.aiCount);

  int get manualCount => buildings.fold(
    0,
    (s, b) => s + b.pens.fold(0, (ps, p) => ps + p.manualCount),
  );

  Task copyWith({
    int? id,
    String? name,
    int? employeeId,
    String? startTime,
    String? endTime,
    int? orgId,
    String? taskStatus,
    String? issuedAt,
    String? receivedAt,
    String? completedAt,
    bool? valid,
    int? assignedPenCount,
    int? uploadedPenCount,
    int? confirmedPenCount,
    int? processingPenCount,
    int? failedPenCount,
    int? unboundMediaCount,
    List<Building>? buildings,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      orgId: orgId ?? this.orgId,
      taskStatus: taskStatus ?? this.taskStatus,
      issuedAt: issuedAt ?? this.issuedAt,
      receivedAt: receivedAt ?? this.receivedAt,
      completedAt: completedAt ?? this.completedAt,
      valid: valid ?? this.valid,
      assignedPenCount: assignedPenCount ?? this.assignedPenCount,
      uploadedPenCount: uploadedPenCount ?? this.uploadedPenCount,
      confirmedPenCount: confirmedPenCount ?? this.confirmedPenCount,
      processingPenCount: processingPenCount ?? this.processingPenCount,
      failedPenCount: failedPenCount ?? this.failedPenCount,
      unboundMediaCount: unboundMediaCount ?? this.unboundMediaCount,
      buildings: buildings ?? this.buildings,
    );
  }

  factory Task.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Task");
    }
    return Task(
      id: _toInt(json["id"]),
      name: _toStringSafe(json["taskName"] ?? json["name"]),
      employeeId: _toInt(json["employeeId"]),
      startTime: _toStringSafe(json["startTime"]),
      endTime: _toStringSafe(json["endTime"]),
      orgId: _toInt(json["orgId"]),
      taskStatus: _toStringSafe(json["taskStatus"]),
      issuedAt: _toStringSafe(json["issuedAt"]),
      receivedAt: _toStringSafe(json["receivedAt"]),
      completedAt: _toStringSafe(json["completedAt"]),
      valid: _toBool(json["valid"] ?? true),
      assignedPenCount: _toInt(json["assignedPenCount"]),
      uploadedPenCount: _toInt(json["uploadedPenCount"]),
      confirmedPenCount: _toInt(json["confirmedPenCount"]),
      processingPenCount: _toInt(json["processingPenCount"]),
      failedPenCount: _toInt(json["failedPenCount"]),
      unboundMediaCount: _toInt(json["unboundMediaCount"]),
      buildings: ((json["buildings"] ?? []) as List<dynamic>)
          .map(Building.fromJSON)
          .toList(),
    );
  }

  factory Task.test(dynamic value) {
    return Task(
      id: Random(DateTime.now().microsecond).nextInt(1000),
      name: "Test Task${Random(DateTime.now().microsecond).nextInt(1000)}",
      employeeId: Random(DateTime.now().microsecond).nextInt(1000),
      startTime: DateTime.now().toUtc().toIso8601String(),
      endTime: DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
      orgId: 1,
      taskStatus: "IN_PROGRESS",
      issuedAt: DateTime.now().toUtc().toIso8601String(),
      receivedAt: DateTime.now().toUtc().toIso8601String(),
      completedAt: "",
      valid: true,
      buildings: [
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000) + 1,
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 1,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 1,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 2,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 2,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 3,
              mediaId: 0,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
              thumbnailPath: "",
              processingStatus: "",
              processingMessage: "",
              captureTime: "",
              status: false,
              type: UploadType.none,
            ),
          ],
        ),
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000) + 2,
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 4,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 4,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 5,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 5,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 6,
              mediaId: 0,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
              thumbnailPath: "",
              processingStatus: "",
              processingMessage: "",
              captureTime: "",
              status: false,
              type: UploadType.none,
            ),
          ],
        ),
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000) + 3,
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 7,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 7,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 8,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 8,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "PROCESSING",
              processingMessage: "处理中",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 9,
              mediaId: Random(DateTime.now().microsecond).nextInt(10000) + 9,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 0,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              thumbnailPath: "/path/to/thumbnail.jpg",
              processingStatus: "SUCCESS",
              processingMessage: "",
              captureTime: DateTime.now().toUtc().toIso8601String(),
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000) + 10,
              mediaId: 0,
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
              thumbnailPath: "",
              processingStatus: "",
              processingMessage: "",
              captureTime: "",
              status: false,
              type: UploadType.none,
            ),
          ],
        ),
      ],
    );
  }

  factory Task.empty() {
    return Task(
      id: -1,
      name: "",
      employeeId: -1,
      startTime: DateTime.now().toUtc().toIso8601String(),
      endTime: DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
      orgId: -1,
      taskStatus: "",
      issuedAt: "",
      receivedAt: "",
      completedAt: "",
      valid: true,
      assignedPenCount: 0,
      uploadedPenCount: 0,
      confirmedPenCount: 0,
      processingPenCount: 0,
      failedPenCount: 0,
      unboundMediaCount: 0,
      buildings: [],
    );
  }
}
