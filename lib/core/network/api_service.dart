import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project/core/storage/token_storage.dart';

/// Central Dio client with interceptors and the 4 HTTP methods.
///
/// Register this as a singleton via get_it:
/// ```dart
/// sl.registerLazySingleton<ApiService>(() => ApiService(sl()));
/// ```
class ApiService {
  ApiService(this._tokenStorage) {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          ..interceptors.addAll([
            _AuthInterceptor(_tokenStorage),
            _LoggingInterceptor(),
            _ErrorInterceptor(),
          ]);
  }

  late final Dio _dio;
  final TokenStorage _tokenStorage;

  static const String baseUrl =
      'https://relay-experts-cartoons-process.trycloudflare.com/api/v1/';

  // ---------------------------------------------------------------------------
  // Public HTTP methods
  // ---------------------------------------------------------------------------

  /// Performs a GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Performs a POST request.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Performs a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Performs a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Exposes the underlying [Dio] instance for advanced use (e.g. file upload).
  Dio get dio => _dio;
}

// ---------------------------------------------------------------------------
// Interceptors
// ---------------------------------------------------------------------------

/// Attaches the auth token to every outgoing request.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    // debugPrint('Saved Token: $token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Logs requests and responses in debug mode only.
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[API] → ${options.method} ${options.uri}');
      debugPrint('[API] Token: ${options.headers['Authorization']}');
      if (options.data != null) {
        debugPrint('[API] Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] ← ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[API] ✕ ${err.response?.statusCode} ${err.requestOptions.uri}\n'
        '  ${err.message}',
      );
      debugPrint(err.response?.data.toString());
    }
    handler.next(err);
  }
}

/// Handles global error concerns (e.g. token refresh on 401).
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: Handle 401 → attempt token refresh, then retry.
    // if (err.response?.statusCode == 401) {
    //   _handleTokenRefresh(err, handler);
    //   return;
    // }
    handler.next(err);
  }
}
