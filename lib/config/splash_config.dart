import 'package:flutter/material.dart';
import '../animation/splash_animation.dart';
import '../theme/splash_theme.dart';

/// Defines the splash UI layout type.
enum SplashLayoutType {
  /// Centered logo only.
  logoCenter,

  /// Logo with text below.
  logoWithText,

  /// Custom widget layout.
  custom,

  /// Full-screen background image.
  fullBackground,
}

/// Configuration model for the splash screen.
///
/// Passed to [SmartSplash] to control every aspect of the splash experience.
class SplashConfig {
  /// Total duration the splash is visible, in milliseconds.
  final int durationMs;

  /// The animation to apply to the splash content.
  final SplashAnimation animation;

  /// Solid background color. Ignored if [backgroundGradient] is set.
  final Color? backgroundColor;

  /// Gradient background. Takes priority over [backgroundColor].
  final LinearGradient? backgroundGradient;

  /// The logo widget to display (e.g. Image.asset, FlutterLogo).
  final Widget? logo;

  /// App name text shown below the logo.
  final String? appName;

  /// Tagline or subtitle text.
  final String? tagline;

  /// Text style for [appName].
  final TextStyle? appNameStyle;

  /// Text style for [tagline].
  final TextStyle? taglineStyle;

  /// Layout type for the splash UI.
  final SplashLayoutType layoutType;

  /// A fully custom widget to use as the splash content. Requires [layoutType] = [SplashLayoutType.custom].
  final Widget? customContent;

  /// Theme controlling colors of the splash screen.
  final SplashTheme? theme;

  /// Whether to show a loading indicator while [onInit] runs.
  final bool showLoader;

  /// Custom loading indicator widget. Defaults to [CircularProgressIndicator].
  final Widget? customLoader;

  /// Whether to enable the interactive "tap to continue" mode.
  final bool tapToContinue;

  /// Whether to show a skip button.
  final bool showSkipButton;

  /// Label for the skip button.
  final String skipButtonLabel;

  /// Whether to enable performance monitoring (debug builds only).
  final bool enablePerformanceMonitoring;

  /// Creates a [SplashConfig].
  const SplashConfig({
    this.durationMs = 2500,
    this.animation = const SplashAnimation(type: SplashAnimationType.fadeIn),
    this.backgroundColor,
    this.backgroundGradient,
    this.logo,
    this.appName,
    this.tagline,
    this.appNameStyle,
    this.taglineStyle,
    this.layoutType = SplashLayoutType.logoCenter,
    this.customContent,
    this.theme,
    this.showLoader = false,
    this.customLoader,
    this.tapToContinue = false,
    this.showSkipButton = false,
    this.skipButtonLabel = 'Skip',
    this.enablePerformanceMonitoring = false,
  });

  /// Returns a copy of this config with specified fields overridden.
  SplashConfig copyWith({
    int? durationMs,
    SplashAnimation? animation,
    Color? backgroundColor,
    LinearGradient? backgroundGradient,
    Widget? logo,
    String? appName,
    String? tagline,
    TextStyle? appNameStyle,
    TextStyle? taglineStyle,
    SplashLayoutType? layoutType,
    Widget? customContent,
    SplashTheme? theme,
    bool? showLoader,
    Widget? customLoader,
    bool? tapToContinue,
    bool? showSkipButton,
    String? skipButtonLabel,
    bool? enablePerformanceMonitoring,
  }) =>
      SplashConfig(
        durationMs: durationMs ?? this.durationMs,
        animation: animation ?? this.animation,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
        logo: logo ?? this.logo,
        appName: appName ?? this.appName,
        tagline: tagline ?? this.tagline,
        appNameStyle: appNameStyle ?? this.appNameStyle,
        taglineStyle: taglineStyle ?? this.taglineStyle,
        layoutType: layoutType ?? this.layoutType,
        customContent: customContent ?? this.customContent,
        theme: theme ?? this.theme,
        showLoader: showLoader ?? this.showLoader,
        customLoader: customLoader ?? this.customLoader,
        tapToContinue: tapToContinue ?? this.tapToContinue,
        showSkipButton: showSkipButton ?? this.showSkipButton,
        skipButtonLabel: skipButtonLabel ?? this.skipButtonLabel,
        enablePerformanceMonitoring:
            enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      );
}
