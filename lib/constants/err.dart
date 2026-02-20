class ErrConstants {
  static const FormatException responseFormatError = FormatException(
    "Invalid Response Json format",
  );
}

class ErrMsgConstants {
  static const String responseFormatError = "服务器返回数据格式错误";
  static const String networkError = "网络错误";
}