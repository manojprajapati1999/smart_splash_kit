import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of smart_splash_kit must implement.
///
/// Platform-specific implementations should extend this class.
abstract class SmartSplashKitPlatform extends PlatformInterface {
  /// Constructs a [SmartSplashKitPlatform].
  SmartSplashKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmartSplashKitPlatform _instance = _MethodChannelSmartSplashKit();

  /// The default instance of [SmartSplashKitPlatform] to use.
  static SmartSplashKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmartSplashKitPlatform].
  static set instance(SmartSplashKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the current platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Returns the system theme: "light" or "dark".
  Future<String> getSystemTheme() {
    throw UnimplementedError('getSystemTheme() has not been implemented.');
  }

  /// Signals native layer to keep splash visible.
  Future<void> keepSplashVisible() {
    throw UnimplementedError('keepSplashVisible() has not been implemented.');
  }

  /// Signals native layer to remove the splash screen.
  Future<void> removeSplash() {
    throw UnimplementedError('removeSplash() has not been implemented.');
  }
}

/// Default MethodChannel implementation of [SmartSplashKitPlatform].
class _MethodChannelSmartSplashKit extends SmartSplashKitPlatform {
  final _channel = const MethodChannel('smart_splash_kit');

  @override
  Future<String?> getPlatformVersion() async {
    return _channel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future<String> getSystemTheme() async {
    final result = await _channel.invokeMethod<String>('getSystemTheme');
    return result ?? 'light';
  }

  @override
  Future<void> keepSplashVisible() async {
    await _channel.invokeMethod('keepSplashVisible');
  }

  @override
  Future<void> removeSplash() async {
    await _channel.invokeMethod('removeSplash');
  }
}
