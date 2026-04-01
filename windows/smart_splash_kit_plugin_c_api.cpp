#include "include/smart_splash_kit/smart_splash_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "smart_splash_kit_plugin.h"

void SmartSplashKitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  smart_splash_kit::SmartSplashKitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
