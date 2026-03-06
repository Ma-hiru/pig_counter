import 'package:get/get.dart';
import 'package:pig_counter/utils/persistence.dart';

import '../models/settings/cache.dart';
import '../models/settings/upload.dart';

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
  }
}
