import 'package:flutter/foundation.dart';
import 'splash_router.dart';

/// Describes the current lifecycle state of the splash screen.
enum SplashState {
  /// The splash is initializing (running [onInit]).
  initializing,

  /// The splash is animating.
  animating,

  /// The [onInit] callback has completed successfully.
  completed,

  /// An error occurred during initialization.
  error,
}

/// Controls the lifecycle of the Smart Splash Kit.
///
/// Manages the [onInit] async callback, state transitions,
/// performance timing, and error fallback routing.
class SplashController extends ChangeNotifier {
  /// The async callback that returns the target [SplashRoute].
  final Future<SplashRoute> Function() onInit;

  /// Minimum display duration of the splash screen in milliseconds.
  final int minimumDuration;

  /// The route to navigate to if [onInit] throws an error.
  final SplashRoute? errorFallbackRoute;

  /// Whether to collect performance metrics (debug mode only).
  final bool enablePerformanceMonitoring;

  SplashState _state = SplashState.initializing;
  SplashRoute? _resolvedRoute;
  Object? _error;
  int? _loadTimeMs;

  /// Creates a [SplashController].
  SplashController({
    required this.onInit,
    this.minimumDuration = 2000,
    this.errorFallbackRoute,
    this.enablePerformanceMonitoring = false,
  });

  /// The current lifecycle state of the splash.
  SplashState get state => _state;

  /// The resolved [SplashRoute], available after [state] is [SplashState.completed].
  SplashRoute? get resolvedRoute => _resolvedRoute;

  /// The error object, available when [state] is [SplashState.error].
  Object? get error => _error;

  /// App load time in milliseconds (only available when [enablePerformanceMonitoring] is true).
  int? get loadTimeMs => _loadTimeMs;

  /// Starts the splash initialization process.
  ///
  /// Runs [onInit] and the minimum duration timer concurrently,
  /// then transitions to [SplashState.completed] or [SplashState.error].
  Future<void> initialize() async {
    _setState(SplashState.initializing);
    final stopwatch = enablePerformanceMonitoring ? (Stopwatch()..start()) : null;

    try {
      final results = await Future.wait([
        onInit(),
        Future<void>.delayed(Duration(milliseconds: minimumDuration)),
      ]);

      stopwatch?.stop();
      _loadTimeMs = stopwatch?.elapsedMilliseconds;

      if (enablePerformanceMonitoring && kDebugMode) {
        debugPrint(
          '[SmartSplashKit] App initialized in ${_loadTimeMs}ms',
        );
      }

      _resolvedRoute = results[0] as SplashRoute;
      _setState(SplashState.completed);
    } catch (e) {
      stopwatch?.stop();
      _error = e;
      if (kDebugMode) {
        debugPrint('[SmartSplashKit] Initialization error: $e');
      }
      if (errorFallbackRoute != null) {
        _resolvedRoute = errorFallbackRoute;
        _setState(SplashState.completed);
      } else {
        _setState(SplashState.error);
      }
    }
  }

  /// Retries initialization after an error.
  Future<void> retry() => initialize();

  void _setState(SplashState state) {
    _state = state;
    notifyListeners();
  }
}
