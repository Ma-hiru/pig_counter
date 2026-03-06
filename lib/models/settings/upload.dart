import '../../utils/persistence.dart';

class UploadSettings implements Persistable<UploadSettings> {
  final int uploadPenImageQuality;
  final int uploadPenVideoQuality;

  const UploadSettings({
    required this.uploadPenImageQuality,
    required this.uploadPenVideoQuality,
  });

  factory UploadSettings.defaultSettings() {
    return const UploadSettings(
      uploadPenImageQuality: 80,
      uploadPenVideoQuality: 720,
    );
  }

  factory UploadSettings.fromJSON(dynamic json) {
    final defaultSettings = UploadSettings.defaultSettings();
    if (json is Map<String, dynamic>) {
      return UploadSettings(
        uploadPenImageQuality:
            json["uploadPenImageQuality"] ??
            defaultSettings.uploadPenImageQuality,
        uploadPenVideoQuality:
            json["uploadPenVideoQuality"] ??
            defaultSettings.uploadPenVideoQuality,
      );
    }
    return defaultSettings;
  }

  UploadSettings copyWith({
    int? uploadPenImageQuality,
    int? uploadPenVideoQuality,
  }) {
    return UploadSettings(
      uploadPenImageQuality:
          uploadPenImageQuality ?? this.uploadPenImageQuality,
      uploadPenVideoQuality:
          uploadPenVideoQuality ?? this.uploadPenVideoQuality,
    );
  }

  @override
  Map<String, dynamic> toJSON() => {
    "uploadPenImageQuality": uploadPenImageQuality,
    "uploadPenVideoQuality": uploadPenVideoQuality,
  };

  @override
  UploadSettings fromJSON(json) => UploadSettings.fromJSON(json);
}
