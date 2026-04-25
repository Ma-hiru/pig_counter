import 'package:dio/dio.dart';
import 'package:pig_counter/constants/api.dart';
import 'package:pig_counter/constants/http.dart';
import 'package:pig_counter/models/api/response.dart';
import 'package:pig_counter/models/api/user.dart';
import 'package:pig_counter/utils/session_manager.dart';

import '../stores/token.dart';

class _Request {
  final _dio = Dio();
  Future<bool>? _refreshing;

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
          final shouldSkipAuth = request.extra["skipAuth"] == true;
          final token = TokenManager.getToken();
          if (!shouldSkipAuth && token is String) {
            request.headers["Authorization"] = token;
          }
          handler.next(request);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          final requestOptions = error.requestOptions;
          final response = error.response;
          final responseData = response?.data;
          final skipRefresh = requestOptions.extra["skipRefresh"] == true;
          final alreadyRetried = requestOptions.extra["retried"] == true;
          final unauthorized =
              response?.statusCode == 401 ||
              _isApiCodeUnauthorized(responseData);

          if (unauthorized &&
              !_shouldSkipRefresh(requestOptions) &&
              !skipRefresh &&
              !alreadyRetried) {
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              requestOptions.extra["retried"] = true;
              requestOptions.headers["Authorization"] = TokenManager.getToken();
              try {
                final retried = await _dio.fetch<dynamic>(requestOptions);
                handler.resolve(retried);
                return;
              } catch (retryError) {
                if (retryError is DioException) {
                  handler.reject(_toMessageException(retryError));
                  return;
                }
              }
            } else {
              await SessionManager.handleUnauthorized();
            }
          }

          if (unauthorized && !_isLoginRequest(requestOptions)) {
            await SessionManager.handleUnauthorized();
          }
          handler.reject(_toMessageException(error));
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
      final result = ResponseData.fromJsonWithType<T>(
        json: response.data,
        handleData: handleData,
      );
      if (result.code == 401 &&
          !_shouldSkipRefresh(response.requestOptions) &&
          response.requestOptions.extra["retried"] != true) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          final retried = await _retryRequest<T>(
            response.requestOptions,
            handleData,
          );
          if (retried != null) {
            return retried;
          }
        }
        await SessionManager.handleUnauthorized();
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  bool _isLoginRequest(RequestOptions requestOptions) {
    return requestOptions.path.contains(APIConstants.user.login);
  }

  bool _isRefreshRequest(RequestOptions requestOptions) {
    return requestOptions.path.contains(APIConstants.user.refresh);
  }

  bool _shouldSkipRefresh(RequestOptions requestOptions) {
    return _isLoginRequest(requestOptions) || _isRefreshRequest(requestOptions);
  }

  bool _isApiCodeUnauthorized(dynamic data) {
    return data is Map<String, dynamic> && data["code"] == 401;
  }

  DioException _toMessageException(DioException error) {
    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      message: error.response?.data is Map<String, dynamic>
          ? ResponseData.getMessageFromJson(error.response!.data) ?? "请求失败"
          : error.message,
      error: error.error,
    );
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshing != null) {
      return _refreshing!;
    }

    final refreshToken = TokenManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    _refreshing = () async {
      try {
        final response = await _dio.post(
          _normalizePath(APIConstants.user.refresh),
          data: {"refreshToken": refreshToken},
          options: Options(extra: {"skipAuth": true, "skipRefresh": true}),
        );
        final result = ResponseData.fromJsonWithType<UserAuthSession>(
          json: response.data,
          handleData: UserAuthSession.fromJSON,
        );
        if (!result.ok) {
          return false;
        }
        await TokenManager.setTokens(
          accessToken: result.data.accessToken,
          refreshToken: result.data.refreshToken,
          tokenType: result.data.tokenType,
        );
        await SessionManager.onTokensRefreshed?.call(result.data);
        return true;
      } catch (_) {
        return false;
      } finally {
        _refreshing = null;
      }
    }();

    return _refreshing!;
  }

  Future<ResponseData<T>?> _retryRequest<T>(
    RequestOptions requestOptions,
    T Function(dynamic data) handleData,
  ) async {
    requestOptions.extra["retried"] = true;
    requestOptions.headers["Authorization"] = TokenManager.getToken();
    try {
      final response = await _dio.fetch<dynamic>(requestOptions);
      return ResponseData.fromJsonWithType<T>(
        json: response.data,
        handleData: handleData,
      );
    } catch (_) {
      return null;
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
