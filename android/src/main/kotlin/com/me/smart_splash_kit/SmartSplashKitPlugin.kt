package com.me.smart_splash_kit

import android.app.Activity
import android.content.Context
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * SmartSplashKitPlugin
 *
 * Android-side plugin for Smart Splash Kit.
 *
 * Responsibilities:
 *  - getPlatformVersion: returns Android OS version string
 *  - getSystemTheme: returns "dark" or "light" based on current system UI mode
 *  - keepSplashVisible / removeSplash: hooks for native → Flutter transition control
 *
 * All splash UI, routing, animation, and logic live in Dart.
 */
class SmartSplashKitPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "smart_splash_kit")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "getSystemTheme" -> {
                val currentContext = activity ?: context
                val theme = if (currentContext != null) {
                    val uiMode = currentContext.resources.configuration.uiMode and
                            android.content.res.Configuration.UI_MODE_NIGHT_MASK
                    if (uiMode == android.content.res.Configuration.UI_MODE_NIGHT_YES) "dark" else "light"
                } else {
                    "light"
                }
                result.success(theme)
            }
            "keepSplashVisible" -> {
                // Hook: called by Flutter to keep native splash visible
                // Works with flutter_native_splash – no action needed here
                // as flutter_native_splash handles this via its own mechanism.
                result.success(null)
            }
            "removeSplash" -> {
                // Hook: called by Flutter when ready to dismiss native splash
                result.success(null)
            }
            "getDeviceInfo" -> {
                val info = mapOf(
                    "os" to "Android",
                    "osVersion" to Build.VERSION.RELEASE,
                    "sdkInt" to Build.VERSION.SDK_INT,
                    "manufacturer" to Build.MANUFACTURER,
                    "model" to Build.MODEL,
                )
                result.success(info)
            }
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
