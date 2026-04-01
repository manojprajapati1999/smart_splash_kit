import 'package:flutter/animation.dart';

/// Defines the type of animation to apply on the splash screen.
enum SplashAnimationType {
  /// No animation – the widget appears immediately.
  none,

  /// Fades the widget in from transparent to opaque.
  fadeIn,

  /// Scales the widget up from a smaller size.
  scaleUp,

  /// Scales the widget down from a larger size.
  scaleDown,

  /// Slides the widget in from the bottom.
  slideUp,

  /// Slides the widget in from the top.
  slideDown,

  /// Slides the widget in from the left.
  slideLeft,

  /// Slides the widget in from the right.
  slideRight,

  /// Rotates the widget from 0 to 360 degrees.
  rotate,

  /// Combines fade and scale animations (fade in while scaling up).
  fadeScale,

  /// Runs multiple animations in sequence.
  sequence,
}

/// Configures a single animation step for the splash screen.
///
/// Use the static factory constructors for common presets, or
/// construct directly for full control.
class SplashAnimation {
  /// The animation type to apply.
  final SplashAnimationType type;

  /// Duration of the animation in milliseconds.
  final int durationMs;

  /// The animation curve to use.
  final Curve curve;

  /// For [SplashAnimationType.sequence], the list of animation steps.
  final List<SplashAnimation>? steps;

  /// Delay before starting the animation in milliseconds.
  final int delayMs;

  /// Creates a [SplashAnimation] with full configuration.
  const SplashAnimation({
    required this.type,
    this.durationMs = 800,
    this.curve = Curves.easeInOut,
    this.steps,
    this.delayMs = 0,
  });

  /// No animation – widget appears immediately.
  factory SplashAnimation.none() => const SplashAnimation(
        type: SplashAnimationType.none,
        durationMs: 0,
      );

  /// Fade-in animation.
  factory SplashAnimation.fadeIn({
    int durationMs = 800,
    Curve curve = Curves.easeIn,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.fadeIn,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Scale-up animation.
  factory SplashAnimation.scaleUp({
    int durationMs = 800,
    Curve curve = Curves.elasticOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.scaleUp,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Scale-down animation.
  factory SplashAnimation.scaleDown({
    int durationMs = 800,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.scaleDown,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Slide-up animation.
  factory SplashAnimation.slideUp({
    int durationMs = 700,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.slideUp,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Slide-down animation.
  factory SplashAnimation.slideDown({
    int durationMs = 700,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.slideDown,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Slide-left animation.
  factory SplashAnimation.slideLeft({
    int durationMs = 700,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.slideLeft,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Slide-right animation.
  factory SplashAnimation.slideRight({
    int durationMs = 700,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.slideRight,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Rotation animation (full 360°).
  factory SplashAnimation.rotate({
    int durationMs = 1000,
    Curve curve = Curves.linear,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.rotate,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Combined fade + scale animation.
  factory SplashAnimation.fadeScale({
    int durationMs = 900,
    Curve curve = Curves.easeOut,
    int delayMs = 0,
  }) =>
      SplashAnimation(
        type: SplashAnimationType.fadeScale,
        durationMs: durationMs,
        curve: curve,
        delayMs: delayMs,
      );

  /// Sequence of multiple animation steps played one after another.
  factory SplashAnimation.sequence(List<SplashAnimation> steps) =>
      SplashAnimation(
        type: SplashAnimationType.sequence,
        steps: steps,
        durationMs: steps.fold(0, (sum, a) => sum + a.durationMs + a.delayMs),
      );

  /// Total duration including delay.
  Duration get totalDuration =>
      Duration(milliseconds: durationMs + delayMs);

  @override
  String toString() =>
      'SplashAnimation(type: $type, durationMs: $durationMs, delayMs: $delayMs)';
}
