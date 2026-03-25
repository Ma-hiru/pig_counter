import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pig_counter/stores/user.dart';
import 'package:pig_counter/widgets/settings/settings_menu_section_item.dart';

import '../../constants/color.dart';
import '../../constants/ui.dart';
import '../../models/settings/cache.dart';
import '../../stores/settings.dart';
import '../../widgets/header/navigator_app_bar.dart';
import '../../widgets/settings/settings_menu_section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settingsController = Get.find<SettingsController>();
  final _userController = Get.find<UserController>();
  double _totalCacheSizeMB = 0;

  void updateCacheSize() {
    CacheSettings.currentCacheSizeBytes.then((size) {
      setState(() {
        _totalCacheSizeMB = size / 1024 / 1024;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateCacheSize();
  }

  List<Widget> buildItems() {
    return [
      SettingsMenuSection(
        title: "上传设置",
        items: [
          SettingsMenuSectionItem(
            label: "图片上传质量",
            subtitle: "图片压缩质量百分比",
            value: "${_settingsController.upload.value.uploadPenImageQuality}%",
            onTap: () => _settingsController.editImageQuality(context),
          ),
        ],
      ),
      SizedBox(height: UIConstants.gapSize.xl),
      SettingsMenuSection(
        title: "缓存设置",
        items: [
          SettingsMenuSectionItem(
            label: "最大缓存大小",
            subtitle: "当前大小　${_totalCacheSizeMB.toStringAsFixed(2)}MB",
            value:
                "${(_settingsController.cache.value.maxCacheSizeBytes / 1024 / 1024).toStringAsFixed(0)} MB",
            onTap: () {
              _settingsController.editMaxCacheSize(context);
            },
          ),
          SettingsMenuSectionItem(
            label: "清除缓存",
            subtitle: "清除所有本地缓存数据",
            flat: true,
            onTap: () {
              CacheSettings.removeCache(context, updateCacheSize);
            },
          ),
        ],
      ),
      SizedBox(height: UIConstants.gapSize.xxxl),
      if (_userController.isLoggedIn.value)
        SettingsMenuSection(
          title: "登录设置",
          items: [
            SettingsMenuSectionItem(
              label: "退出登录",
              subtitle: "退出当前账号，清除所有登录信息",
              flat: true,
              onTap: () => _userController.logout(context),
            ),
          ],
        ),
    ];
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
            () => Column(crossAxisAlignment: .start, children: buildItems()),
          ),
        ),
      ),
    );
  }
}
