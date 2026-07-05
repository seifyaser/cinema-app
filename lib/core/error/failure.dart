import 'package:project/core/error/failure_type.dart';

class Failure {
  const Failure({
    required this.type,
    required this.message,
  });

  final FailureType type;
  final String message;

  @override
  String toString() => 'Failure(type: $type, message: $message)';
}
