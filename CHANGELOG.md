## 1.0.0

### 🚀 Initial Release

**Core Features:**

- **Smart Routing Engine** — Async `onInit` callback with `SplashRoute` destinations for home, login, onboarding, or any custom named route. Supports error fallback routes.
- **Animation Engine** — 9 built-in animation types: `fadeIn`, `scaleUp`, `scaleDown`, `slideUp`, `slideDown`, `slideLeft`, `slideRight`, `rotate`, `fadeScale`, `sequence`. All configurable with duration, curve, and delay.
- **UI Builder System** — 4 layout types: `logoCenter`, `logoWithText`, `fullBackground`, `custom`. Supports gradient backgrounds, responsive layout, and SafeArea handling.
- **Theme Support** — `SplashTheme.light()`, `SplashTheme.dark()`, `SplashTheme.auto()` (system-detected), and `SplashTheme.custom()`. Full `copyWith` support.
- **API Loader Module** — `ApiLoader.run()` with configurable timeout, retry count, and retry delay. `ApiLoader.runAll()` for concurrent loading. `ApiLoadResult` for structured outcomes.
- **Config-Based Splash** — `SplashConfig` data model and `SplashConfigParser` for JSON/Map-driven splash screens. `toMap()` round-trip support.
- **Interactive Splash** — `tapToContinue` and `showSkipButton` options for engaging, user-controlled splash experiences.
- **Performance Monitoring** — `enablePerformanceMonitoring` flag logs app startup time in debug builds via `SplashController.loadTimeMs`.
- **Native → Flutter Transition** — `keepSplashVisible()` and `removeSplash()` platform hooks. Compatible with `flutter_native_splash`.
- **Error Handling** — Built-in error state UI with retry button. Customizable via `errorBuilder`. Automatic fallback routing.

**Architecture:**
- `SplashController` — lifecycle management, state machine, retry logic
- `SplashRouter` — `pushReplacementNamed` and custom `PageRouteBuilder` navigation
- `SplashLayout` — layout builder for all 4 layout types
- `SplashWidgets` — pre-built loader, dotsLoader, errorState, retryButton, performanceBadge
- `SmartSplash` — main widget with full `TickerProviderStateMixin` animation support

**Platform Support:**
- ✅ Android (Kotlin) — system theme detection, device info
- ✅ iOS (Swift + SPM) — system theme detection, device info
- ✅ Web — Flutter web compatible
- ✅ macOS (Swift + SPM) — system theme detection
- ✅ Windows (C++) — registry-based dark mode detection
- ✅ Linux (C++) — platform version support

**5 Ready-to-Use Templates:**
1. Simple Logo Splash
2. Animated Logo Splash
3. Loader Splash (API simulation)
4. Branding Splash (gradient + skip button)
5. Config-Based Splash (JSON-driven)
