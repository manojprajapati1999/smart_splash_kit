import Flutter
import UIKit

/// SmartSplashKitPlugin
///
/// iOS-side plugin for Smart Splash Kit.
///
/// Responsibilities:
///  - getPlatformVersion: returns iOS version string
///  - getSystemTheme: returns "dark" or "light" based on UIUserInterfaceStyle
///  - keepSplashVisible / removeSplash: hooks for native → Flutter transition control
///
/// All splash UI, routing, animation, and logic live in Dart.
public class SmartSplashKitPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "smart_splash_kit",
            binaryMessenger: registrar.messenger()
        )
        let instance = SmartSplashKitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {

        case "getPlatformVersion":
            result("iOS \(UIDevice.current.systemVersion)")

        case "getSystemTheme":
            if #available(iOS 13.0, *) {
                let style = UITraitCollection.current.userInterfaceStyle
                result(style == .dark ? "dark" : "light")
            } else {
                result("light")
            }

        case "keepSplashVisible":
            // Hook: native splash is kept visible via flutter_native_splash.
            // No additional action needed on iOS.
            result(nil)

        case "removeSplash":
            // Hook: called when Flutter is ready to dismiss the native splash.
            result(nil)

        case "getDeviceInfo":
            let device = UIDevice.current
            let info: [String: Any] = [
                "os": "iOS",
                "osVersion": device.systemVersion,
                "model": device.model,
                "name": device.name,
            ]
            result(info)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
