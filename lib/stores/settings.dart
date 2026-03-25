import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pig_counter/utils/persistence.dart';

import '../models/settings/cache.dart';
import '../models/settings/upload.dart';
import '../utils/modal.dart';

class SettingsController extends GetxController {
  static const _uploadSettingsPersistenceKey = "upload_settings";
  static const _cacheSettingsPersistenceKey = "cache_settings";

  final upload = Persistence.Load(
    UploadSettings.defaultSettings(),
    _uploadSettingsPersistenceKey,
  ).obs;

  final cache = Persistence.Load(
    CacheSettings.defaultSettings(),
    _cacheSettingsPersistenceKey,
  ).obs;

  void updateUploadSettings(UploadSettings newSettings) {
    upload.value = newSettings;
    Persistence.Save(newSettings, _uploadSettingsPersistenceKey);
  }

  void updateCacheSettings(CacheSettings newSettings) {
    cache.value = newSettings;
    Persistence.Save(newSettings, _cacheSettingsPersistenceKey);
    cache.value.limitCacheSize();
  }

  void editImageQuality(BuildContext? context) {
    if (context == null) {
      return;
    }
    AppModal.show(
      context,
      .input(
        title: "图片上传质量",
        description: "设置图片压缩质量（1-100），数值越高画质越好，文件越大",
        initialValue: upload.value.uploadPenImageQuality.toString(),
        hintText: "请输入 1-100 的整数",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v < 1 || v > 100) return "请输入 1-100 的整数";
          return null;
        },
        onConfirm: (value) {
          updateUploadSettings(
            upload.value.copyWith(uploadPenImageQuality: int.parse(value)),
          );
        },
      ),
    );
  }

  void editMaxCacheSize(BuildContext? context) {
    if (context == null) {
      return;
    }
    AppModal.show(
      context,
      .input(
        title: "最大缓存大小",
        description: "设置本地缓存上限（单位：MB）",
        initialValue: (cache.value.maxCacheSizeBytes / 1024 / 1024).toStringAsFixed(0),
        hintText: "请输入缓存大小（MB）",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v <= 0) return "请输入大于 0 的整数";
          return null;
        },
        onConfirm: (value) {
          final size = int.parse(value);
          updateCacheSettings(
            cache.value.copyWith(maxCacheSizeBytes: size * 1024 * 1024),
          );
        },
      ),
    );
  }
}
