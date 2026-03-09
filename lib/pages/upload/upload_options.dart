import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pig_counter/stores/settings.dart';

import '../../constants/err.dart';
import '../../utils/toast.dart';

class UploadOptions {
  final ImagePicker picker = ImagePicker();
  final SettingsController settingsController;

  UploadOptions({required this.settingsController});

  Future<String?> selectImage() async {
    try {
      final XFile? picked = await picker.pickImage(
        source: .gallery,
        imageQuality: settingsController.upload.value.uploadPenImageQuality,
      );
      if (picked != null) return picked.path;
    } catch (err) {
      if (kDebugMode) print("Failed to pick image: $err");
      Toast.showToast(.error(ErrMsgConstants.selectImageFailed));
    }
    return null;
  }

  Future<String?> selectVideo() async {
    try {
      final XFile? picked = await picker.pickVideo(
        source: .gallery,
        preferredCameraDevice: .rear,
        maxDuration: const Duration(minutes: 1),
      );
      if (picked != null) return picked.path;
    } catch (err) {
      if (kDebugMode) print("Failed to pick video: $err");
      Toast.showToast(.error(ErrMsgConstants.selectVideoFailed));
    }
    return null;
  }
}
