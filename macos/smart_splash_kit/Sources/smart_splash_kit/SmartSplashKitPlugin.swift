import FlutterMacOS
import AppKit

/// SmartSplashKitPlugin (macOS)
///
/// macOS-side plugin for Smart Splash Kit.
public class SmartSplashKitPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "smart_splash_kit",
            binaryMessenger: registrar.messenger
        )
        let instance = SmartSplashKitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {

        case "getPlatformVersion":
            let version = ProcessInfo.processInfo.operatingSystemVersionString
            result("macOS \(version)")

        case "getSystemTheme":
            if #available(macOS 10.14, *) {
                let isDark = NSApp.effectiveAppearance.bestMatch(
                    from: [.darkAqua, .aqua]
                ) == .darkAqua
                result(isDark ? "dark" : "light")
            } else {
                result("light")
            }

        case "keepSplashVisible":
            result(nil)

        case "removeSplash":
            result(nil)

        case "getDeviceInfo":
            let info: [String: Any] = [
                "os": "macOS",
                "osVersion": ProcessInfo.processInfo.operatingSystemVersionString,
            ]
            result(info)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
