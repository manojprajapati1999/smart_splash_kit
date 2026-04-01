#include "smart_splash_kit_plugin.h"

#include <windows.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

namespace smart_splash_kit {

// static
void SmartSplashKitPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "smart_splash_kit",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<SmartSplashKitPlugin>();
  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

SmartSplashKitPlugin::SmartSplashKitPlugin() {}
SmartSplashKitPlugin::~SmartSplashKitPlugin() {}

void SmartSplashKitPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

  if (method_call.method_name() == "getPlatformVersion") {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else {
      version_stream << "older";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));

  } else if (method_call.method_name() == "getSystemTheme") {
    // Check Windows dark mode via registry
    HKEY hKey;
    DWORD value = 1;  // Default light
    DWORD size = sizeof(DWORD);
    if (RegOpenKeyExW(HKEY_CURRENT_USER,
          L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
          0, KEY_READ, &hKey) == ERROR_SUCCESS) {
      RegQueryValueExW(hKey, L"AppsUseLightTheme", nullptr, nullptr,
                       reinterpret_cast<LPBYTE>(&value), &size);
      RegCloseKey(hKey);
    }
    std::string theme = (value == 0) ? "dark" : "light";
    result->Success(flutter::EncodableValue(theme));

  } else if (method_call.method_name() == "keepSplashVisible" ||
             method_call.method_name() == "removeSplash") {
    result->Success();

  } else if (method_call.method_name() == "getDeviceInfo") {
    flutter::EncodableMap info;
    info[flutter::EncodableValue("os")] = flutter::EncodableValue("Windows");
    result->Success(flutter::EncodableValue(info));

  } else {
    result->NotImplemented();
  }
}

}  // namespace smart_splash_kit
