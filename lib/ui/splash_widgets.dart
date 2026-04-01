import 'package:flutter/material.dart';
import '../theme/splash_theme.dart';

/// A collection of pre-built splash screen UI widgets.
///
/// Use these to compose your splash layout or as standalone helpers.
class SplashWidgets {
  SplashWidgets._();

  /// A centered circular loading indicator.
  static Widget loader({Color? color, double size = 28, double strokeWidth = 2.5}) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        ),
      ),
    );
  }

  /// A dots-style loading indicator (three animated dots).
  static Widget dotsLoader({Color? color}) {
    return _DotsLoader(color: color ?? Colors.white);
  }

  /// A retry button shown when initialization fails.
  static Widget retryButton({
    required VoidCallback onRetry,
    required SplashTheme theme,
    String label = 'Retry',
    IconData icon = Icons.refresh,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.retryButtonColor,
        foregroundColor: theme.retryButtonTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      ),
      onPressed: onRetry,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  /// An error state widget with icon, message, and retry button.
  static Widget errorState({
    required VoidCallback onRetry,
    required SplashTheme theme,
    String message = 'Something went wrong.\nPlease check your connection.',
    String retryLabel = 'Retry',
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: theme.textColor.withAlpha(160)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: theme.textColor.withAlpha(200),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            retryButton(
              onRetry: onRetry,
              theme: theme,
              label: retryLabel,
            ),
          ],
        ),
      ),
    );
  }

  /// A performance metrics badge (debug use only).
  static Widget performanceBadge({required int loadTimeMs, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '⏱ ${loadTimeMs}ms',
        style: TextStyle(
          color: color ?? Colors.greenAccent,
          fontSize: 11,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Internal animated dots loader widget.
class _DotsLoader extends StatefulWidget {
  final Color color;

  const _DotsLoader({required this.color});

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_controller.value + delay) % 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
