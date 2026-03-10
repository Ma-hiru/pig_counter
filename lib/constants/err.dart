class ErrConstants {
  static const FormatException responseFormatError = FormatException(
    "Invalid Response Json format",
  );
  static const FormatException typeConvertError = FormatException(
    "Type convert error",
  );
  static const FormatException localStoreNotInit = FormatException(
    "LocalStore no init",
  );
}

class ErrMsgConstants {
  static const String responseFormatError = "服务器返回数据格式错误";
  static const String networkError = "网络错误";
  static const String unknownError = "未知错误";
  static const String localStoreNotInit = "本地存储未初始化";
  static const String typeConvertError = "数据类型转换错误";
  static const String selectImageFailed = "选择图片失败";
  static const String takeImageFailed = "拍摄图片失败";
  static const String selectVideoFailed = "选择视频失败";
  static const String takeVideoFailed = "录制视频失败";
}
