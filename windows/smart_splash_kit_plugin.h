#ifndef FLUTTER_PLUGIN_SMART_SPLASH_KIT_PLUGIN_H_
#define FLUTTER_PLUGIN_SMART_SPLASH_KIT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace smart_splash_kit {

class SmartSplashKitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  SmartSplashKitPlugin();
  virtual ~SmartSplashKitPlugin();

  SmartSplashKitPlugin(const SmartSplashKitPlugin&) = delete;
  SmartSplashKitPlugin& operator=(const SmartSplashKitPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace smart_splash_kit

#endif  // FLUTTER_PLUGIN_SMART_SPLASH_KIT_PLUGIN_H_
