import 'package:dio/dio.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';

/// Maps a [DioException] into a typed [Failure].
///
/// Usage in a repository:
/// ```dart
/// try {
///   ...
/// } on DioException catch (e) {
///   throw e.toFailure();
/// }
/// ```
extension DioExceptionMapper on DioException {
  Failure toFailure() {
    switch (type) {
      case DioExceptionType.connectionError:
        return const Failure(
          type: FailureType.noInternet,
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure(
          type: FailureType.timeout,
          message: 'The request timed out. Please try again.',
        );

      case DioExceptionType.cancel:
        return const Failure(
          type: FailureType.cancelled,
          message: 'The request was cancelled.',
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(response?.statusCode, response?.data);

      case DioExceptionType.badCertificate:
        return const Failure(
          type: FailureType.unknown,
          message: 'A certificate error occurred. Please contact support.',
        );

      case DioExceptionType.unknown:
      default:
        return const Failure(
          type: FailureType.unknown,
          message: 'An unexpected error occurred. Please try again.',
        );
    }
  }
}

Failure _mapStatusCode(int? statusCode, [dynamic responseData]) {
  // Try to extract the backend's own message first — it's already user-friendly.
  final backendMessage = responseData is Map<String, dynamic>
      ? ((responseData['errors'] is List &&
                    (responseData['errors'] as List).isNotEmpty)
                ? ((responseData['errors'] as List).first
                          as Map<String, dynamic>)['message']
                      as String?
                : null) ??
            responseData['message'] as String?
      : null;

  switch (statusCode) {
    case 401:
      return Failure(
        type: FailureType.unauthorized,
        message:
            backendMessage ?? 'Your session has expired. Please log in again.',
      );
    case 403:
      return Failure(
        type: FailureType.forbidden,
        message:
            backendMessage ??
            'You do not have permission to perform this action.',
      );
    case 404:
      return Failure(
        type: FailureType.notFound,
        message: backendMessage ?? 'The requested resource was not found.',
      );
    case 409:
      return Failure(
        type: FailureType.conflict,
        message:
            backendMessage ??
            'A conflict occurred. Please review your request.',
      );
    case 422:
      return Failure(
        type: FailureType.validation,
        message:
            backendMessage ??
            'Some fields are invalid. Please review and try again.',
      );
    case 503:
      return Failure(
        type: FailureType.serverDown,
        message:
            backendMessage ??
            'The service is temporarily unavailable. Please try later.',
      );
    default:
      if (statusCode != null && statusCode >= 500) {
        return Failure(
          type: FailureType.serverError,
          message:
              backendMessage ??
              'A server error occurred. Please try again later.',
        );
      }
      return Failure(
        type: FailureType.unknown,
        message:
            backendMessage ?? 'An unexpected error occurred. Please try again.',
      );
  }
}
