import 'package:flutter/cupertino.dart';
 
import '../../models/settings/cache.dart';
import '../../stores/settings.dart';
import '../../utils/modal.dart';

class SettingsActions {
  BuildContext context;
  SettingsController settingsController;

  SettingsActions({required this.context, required this.settingsController});

  void editImageQuality() {
    AppModal.show(
      context,
      .input(
        title: "图片上传质量",
        description: "设置图片压缩质量（1-100），数值越高画质越好，文件越大",
        initialValue: settingsController.upload.value.uploadPenImageQuality
            .toString(),
        hintText: "请输入 1-100 的整数",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v < 1 || v > 100) return "请输入 1-100 的整数";
          return null;
        },
        onConfirm: (value) {
          settingsController.updateUploadSettings(
            settingsController.upload.value.copyWith(
              uploadPenImageQuality: int.parse(value),
            ),
          );
        },
      ),
    );
  }

  void editVideoQuality() {
    AppModal.show(
      context,
      .input(
        title: "视频上传分辨率",
        description: "设置视频上传分辨率（如 480、720、1080）",
        initialValue: settingsController.upload.value.uploadPenVideoQuality
            .toString(),
        hintText: "请输入分辨率数值",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v <= 0) return "请输入有效的分辨率数值";
          return null;
        },
        onConfirm: (value) {
          final quality = int.parse(value);
          settingsController.updateUploadSettings(
            settingsController.upload.value.copyWith(
              uploadPenVideoQuality: quality,
            ),
          );
        },
      ),
    );
  }

  void editMaxCacheSize() {
    AppModal.show(
      context,
      .input(
        title: "最大缓存大小",
        description: "设置本地缓存上限（单位：MB）",
        initialValue: settingsController.cache.value.maxCacheSizeMB.toString(),
        hintText: "请输入缓存大小（MB）",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v <= 0) return "请输入大于 0 的整数";
          return null;
        },
        onConfirm: (value) {
          final size = int.parse(value);
          settingsController.updateCacheSettings(
            settingsController.cache.value.copyWith(maxCacheSizeMB: size),
          );
        },
      ),
    );
  }

  void clearCache() {
    AppModal.show(
      context,
      .normal(
        title: "清除缓存",
        centerTitle: true,
        description: "确定要清除所有本地缓存数据吗？此操作不可撤销。",
        confirmText: "清除",
        cancelText: "取消",
        onConfirm: () => CacheSettings.removeCache(),
      ),
    );
  }
}
