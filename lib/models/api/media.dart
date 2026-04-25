class InventoryMediaItem {
  final int mediaId;
  final int taskId;
  final int orgId;
  final int penId;
  final String mediaType;
  final String picturePath;
  final String outputPicturePath;
  final String thumbnailPath;
  final int count;
  final int manualCount;
  final String processingStatus;
  final String processingMessage;
  final bool status;
  final String captureTime;
  final String time;
  final String dayBucket;
  final bool duplicate;
  final String analysisJson;

  const InventoryMediaItem({
    required this.mediaId,
    required this.taskId,
    required this.orgId,
    required this.penId,
    required this.mediaType,
    required this.picturePath,
    required this.outputPicturePath,
    required this.thumbnailPath,
    required this.count,
    required this.manualCount,
    required this.processingStatus,
    required this.processingMessage,
    required this.status,
    required this.captureTime,
    required this.time,
    required this.dayBucket,
    required this.duplicate,
    required this.analysisJson,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == "true" || lower == "1";
    }
    return false;
  }

  static String _toStringSafe(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  factory InventoryMediaItem.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for InventoryMediaItem");
    }
    return InventoryMediaItem(
      mediaId: _toInt(json["mediaId"] ?? json["id"]),
      taskId: _toInt(json["taskId"]),
      orgId: _toInt(json["orgId"]),
      penId: _toInt(json["penId"]),
      mediaType: _toStringSafe(json["mediaType"]),
      picturePath: _toStringSafe(json["picturePath"]),
      outputPicturePath: _toStringSafe(json["outputPicturePath"]),
      thumbnailPath: _toStringSafe(json["thumbnailPath"]),
      count: _toInt(json["count"]),
      manualCount: _toInt(json["manualCount"]),
      processingStatus: _toStringSafe(json["processingStatus"]),
      processingMessage: _toStringSafe(json["processingMessage"]),
      status: _toBool(json["status"]),
      captureTime: _toStringSafe(json["captureTime"]),
      time: _toStringSafe(json["time"]),
      dayBucket: _toStringSafe(json["dayBucket"]),
      duplicate: _toBool(json["duplicate"]),
      analysisJson: _toStringSafe(json["analysisJson"]),
    );
  }
}

class DuplicateMediaItem {
  final String fileName;
  final int duplicateOfMediaId;
  final int duplicateOfTaskId;
  final int duplicateOfPenId;
  final String existingPicturePath;
  final String existingCaptureTime;
  final double similarityScore;
  final String message;

  const DuplicateMediaItem({
    required this.fileName,
    required this.duplicateOfMediaId,
    required this.duplicateOfTaskId,
    required this.duplicateOfPenId,
    required this.existingPicturePath,
    required this.existingCaptureTime,
    required this.similarityScore,
    required this.message,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _toStringSafe(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  factory DuplicateMediaItem.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for DuplicateMediaItem");
    }
    return DuplicateMediaItem(
      fileName: _toStringSafe(json["fileName"]),
      duplicateOfMediaId: _toInt(json["duplicateOfMediaId"]),
      duplicateOfTaskId: _toInt(json["duplicateOfTaskId"]),
      duplicateOfPenId: _toInt(json["duplicateOfPenId"]),
      existingPicturePath: _toStringSafe(json["existingPicturePath"]),
      existingCaptureTime: _toStringSafe(json["existingCaptureTime"]),
      similarityScore: _toDouble(json["similarityScore"]),
      message: _toStringSafe(json["message"]),
    );
  }
}

class InventoryMediaUploadResult {
  final int taskId;
  final List<InventoryMediaItem> createdItems;
  final List<DuplicateMediaItem> duplicateItems;

  const InventoryMediaUploadResult({
    required this.taskId,
    required this.createdItems,
    required this.duplicateItems,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory InventoryMediaUploadResult.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        "Invalid JSON format for InventoryMediaUploadResult",
      );
    }
    return InventoryMediaUploadResult(
      taskId: _toInt(json["taskId"]),
      createdItems: ((json["createdItems"] ?? []) as List<dynamic>)
          .map(InventoryMediaItem.fromJSON)
          .toList(),
      duplicateItems: ((json["duplicateItems"] ?? []) as List<dynamic>)
          .map(DuplicateMediaItem.fromJSON)
          .toList(),
    );
  }

  factory InventoryMediaUploadResult.empty() {
    return const InventoryMediaUploadResult(
      taskId: 0,
      createdItems: [],
      duplicateItems: [],
    );
  }
}
