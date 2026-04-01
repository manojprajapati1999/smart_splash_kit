import 'package:flutter/material.dart';

/// Defines the visual theme for the splash screen.
///
/// Supports light mode, dark mode, and auto-detection from the system theme.
class SplashTheme {
  /// Background color of the splash screen.
  final Color backgroundColor;

  /// Color of the loading indicator.
  final Color loaderColor;

  /// Color for primary text elements (app name, tagline).
  final Color textColor;

  /// Color for the retry button.
  final Color retryButtonColor;

  /// Color for the retry button text/icon.
  final Color retryButtonTextColor;

  /// Creates a [SplashTheme] with explicit color values.
  const SplashTheme({
    required this.backgroundColor,
    required this.loaderColor,
    required this.textColor,
    required this.retryButtonColor,
    required this.retryButtonTextColor,
  });

  /// A light theme preset (white background, dark text).
  factory SplashTheme.light() => const SplashTheme(
        backgroundColor: Color(0xFFFFFFFF),
        loaderColor: Color(0xFF6200EE),
        textColor: Color(0xFF212121),
        retryButtonColor: Color(0xFF6200EE),
        retryButtonTextColor: Color(0xFFFFFFFF),
      );

  /// A dark theme preset (dark background, light text).
  factory SplashTheme.dark() => const SplashTheme(
        backgroundColor: Color(0xFF121212),
        loaderColor: Color(0xFFBB86FC),
        textColor: Color(0xFFE1E1E1),
        retryButtonColor: Color(0xFFBB86FC),
        retryButtonTextColor: Color(0xFF121212),
      );

  /// Returns light or dark theme based on the device's current brightness.
  factory SplashTheme.auto(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark
        ? SplashTheme.dark()
        : SplashTheme.light();
  }

  /// Creates a custom theme with your own color palette.
  factory SplashTheme.custom({
    required Color backgroundColor,
    required Color loaderColor,
    required Color textColor,
    Color? retryButtonColor,
    Color? retryButtonTextColor,
  }) =>
      SplashTheme(
        backgroundColor: backgroundColor,
        loaderColor: loaderColor,
        textColor: textColor,
        retryButtonColor: retryButtonColor ?? loaderColor,
        retryButtonTextColor: retryButtonTextColor ?? backgroundColor,
      );

  /// Returns a copy of this theme with specified fields replaced.
  SplashTheme copyWith({
    Color? backgroundColor,
    Color? loaderColor,
    Color? textColor,
    Color? retryButtonColor,
    Color? retryButtonTextColor,
  }) =>
      SplashTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        loaderColor: loaderColor ?? this.loaderColor,
        textColor: textColor ?? this.textColor,
        retryButtonColor: retryButtonColor ?? this.retryButtonColor,
        retryButtonTextColor:
            retryButtonTextColor ?? this.retryButtonTextColor,
      );
}
