import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'smart_splash_kit_platform_interface.dart';

/// Web implementation of [SmartSplashKitPlatform].
class SmartSplashKitWeb extends SmartSplashKitPlatform {
  /// Constructs a [SmartSplashKitWeb].
  SmartSplashKitWeb();

  /// Registers this class as the default instance of [SmartSplashKitPlatform].
  static void registerWith(Registrar registrar) {
    SmartSplashKitPlatform.instance = SmartSplashKitWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return 'Web';
  }

  @override
  Future<String> getSystemTheme() async {
    // Use CSS media query to detect dark mode on web.
    try {
      // Inline JS via dart:html alternative using conditional import
      // For compatibility, we return 'light' as a safe default.
      // Developers can use MediaQuery.of(context).platformBrightness in Dart.
      return 'light';
    } catch (_) {
      return 'light';
    }
  }

  @override
  Future<void> keepSplashVisible() async {
    // No-op on web.
  }

  @override
  Future<void> removeSplash() async {
    // No-op on web.
  }
}
