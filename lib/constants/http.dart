class HTTPConstants {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "https://api.example.com",
  );
  static const Duration timeout = Duration(seconds: 15);
  static const String tokenPrefix = "Bearer ";
}
