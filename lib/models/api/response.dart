import 'package:flutter/foundation.dart';
import 'package:pig_counter/constants/err.dart';

class ResponseData<T extends dynamic> {
  final bool ok;
  final int code;
  final String message;
  final T data;

  const ResponseData({
    required this.ok,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseData.empty() {
    return ResponseData(
      ok: false,
      code: -1,
      message: "No data",
      data: null as T,
    );
  }

  factory ResponseData.fromJson(dynamic json) {
    try {
      final jsonData = json as Map<String, dynamic>;
      return ResponseData(
        ok: jsonData['ok'] ?? false,
        code: jsonData['code'] ?? -1,
        message: jsonData['message'] ?? "",
        data: jsonData['data'],
      );
    } catch (err) {
      if (kDebugMode) print("response format error: $err");
      throw ErrConstants.responseFormatError;
    }
  }

  factory ResponseData.success(T data) {
    return ResponseData<T>(
      ok: true,
      code: 200,
      message: "test success",
      data: data,
    );
  }

  factory ResponseData.error(T data) {
    return ResponseData<T>(
      ok: false,
      code: 201,
      message: "test error",
      data: data,
    );
  }

  Map<String, String> get fieldErrors {
    final raw = data;
    if (raw is! Map) return const {};
    final entries = raw.entries
        .where((entry) => entry.key != null && entry.value != null)
        .map((entry) => MapEntry(entry.key.toString(), entry.value.toString()));
    return Map<String, String>.fromEntries(entries);
  }

  String get displayMessage {
    final text = message.trim();
    return text.isNotEmpty ? text : "操作失败";
  }

  static ResponseData<T> fromJsonWithType<T>({
    required dynamic json,
    required T Function(dynamic data) handleData,
  }) {
    final jsonData = ResponseData.fromJson(json);
    try {
      return ResponseData<T>(
        ok: jsonData.ok,
        code: jsonData.code,
        message: jsonData.message,
        data: handleData(jsonData.data),
      );
    } catch (err) {
      if (kDebugMode) print("response format error: $err");
      throw ErrConstants.responseFormatError;
    }
  }

  static String? getMessageFromJson(dynamic json) {
    try {
      final jsonData = json as Map<String, dynamic>;
      return jsonData['message'];
    } catch (err) {
      if (kDebugMode) print("response format error: $err");
    }
    return null;
  }
}
