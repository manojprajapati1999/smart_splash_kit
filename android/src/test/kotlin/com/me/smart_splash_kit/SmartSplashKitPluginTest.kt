package com.me.smart_splash_kit

import org.junit.Test
import kotlin.test.assertEquals

/**
 * Unit tests for SmartSplashKitPlugin.
 * Core logic lives in Dart – native layer only provides OS/theme info.
 */
class SmartSplashKitPluginTest {
    @Test
    fun pluginClassExists() {
        // Verify the plugin class can be instantiated
        val plugin = SmartSplashKitPlugin()
        assertEquals(SmartSplashKitPlugin::class.java, plugin.javaClass)
    }
}
