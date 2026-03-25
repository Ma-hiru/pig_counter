import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pig_counter/utils/cache.dart';
import 'package:pig_counter/utils/toast.dart';

import '../../utils/modal.dart';
import '../../utils/persistence.dart';

class CacheSettings implements Persistable<CacheSettings> {
  final int maxCacheSizeBytes;

  const CacheSettings({required this.maxCacheSizeBytes});

  CacheSettings copyWith({int? maxCacheSizeBytes}) {
    return CacheSettings(
      maxCacheSizeBytes: maxCacheSizeBytes ?? this.maxCacheSizeBytes,
    );
  }

  Future<int> limitCacheSize() {
    final removedSize = TaskCache.limitSize(maxCacheSizeBytes);
    if (kDebugMode) {
      print(
        "Cache size limit exceeded. Removed $removedSize bytes from cache.",
      );
    }
    return removedSize;
  }

  factory CacheSettings.defaultSettings() {
    return const CacheSettings(maxCacheSizeBytes: 1024 * 1024 * 1024);
  }

  factory CacheSettings.fromJSON(dynamic json) {
    final defaultSettings = CacheSettings.defaultSettings();
    if (json is Map<String, dynamic>) {
      return CacheSettings(
        maxCacheSizeBytes:
            json["maxCacheSizeBytes"] ?? defaultSettings.maxCacheSizeBytes,
      );
    }
    return defaultSettings;
  }

  @override
  Map<String, dynamic> toJSON() {
    return {"maxCacheSizeBytes": maxCacheSizeBytes};
  }

  @override
  CacheSettings fromJSON(json) => CacheSettings.fromJSON(json);

  static Future<int> get currentCacheSizeBytes async {
    return TaskCache.totalSize();
  }

  static void removeCache(BuildContext? context, VoidCallback? cb) {
    if (context == null) {
      TaskCache.clear();
      return;
    }

    AppModal.show(
      context,
      .normal(
        title: "清除缓存",
        centerTitle: true,
        description: "确定要清除所有本地缓存数据吗？此操作不可撤销。",
        confirmText: "清除",
        cancelText: "取消",
        onConfirm: () async {
          await TaskCache.clear();
          cb?.call();
          Toast.showToast(.success("缓存已清除"));
        },
      ),
    );
  }
}
