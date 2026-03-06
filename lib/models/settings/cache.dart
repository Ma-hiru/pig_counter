import '../../utils/persistence.dart';

class CacheSettings implements Persistable<CacheSettings> {
  final int maxCacheSizeMB;

  const CacheSettings({required this.maxCacheSizeMB});

  factory CacheSettings.defaultSettings() {
    return const CacheSettings(maxCacheSizeMB: 1024);
  }

  factory CacheSettings.fromJSON(dynamic json) {
    final defaultSettings = CacheSettings.defaultSettings();
    if (json is Map<String, dynamic>) {
      return CacheSettings(
        maxCacheSizeMB:
            json["maxCacheSizeMB"] ?? defaultSettings.maxCacheSizeMB,
      );
    }
    return defaultSettings;
  }

  CacheSettings copyWith({int? maxCacheSizeMB}) {
    return CacheSettings(maxCacheSizeMB: maxCacheSizeMB ?? this.maxCacheSizeMB);
  }

  @override
  Map<String, dynamic> toJSON() {
    return {"maxCacheSizeMB": maxCacheSizeMB};
  }

  @override
  CacheSettings fromJSON(json) => CacheSettings.fromJSON(json);

  static double get currentCacheSizeMB {
    // TODO: 实现获取当前缓存大小的逻辑
    return 0;
  }

  static void removeCache() {
    // TODO: 实现清除缓存的逻辑
  }
}
