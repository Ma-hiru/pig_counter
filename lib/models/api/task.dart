import 'dart:math';

enum UploadType { none, image, video }

class Pen {
  int id;
  int aiCount;
  int manualCount;
  bool status;
  String name;
  String uploadPath;
  String outputPath;
  UploadType type;
  String? localPath;
  UploadType? localType;

  Pen({
    required this.id,
    required this.name,
    required this.aiCount,
    required this.manualCount,
    required this.uploadPath,
    required this.outputPath,
    required this.status,
    required this.type,
  });

  factory Pen.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Pen");
    }
    return Pen(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      aiCount: json["aiCount"] ?? 0,
      manualCount: json["manualCount"] ?? 0,
      uploadPath: json["uploadPath"] ?? "",
      outputPath: json["outputPath"] ?? "",
      status: json["status"] ?? false,
      type: parseUploadType(json["type"]),
    );
  }

  factory Pen.empty() {
    return Pen(
      id: -1,
      name: "",
      aiCount: 0,
      manualCount: 0,
      uploadPath: "",
      outputPath: "",
      status: false,
      type: UploadType.none,
    );
  }

  Pen copyWith({
    int? id,
    String? name,
    int? aiCount,
    int? manualCount,
    String? uploadPath,
    String? outputPath,
    bool? status,
    UploadType? type,
    String? localPath,
    UploadType? localType,
  }) {
    return Pen(
        id: id ?? this.id,
        name: name ?? this.name,
        aiCount: aiCount ?? this.aiCount,
        manualCount: manualCount ?? this.manualCount,
        uploadPath: uploadPath ?? this.uploadPath,
        outputPath: outputPath ?? this.outputPath,
        status: status ?? this.status,
        type: type ?? this.type,
      )
      ..localPath = localPath ?? this.localPath
      ..localType = localType ?? this.localType;
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
  int id;
  String name;
  List<Pen> pens;

  Building({required this.id, required this.name, required this.pens});

  int get completedPenCount => pens.where((p) => p.status).length;

  int get totalPens => pens.length;

  double get progress => totalPens == 0 ? 0 : (completedPenCount / totalPens);

  bool get completed => completedPenCount == totalPens && totalPens > 0;

  factory Building.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Building");
    }
    return Building(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
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
  final bool valid;

  const BaseTask({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.startTime,
    required this.endTime,
    required this.valid,
  });

  DateTime get startTimeObject => DateTime.tryParse(startTime)!.toLocal();

  DateTime get endTimeObject => DateTime.tryParse(endTime)!.toLocal();

  factory BaseTask.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for BaseTask");
    }
    return BaseTask(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      employeeId: json["employeeId"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      valid: json["valid"] ?? false,
    );
  }

  factory BaseTask.empty() {
    return BaseTask(
      id: -1,
      name: "",
      employeeId: -1,
      startTime: DateTime.now().toUtc().toIso8601String(),
      endTime: DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
      valid: true,
    );
  }
}

class Task extends BaseTask {
  List<Building> buildings;

  Task({
    required super.id,
    required super.name,
    required super.employeeId,
    required super.startTime,
    required super.endTime,
    required super.valid,
    required this.buildings,
  });

  double get progress {
    var totalPens = buildings.fold(
      0,
      (sum, building) => sum + building.pens.length,
    );
    var completedPens = buildings.fold(
      0,
      (sum, building) => sum + building.pens.where((pen) => pen.status).length,
    );

    if (totalPens == 0) return 0;
    return completedPens / totalPens;
  }

  int get totalBuildings => buildings.length;

  int get totalPens =>
      buildings.fold(0, (sum, building) => sum + building.pens.length);

  bool get completed => progress >= 100;

  bool get outdate => DateTime.now().isAfter(endTimeObject);

  factory Task.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for Task");
    }
    return Task(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      employeeId: json["employeeId"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      valid: json["valid"] ?? false,
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
      valid: true,
      buildings: [
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000),
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
              status: false,
              type: UploadType.none,
            ),
          ],
        ),
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000),
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
              status: false,
              type: UploadType.none,
            ),
          ],
        ),
        Building(
          id: Random(DateTime.now().microsecond).nextInt(1000),
          name: "Building A${Random(DateTime.now().microsecond).nextInt(1000)}",
          pens: [
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: true,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 10,
              manualCount: 10,
              uploadPath: "/path/to/picture.jpg",
              outputPath: "/path/to/output.jpg",
              status: false,
              type: UploadType.image,
            ),
            Pen(
              id: Random(DateTime.now().microsecond).nextInt(1000),
              name: "Pen ${Random(DateTime.now().microsecond).nextInt(1000)}",
              aiCount: 0,
              manualCount: 0,
              uploadPath: "",
              outputPath: "",
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
      valid: true,
      buildings: [],
    );
  }
}
