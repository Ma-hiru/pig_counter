import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../models/settings/cache.dart';
import '../../models/ui/dialog.dart';
import '../../models/ui/modal.dart';
import '../../stores/settings.dart';
import '../../utils/dialog.dart';
import '../../utils/modal.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/settings/settings_menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _settingsController = Get.find<SettingsController>();

  void _editImageQuality() {
    AppModal.show(
      context,
      ModalData(
        title: "图片上传质量",
        description: "设置图片压缩质量（1-100），数值越高画质越好，文件越大",
        initialValue: _settingsController.upload.value.uploadPenImageQuality
            .toString(),
        hintText: "请输入 1-100 的整数",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v < 1 || v > 100) return "请输入 1-100 的整数";
          return null;
        },
        onConfirm: (value) {
          final quality = int.parse(value);
          _settingsController.updateUploadSettings(
            _settingsController.upload.value.copyWith(
              uploadPenImageQuality: quality,
            ),
          );
        },
      ),
    );
  }

  void _editVideoQuality() {
    AppModal.show(
      context,
      ModalData(
        title: "视频上传分辨率",
        description: "设置视频上传分辨率（如 480、720、1080）",
        initialValue: _settingsController.upload.value.uploadPenVideoQuality
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
          _settingsController.updateUploadSettings(
            _settingsController.upload.value.copyWith(
              uploadPenVideoQuality: quality,
            ),
          );
        },
      ),
    );
  }

  void _editMaxCacheSize() {
    AppModal.show(
      context,
      ModalData(
        title: "最大缓存大小",
        description: "设置本地缓存上限（单位：MB）",
        initialValue: _settingsController.cache.value.maxCacheSizeMB.toString(),
        hintText: "请输入缓存大小（MB）",
        keyboardType: TextInputType.number,
        validator: (value) {
          final v = int.tryParse(value ?? "");
          if (v == null || v <= 0) return "请输入大于 0 的整数";
          return null;
        },
        onConfirm: (value) {
          final size = int.parse(value);
          _settingsController.updateCacheSettings(
            _settingsController.cache.value.copyWith(maxCacheSizeMB: size),
          );
        },
      ),
    );
  }

  void _clearCache() {
    AppDialog.show(
      context,
      DialogData.error(
        title: "清除缓存",
        description: "确定要清除所有本地缓存数据吗？此操作不可撤销。",
        confirmText: "清除",
        cancelText: "取消",
        onConfirm: () {
          CacheSettings.removeCache();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "设置"),
      body: Container(
        width: double.infinity,
        color: ColorConstants.backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.gapSize.xl,
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsMenuSection(
                  title: "上传设置",
                  items: [
                    SettingsMenuItem(
                      label: "图片上传质量",
                      subtitle: "图片压缩质量百分比",
                      value:
                          "${_settingsController.upload.value.uploadPenImageQuality}%",
                      onTap: _editImageQuality,
                    ),
                    SettingsMenuItem(
                      label: "视频上传分辨率",
                      subtitle: "视频上传时的分辨率",
                      value:
                          "${_settingsController.upload.value.uploadPenVideoQuality}p",
                      onTap: _editVideoQuality,
                    ),
                  ],
                ),
                SizedBox(height: UIConstants.gapSize.xl),
                SettingsMenuSection(
                  title: "缓存设置",
                  items: [
                    SettingsMenuItem(
                      label: "最大缓存大小",
                      subtitle: "本地缓存占用上限",
                      value:
                          "${_settingsController.cache.value.maxCacheSizeMB} MB",
                      onTap: _editMaxCacheSize,
                    ),
                    SettingsMenuItem(
                      label: "清除缓存",
                      subtitle: "清除所有本地缓存数据",
                      destructive: true,
                      onTap: _clearCache,
                    ),
                  ],
                ),
                SizedBox(height: UIConstants.gapSize.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
