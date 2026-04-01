import 'dart:convert';
import 'package:flutter/material.dart';
import '../animation/splash_animation.dart';
import 'splash_config.dart';

/// Parses a JSON string or [Map] into a [SplashConfig].
///
/// Useful for remote config, A/B testing, or dynamic splash updates.
///
/// Supported JSON shape:
/// ```json
/// {
///   "type": "logo_center",
///   "animation": "fade",
///   "duration": 2000,
///   "background_color": "#FFFFFF",
///   "app_name": "My App",
///   "tagline": "Powered by Flutter"
/// }
/// ```
class SplashConfigParser {
  SplashConfigParser._();

  /// Parses a JSON [String] into a [SplashConfig].
  ///
  /// Returns null if parsing fails.
  static SplashConfig? fromJson(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return fromMap(map);
    } catch (_) {
      return null;
    }
  }

  /// Parses a [Map<String, dynamic>] into a [SplashConfig].
  static SplashConfig fromMap(Map<String, dynamic> map) {
    final animationStr = map['animation'] as String? ?? 'fade';
    final durationMs = (map['duration'] as int?) ?? 2500;
    final typeStr = map['type'] as String? ?? 'logo_center';
    final appName = map['app_name'] as String?;
    final tagline = map['tagline'] as String?;
    final bgColorStr = map['background_color'] as String?;

    return SplashConfig(
      durationMs: durationMs,
      animation: _parseAnimation(animationStr, durationMs),
      backgroundColor: bgColorStr != null ? _parseColor(bgColorStr) : null,
      appName: appName,
      tagline: tagline,
      layoutType: _parseLayoutType(typeStr),
      showLoader: map['show_loader'] as bool? ?? false,
    );
  }

  static SplashAnimation _parseAnimation(String type, int durationMs) {
    switch (type.toLowerCase()) {
      case 'fade':
      case 'fade_in':
        return SplashAnimation.fadeIn(durationMs: durationMs);
      case 'scale':
      case 'scale_up':
        return SplashAnimation.scaleUp(durationMs: durationMs);
      case 'scale_down':
        return SplashAnimation.scaleDown(durationMs: durationMs);
      case 'slide_up':
        return SplashAnimation.slideUp(durationMs: durationMs);
      case 'slide_down':
        return SplashAnimation.slideDown(durationMs: durationMs);
      case 'slide_left':
        return SplashAnimation.slideLeft(durationMs: durationMs);
      case 'slide_right':
        return SplashAnimation.slideRight(durationMs: durationMs);
      case 'rotate':
        return SplashAnimation.rotate(durationMs: durationMs);
      case 'fade_scale':
        return SplashAnimation.fadeScale(durationMs: durationMs);
      default:
        return SplashAnimation.fadeIn(durationMs: durationMs);
    }
  }

  static SplashLayoutType _parseLayoutType(String type) {
    switch (type.toLowerCase()) {
      case 'logo_center':
        return SplashLayoutType.logoCenter;
      case 'logo_with_text':
        return SplashLayoutType.logoWithText;
      case 'full_background':
        return SplashLayoutType.fullBackground;
      default:
        return SplashLayoutType.logoCenter;
    }
  }

  /// Parses a hex color string (e.g. '#FF0000' or 'FF0000') into a [Color].
  static Color _parseColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    final value = int.tryParse(
      cleaned.length == 6 ? 'FF$cleaned' : cleaned,
      radix: 16,
    );
    return value != null ? Color(value) : Colors.white;
  }

  /// Converts a [SplashConfig] back to a [Map<String, dynamic>].
  static Map<String, dynamic> toMap(SplashConfig config) {
    return {
      'duration': config.durationMs,
      'animation': _animationToString(config.animation.type),
      'type': _layoutTypeToString(config.layoutType),
      'app_name': config.appName,
      'tagline': config.tagline,
      'show_loader': config.showLoader,
      if (config.backgroundColor != null)
        'background_color':
            '#${config.backgroundColor!.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
    };
  }

  static String _animationToString(SplashAnimationType type) {
    switch (type) {
      case SplashAnimationType.fadeIn:
        return 'fade';
      case SplashAnimationType.scaleUp:
        return 'scale_up';
      case SplashAnimationType.scaleDown:
        return 'scale_down';
      case SplashAnimationType.slideUp:
        return 'slide_up';
      case SplashAnimationType.slideDown:
        return 'slide_down';
      case SplashAnimationType.slideLeft:
        return 'slide_left';
      case SplashAnimationType.slideRight:
        return 'slide_right';
      case SplashAnimationType.rotate:
        return 'rotate';
      case SplashAnimationType.fadeScale:
        return 'fade_scale';
      default:
        return 'fade';
    }
  }

  static String _layoutTypeToString(SplashLayoutType type) {
    switch (type) {
      case SplashLayoutType.logoCenter:
        return 'logo_center';
      case SplashLayoutType.logoWithText:
        return 'logo_with_text';
      case SplashLayoutType.fullBackground:
        return 'full_background';
      default:
        return 'logo_center';
    }
  }
}
