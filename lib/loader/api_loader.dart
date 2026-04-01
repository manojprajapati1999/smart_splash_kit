import 'package:flutter/foundation.dart';

/// Result of an API load operation.
class ApiLoadResult<T> {
  /// The loaded data, available when [success] is true.
  final T? data;

  /// Whether the load operation succeeded.
  final bool success;

  /// Error message, available when [success] is false.
  final String? errorMessage;

  /// Whether the failure was due to a timeout.
  final bool timedOut;

  const ApiLoadResult._({
    this.data,
    required this.success,
    this.errorMessage,
    this.timedOut = false,
  });

  /// Creates a successful result carrying [data].
  factory ApiLoadResult.success(T data) =>
      ApiLoadResult._(data: data, success: true);

  /// Creates a failure result with an optional [errorMessage].
  factory ApiLoadResult.failure(String errorMessage) =>
      ApiLoadResult._(success: false, errorMessage: errorMessage);

  /// Creates a timeout result.
  factory ApiLoadResult.timeout() =>
      ApiLoadResult._(success: false, timedOut: true, errorMessage: 'Request timed out');
}

/// Utility class for running API calls during the splash screen.
///
/// Handles timeouts, retries, and internet connectivity checks.
class ApiLoader {
  ApiLoader._();

  /// Runs an [operation] with a [timeout] and up to [maxRetries] attempts.
  ///
  /// Returns an [ApiLoadResult] indicating success or failure.
  ///
  /// Example:
  /// ```dart
  /// final result = await ApiLoader.run(
  ///   () => fetchUserData(),
  ///   timeout: Duration(seconds: 10),
  ///   maxRetries: 2,
  /// );
  /// ```
  static Future<ApiLoadResult<T>> run<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 10),
    int maxRetries = 0,
    Duration retryDelay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (attempt <= maxRetries) {
      try {
        final result = await operation().timeout(timeout);
        return ApiLoadResult.success(result);
      } on Exception catch (e) {
        final isTimeout = e.toString().contains('TimeoutException');
        if (isTimeout) {
          if (kDebugMode) {
            debugPrint('[SmartSplashKit] ApiLoader: timeout on attempt ${attempt + 1}');
          }
          if (attempt == maxRetries) return ApiLoadResult.timeout();
        } else {
          if (kDebugMode) {
            debugPrint('[SmartSplashKit] ApiLoader: error on attempt ${attempt + 1}: $e');
          }
          if (attempt == maxRetries) {
            return ApiLoadResult.failure(e.toString());
          }
        }
        attempt++;
        if (attempt <= maxRetries) {
          await Future.delayed(retryDelay);
        }
      } catch (e) {
        if (attempt == maxRetries) {
          return ApiLoadResult.failure(e.toString());
        }
        attempt++;
        await Future.delayed(retryDelay);
      }
    }
    return ApiLoadResult.failure('Unknown error');
  }

  /// Runs multiple API operations concurrently.
  ///
  /// Returns all results when all operations complete (or fail).
  static Future<List<ApiLoadResult<dynamic>>> runAll(
    List<Future<dynamic> Function()> operations, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    return Future.wait(
      operations.map((op) => run(op, timeout: timeout)),
    );
  }
}
