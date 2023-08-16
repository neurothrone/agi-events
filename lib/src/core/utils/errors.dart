import 'enums/enums.dart';

class RealtimeException implements Exception {
  RealtimeException({
    required this.error,
    this.message,
  });

  final RealtimeError error;
  final String? message;

  @override
  String toString() {
    return message ?? error.toString();
  }
}
