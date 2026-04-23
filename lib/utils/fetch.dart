import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/models/api/response.dart';

import '../stores/token.dart';

class _Request {
  final _dio = Dio();

  _Request() {
    addInterceptors(setOptions(_dio));
  }

  Dio setOptions(Dio dio) {
    dio.options
      ..baseUrl = HTTPConstants.baseUrl
      ..connectTimeout = HTTPConstants.timeout
      ..sendTimeout = HTTPConstants.timeout;
    return dio;
  }

  Dio addInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          final token = TokenManager.getToken();
          if (token is String) request.headers["Authorization"] = token;
          handler.next(request);
        },
        onResponse: (response, handler) {
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            handler.next(response);
          } else {
            if (response.statusCode == 401) {
              TokenManager.removeToken();
              // TODO: 重新登录
            }
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                message: response.data is Map<String, dynamic>
                    ? ResponseData.getMessageFromJson(response.data) ?? "请求失败"
                    : "请求失败",
              ),
            );
          }
        },
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              message: error.response?.data is Map<String, dynamic>
                  ? ResponseData.getMessageFromJson(error.response!.data) ??
                        "请求失败"
                  : error.message,
            ),
          );
        },
      ),
    );
    return dio;
  }

  String _normalizePath(String path) {
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path;
    }
    if (path.startsWith(APIBaseConstants.prefix)) {
      return path;
    }
    return "${APIBaseConstants.prefix}$path";
  }

  Future<ResponseData<T>> _handleResponse<T>(
    Future<Response<dynamic>> task,
    T Function(dynamic data) handleData,
  ) async {
    try {
      final response = await task;
      return ResponseData.fromJsonWithType<T>(
        json: response.data,
        handleData: handleData,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<ResponseData<T>> get<T>(
    String path,
    T Function(dynamic data)? handleData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    handleData ??= (v) => v;
    return _handleResponse<T>(
      _dio.get(
        _normalizePath(path),
        queryParameters: queryParameters,
        options: options,
      ),
      handleData,
    );
  }

  Future<ResponseData<T>> post<T>(
    String path,
    T Function(dynamic data)? handleData, {
    Object? data,
    Options? options,
  }) {
    handleData ??= (v) => v;
    return _handleResponse<T>(
      _dio.post(_normalizePath(path), data: data, options: options),
      handleData,
    );
  }

  Future<ResponseData<T>> put<T>(
    String path,
    T Function(dynamic data)? handleData, {
    Object? data,
    Options? options,
  }) {
    handleData ??= (v) => v;
    return _handleResponse<T>(
      _dio.put(_normalizePath(path), data: data, options: options),
      handleData,
    );
  }

  Future<ResponseData<T>> delete<T>(
    String path,
    T Function(dynamic data)? handleData, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    handleData ??= (v) => v;
    return _handleResponse<T>(
      _dio.delete(
        _normalizePath(path),
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      handleData,
    );
  }
}

final fetch = _Request();
