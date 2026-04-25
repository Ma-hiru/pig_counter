class DeadPigMediaItem {
  final int id;
  final String picturePath;
  final double similarityScore;

  const DeadPigMediaItem({
    required this.id,
    required this.picturePath,
    required this.similarityScore,
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

  factory DeadPigMediaItem.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for DeadPigMediaItem");
    }
    return DeadPigMediaItem(
      id: _toInt(json["id"]),
      picturePath: _toStringSafe(json["picturePath"]),
      similarityScore: _toDouble(json["similarityScore"]),
    );
  }
}

class DeadPigReport {
  final int reportId;
  final int orgId;
  final int penId;
  final String reportDate;
  final int quantity;
  final String remark;
  final String status;
  final String createdAt;
  final List<DeadPigMediaItem> mediaList;

  const DeadPigReport({
    required this.reportId,
    required this.orgId,
    required this.penId,
    required this.reportDate,
    required this.quantity,
    required this.remark,
    required this.status,
    required this.createdAt,
    required this.mediaList,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _toStringSafe(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  factory DeadPigReport.fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw FormatException("Invalid JSON format for DeadPigReport");
    }
    return DeadPigReport(
      reportId: _toInt(json["reportId"] ?? json["id"]),
      orgId: _toInt(json["orgId"]),
      penId: _toInt(json["penId"]),
      reportDate: _toStringSafe(json["reportDate"]),
      quantity: _toInt(json["quantity"]),
      remark: _toStringSafe(json["remark"]),
      status: _toStringSafe(json["status"]),
      createdAt: _toStringSafe(json["createdAt"]),
      mediaList: ((json["mediaList"] ?? []) as List<dynamic>)
          .map(DeadPigMediaItem.fromJSON)
          .toList(),
    );
  }
}
