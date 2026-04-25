import 'package:pig_counter/models/api/media.dart';

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

String _toStringSafe(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

Map<String, dynamic> _toMap(dynamic value) {
  return value is Map<String, dynamic> ? value : <String, dynamic>{};
}

List<dynamic> _toList(dynamic value) {
  return value is List<dynamic> ? value : const [];
}

class PenInventoryStat {
  final int sampleSize;
  final double avgCount;
  final int minCount;
  final int maxCount;
  final int finalCount;
  final int deadPigQuantity;

  const PenInventoryStat({
    required this.sampleSize,
    required this.avgCount,
    required this.minCount,
    required this.maxCount,
    required this.finalCount,
    required this.deadPigQuantity,
  });

  factory PenInventoryStat.fromJSON(dynamic json) {
    final data = _toMap(json);
    return PenInventoryStat(
      sampleSize: _toInt(data["sampleSize"]),
      avgCount: _toDouble(data["avgCount"]),
      minCount: _toInt(data["minCount"]),
      maxCount: _toInt(data["maxCount"]),
      finalCount: _toInt(data["finalCount"]),
      deadPigQuantity: _toInt(data["deadPigQuantity"]),
    );
  }

  factory PenInventoryStat.empty() {
    return const PenInventoryStat(
      sampleSize: 0,
      avgCount: 0,
      minCount: 0,
      maxCount: 0,
      finalCount: 0,
      deadPigQuantity: 0,
    );
  }
}

class PenInventoryMediaSummary {
  final int totalMediaCount;
  final int imageMediaCount;
  final int videoMediaCount;
  final int confirmedMediaCount;
  final int unconfirmedMediaCount;
  final int pendingMediaCount;
  final int processingMediaCount;
  final int successMediaCount;
  final int failedMediaCount;

  const PenInventoryMediaSummary({
    required this.totalMediaCount,
    required this.imageMediaCount,
    required this.videoMediaCount,
    required this.confirmedMediaCount,
    required this.unconfirmedMediaCount,
    required this.pendingMediaCount,
    required this.processingMediaCount,
    required this.successMediaCount,
    required this.failedMediaCount,
  });

  factory PenInventoryMediaSummary.fromJSON(dynamic json) {
    final data = _toMap(json);
    return PenInventoryMediaSummary(
      totalMediaCount: _toInt(data["totalMediaCount"]),
      imageMediaCount: _toInt(data["imageMediaCount"]),
      videoMediaCount: _toInt(data["videoMediaCount"]),
      confirmedMediaCount: _toInt(data["confirmedMediaCount"]),
      unconfirmedMediaCount: _toInt(data["unconfirmedMediaCount"]),
      pendingMediaCount: _toInt(data["pendingMediaCount"]),
      processingMediaCount: _toInt(data["processingMediaCount"]),
      successMediaCount: _toInt(data["successMediaCount"]),
      failedMediaCount: _toInt(data["failedMediaCount"]),
    );
  }

  factory PenInventoryMediaSummary.empty() {
    return const PenInventoryMediaSummary(
      totalMediaCount: 0,
      imageMediaCount: 0,
      videoMediaCount: 0,
      confirmedMediaCount: 0,
      unconfirmedMediaCount: 0,
      pendingMediaCount: 0,
      processingMediaCount: 0,
      successMediaCount: 0,
      failedMediaCount: 0,
    );
  }
}

class PenInventoryTrend {
  final String statDate;
  final int sampleSize;
  final double avgCount;
  final int minCount;
  final int maxCount;
  final int finalCount;
  final int deadPigQuantity;

  const PenInventoryTrend({
    required this.statDate,
    required this.sampleSize,
    required this.avgCount,
    required this.minCount,
    required this.maxCount,
    required this.finalCount,
    required this.deadPigQuantity,
  });

  factory PenInventoryTrend.fromJSON(dynamic json) {
    final data = _toMap(json);
    return PenInventoryTrend(
      statDate: _toStringSafe(data["statDate"]),
      sampleSize: _toInt(data["sampleSize"]),
      avgCount: _toDouble(data["avgCount"]),
      minCount: _toInt(data["minCount"]),
      maxCount: _toInt(data["maxCount"]),
      finalCount: _toInt(data["finalCount"]),
      deadPigQuantity: _toInt(data["deadPigQuantity"]),
    );
  }
}

class PenInventoryOverview {
  final int orgId;
  final String orgName;
  final int buildingId;
  final String buildingName;
  final int penId;
  final String penCode;
  final String penName;
  final String focusDate;
  final String trendStartDate;
  final String trendEndDate;
  final PenInventoryStat todayLiveStat;
  final PenInventoryStat todayConfirmedStat;
  final PenInventoryMediaSummary todayMediaSummary;
  final InventoryMediaItem? latestMedia;
  final List<InventoryMediaItem> recentMedia;
  final List<PenInventoryTrend> confirmedTrend;

  const PenInventoryOverview({
    required this.orgId,
    required this.orgName,
    required this.buildingId,
    required this.buildingName,
    required this.penId,
    required this.penCode,
    required this.penName,
    required this.focusDate,
    required this.trendStartDate,
    required this.trendEndDate,
    required this.todayLiveStat,
    required this.todayConfirmedStat,
    required this.todayMediaSummary,
    required this.latestMedia,
    required this.recentMedia,
    required this.confirmedTrend,
  });

  factory PenInventoryOverview.fromJSON(dynamic json) {
    final data = _toMap(json);
    final latestMediaJson = _toMap(data["latestMedia"]);
    return PenInventoryOverview(
      orgId: _toInt(data["orgId"]),
      orgName: _toStringSafe(data["orgName"]),
      buildingId: _toInt(data["buildingId"]),
      buildingName: _toStringSafe(data["buildingName"]),
      penId: _toInt(data["penId"]),
      penCode: _toStringSafe(data["penCode"]),
      penName: _toStringSafe(data["penName"]),
      focusDate: _toStringSafe(data["focusDate"]),
      trendStartDate: _toStringSafe(data["trendStartDate"]),
      trendEndDate: _toStringSafe(data["trendEndDate"]),
      todayLiveStat: PenInventoryStat.fromJSON(data["todayLiveStat"]),
      todayConfirmedStat: PenInventoryStat.fromJSON(data["todayConfirmedStat"]),
      todayMediaSummary: PenInventoryMediaSummary.fromJSON(
        data["todayMediaSummary"],
      ),
      latestMedia: latestMediaJson.isEmpty
          ? null
          : InventoryMediaItem.fromJSON(latestMediaJson),
      recentMedia: _toList(
        data["recentMedia"],
      ).map(InventoryMediaItem.fromJSON).toList(),
      confirmedTrend: _toList(
        data["confirmedTrend"],
      ).map(PenInventoryTrend.fromJSON).toList(),
    );
  }

  factory PenInventoryOverview.empty() {
    return PenInventoryOverview(
      orgId: 0,
      orgName: "",
      buildingId: 0,
      buildingName: "",
      penId: 0,
      penCode: "",
      penName: "",
      focusDate: "",
      trendStartDate: "",
      trendEndDate: "",
      todayLiveStat: PenInventoryStat.empty(),
      todayConfirmedStat: PenInventoryStat.empty(),
      todayMediaSummary: PenInventoryMediaSummary.empty(),
      latestMedia: null,
      recentMedia: const [],
      confirmedTrend: const [],
    );
  }
}
