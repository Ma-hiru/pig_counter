class HTTPConstants {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://8.148.152.24",
  );
  static const Duration timeout = Duration(seconds: 15);
  static const String tokenPrefix = "";
}
