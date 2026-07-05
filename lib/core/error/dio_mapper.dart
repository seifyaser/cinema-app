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
        return _mapStatusCode(response?.statusCode);

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

Failure _mapStatusCode(int? statusCode) {
  switch (statusCode) {
    case 401:
      return const Failure(
        type: FailureType.unauthorized,
        message: 'Your session has expired. Please log in again.',
      );
    case 403:
      return const Failure(
        type: FailureType.forbidden,
        message: 'You do not have permission to perform this action.',
      );
    case 404:
      return const Failure(
        type: FailureType.notFound,
        message: 'The requested resource was not found.',
      );
    case 409:
      return const Failure(
        type: FailureType.conflict,
        message: 'A conflict occurred. Please review your request.',
      );
    case 422:
      return const Failure(
        type: FailureType.validation,
        message: 'Some fields are invalid. Please review and try again.',
      );
    case 503:
      return const Failure(
        type: FailureType.serverDown,
        message: 'The service is temporarily unavailable. Please try later.',
      );
    default:
      if (statusCode != null && statusCode >= 500) {
        return const Failure(
          type: FailureType.serverError,
          message: 'A server error occurred. Please try again later.',
        );
      }
      return const Failure(
        type: FailureType.unknown,
        message: 'An unexpected error occurred. Please try again.',
      );
  }
}
