import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/pages/settings/settings_actions.dart';
import 'package:pig_counter/widgets/settings/settings_menu_section_item.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../stores/settings.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/settings/settings_menu_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  late final SettingsActions _settingsActions;

  @override
  initState(){
    super.initState();
    _settingsActions = SettingsActions(
      context: context,
      settingsController: _settingsController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigatorAppbar(title: "设置"),
      body: Container(
        width: .infinity,
        height: .infinity,
        color: ColorConstants.backgroundColor,
        child: SingleChildScrollView(
          padding: const .symmetric(
            horizontal: UIConstants.contentPaddingFromSides,
            vertical: UIConstants.contentPaddingFromSides,
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: .start,
              children: [
                SettingsMenuSection(
                  title: "上传设置",
                  items: [
                    SettingsMenuSectionItem(
                      label: "图片上传质量",
                      subtitle: "图片压缩质量百分比",
                      value:
                          "${_settingsController.upload.value.uploadPenImageQuality}%",
                      onTap: _settingsActions.editImageQuality,
                    ),
                    SettingsMenuSectionItem(
                      label: "视频上传分辨率",
                      subtitle: "视频上传时的分辨率",
                      value:
                          "${_settingsController.upload.value.uploadPenVideoQuality}p",
                      onTap: _settingsActions.editVideoQuality,
                    ),
                  ],
                ),
                SizedBox(height: UIConstants.gapSize.xl),
                SettingsMenuSection(
                  title: "缓存设置",
                  items: [
                    SettingsMenuSectionItem(
                      label: "最大缓存大小",
                      subtitle: "本地缓存占用上限",
                      value:
                          "${_settingsController.cache.value.maxCacheSizeMB} MB",
                      onTap: _settingsActions.editMaxCacheSize,
                    ),
                    SettingsMenuSectionItem(
                      label: "清除缓存",
                      subtitle: "清除所有本地缓存数据",
                      flat: true,
                      onTap: _settingsActions.clearCache,
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
