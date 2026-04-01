import 'package:flutter/material.dart';
import '../config/splash_config.dart';
import '../theme/splash_theme.dart';

/// Builds the splash screen layout based on the provided [SplashConfig] and [SplashTheme].
///
/// Used internally by [SmartSplash] to render the splash UI.
class SplashLayout extends StatelessWidget {
  /// The splash configuration.
  final SplashConfig config;

  /// The resolved theme (light, dark, auto, or custom).
  final SplashTheme theme;

  /// Whether the splash is currently loading.
  final bool isLoading;

  /// Called when the user taps the screen (when [tapToContinue] is enabled).
  final VoidCallback? onTap;

  /// Called when the skip button is pressed.
  final VoidCallback? onSkip;

  /// Creates a [SplashLayout].
  const SplashLayout({
    super.key,
    required this.config,
    required this.theme,
    this.isLoading = false,
    this.onTap,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (config.layoutType) {
      case SplashLayoutType.logoCenter:
        content = _buildLogoCenterLayout();
        break;
      case SplashLayoutType.logoWithText:
        content = _buildLogoWithTextLayout();
        break;
      case SplashLayoutType.custom:
        content = config.customContent ?? _buildLogoCenterLayout();
        break;
      case SplashLayoutType.fullBackground:
        content = _buildFullBackgroundLayout();
        break;
    }

    Widget background;
    if (config.backgroundGradient != null) {
      background = Container(
        decoration: BoxDecoration(gradient: config.backgroundGradient),
        child: content,
      );
    } else {
      background = ColoredBox(
        color: config.backgroundColor ?? theme.backgroundColor,
        child: content,
      );
    }

    Widget root = SafeArea(child: background);

    if (config.tapToContinue) {
      root = GestureDetector(onTap: onTap, child: root);
    }

    return root;
  }

  Widget _buildLogoCenterLayout() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (config.logo != null) config.logo!,
              if (config.showLoader) ...[
                const SizedBox(height: 32),
                _buildLoader(),
              ],
            ],
          ),
        ),
        if (config.showSkipButton) _buildSkipButton(),
      ],
    );
  }

  Widget _buildLogoWithTextLayout() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (config.logo != null) config.logo!,
              if (config.appName != null) ...[
                const SizedBox(height: 20),
                Text(
                  config.appName!,
                  style: config.appNameStyle ??
                      TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                        letterSpacing: 1.2,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (config.tagline != null) ...[
                const SizedBox(height: 8),
                Text(
                  config.tagline!,
                  style: config.taglineStyle ??
                      TextStyle(
                        fontSize: 14,
                        color: theme.textColor.withAlpha(180),
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (config.showLoader) ...[
                const SizedBox(height: 40),
                _buildLoader(),
              ],
            ],
          ),
        ),
        if (config.showSkipButton) _buildSkipButton(),
      ],
    );
  }

  Widget _buildFullBackgroundLayout() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (config.logo != null)
          Positioned.fill(
            child: FittedBox(fit: BoxFit.cover, child: config.logo),
          ),
        if (config.appName != null || config.tagline != null)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (config.appName != null)
                  Text(
                    config.appName!,
                    style: config.appNameStyle ??
                        const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                if (config.tagline != null)
                  Text(
                    config.tagline!,
                    style: config.taglineStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(210),
                        ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        if (config.showLoader)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(child: _buildLoader()),
          ),
        if (config.showSkipButton) _buildSkipButton(),
      ],
    );
  }

  Widget _buildLoader() {
    return config.customLoader ??
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(theme.loaderColor),
          ),
        );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: TextButton(
        onPressed: onSkip,
        child: Text(
          config.skipButtonLabel,
          style: TextStyle(color: theme.textColor.withAlpha(180)),
        ),
      ),
    );
  }
}
