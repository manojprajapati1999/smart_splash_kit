import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'animation/splash_animation.dart';
import 'config/splash_config.dart';
import 'core/splash_controller.dart';
import 'core/splash_router.dart';
import 'theme/splash_theme.dart';
import 'ui/splash_layout.dart';
import 'ui/splash_widgets.dart';

/// The main Smart Splash Kit widget.
///
/// Drop this in as your initial route widget. It handles animations,
/// smart routing, API loading, theming, and native transition.
///
/// ## Basic usage
/// ```dart
/// SmartSplash(
///   config: SplashConfig(
///     animation: SplashAnimation.fadeIn(),
///     logo: Image.asset('assets/logo.png'),
///     appName: 'My App',
///   ),
///   onInit: () async {
///     await Future.delayed(const Duration(seconds: 2));
///     return SplashRoute.home();
///   },
/// )
/// ```
class SmartSplash extends StatefulWidget {
  /// Configuration for the splash UI, animation, and behavior.
  final SplashConfig config;

  /// Async callback that returns the target [SplashRoute].
  ///
  /// This is where you put your login checks, token validation,
  /// first-time user detection, and deep link handling.
  final Future<SplashRoute> Function() onInit;

  /// Override theme. If null, uses [SplashTheme.light()] by default.
  final SplashTheme? theme;

  /// Route to navigate to if [onInit] throws. Defaults to [SplashRoute.login].
  final SplashRoute? errorFallbackRoute;

  /// Widget builder for the error state UI.
  ///
  /// Receives a [retry] callback and the resolved [SplashTheme].
  final Widget Function(VoidCallback retry, SplashTheme theme)? errorBuilder;

  /// Creates a [SmartSplash].
  const SmartSplash({
    super.key,
    required this.config,
    required this.onInit,
    this.theme,
    this.errorFallbackRoute,
    this.errorBuilder,
  });

  @override
  State<SmartSplash> createState() => _SmartSplashState();
}

class _SmartSplashState extends State<SmartSplash>
    with TickerProviderStateMixin {
  late SplashController _controller;
  late AnimationController _animationController;
  late AnimationController _sequenceController;
  late SplashTheme _theme;

  // Core animations
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _rotateAnim;

  bool _navigationTriggered = false;
  bool _tapContinueReady = false;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(
      onInit: widget.onInit,
      minimumDuration: widget.config.durationMs,
      errorFallbackRoute: widget.errorFallbackRoute,
      enablePerformanceMonitoring: widget.config.enablePerformanceMonitoring,
    );

    final cfg = widget.config;
    final animDuration = Duration(milliseconds: cfg.animation.durationMs);

    _animationController = AnimationController(vsync: this, duration: animDuration);
    _sequenceController = AnimationController(vsync: this, duration: animDuration);

    _buildAnimations(cfg.animation);

    // Start animation after delay
    Future.delayed(Duration(milliseconds: cfg.animation.delayMs), () {
      if (mounted) _animationController.forward();
    });

    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  void _buildAnimations(SplashAnimation anim) {
    final curved = CurvedAnimation(
      parent: _animationController,
      curve: anim.curve,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(curved);
    _rotateAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slideAnim = _buildSlideAnim(anim.type, curved);
  }

  Animation<Offset> _buildSlideAnim(SplashAnimationType type, Animation<double> curved) {
    Offset begin;
    switch (type) {
      case SplashAnimationType.slideUp:
        begin = const Offset(0.0, 0.5);
        break;
      case SplashAnimationType.slideDown:
        begin = const Offset(0.0, -0.5);
        break;
      case SplashAnimationType.slideLeft:
        begin = const Offset(0.5, 0.0);
        break;
      case SplashAnimationType.slideRight:
        begin = const Offset(-0.5, 0.0);
        break;
      default:
        begin = Offset.zero;
    }
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(curved);
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});

    if (_controller.state == SplashState.completed && !_navigationTriggered) {
      if (widget.config.tapToContinue) {
        setState(() => _tapContinueReady = true);
      } else {
        _navigate();
      }
    }
  }

  void _navigate() {
    if (!mounted || _navigationTriggered) return;
    _navigationTriggered = true;
    final route = _controller.resolvedRoute;
    if (route != null) {
      SplashRouter.navigate(context, route);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = widget.theme ?? SplashTheme.auto(context);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _animationController.dispose();
    _sequenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      backgroundColor: widget.config.backgroundColor ?? _theme.backgroundColor,
      body: Stack(
        children: [
          _buildAnimatedContent(state),
          if (state == SplashState.error) _buildErrorOverlay(),
          if (widget.config.enablePerformanceMonitoring &&
              kDebugMode &&
              _controller.loadTimeMs != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SplashWidgets.performanceBadge(
                  loadTimeMs: _controller.loadTimeMs!,
                  color: _theme.loaderColor,
                ),
              ),
            ),
          if (_tapContinueReady && widget.config.tapToContinue)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Tap to continue',
                  style: TextStyle(
                    color: _theme.textColor.withAlpha(180),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedContent(SplashState state) {
    final isLoading = state == SplashState.initializing;

    Widget content = SplashLayout(
      config: widget.config.copyWith(showLoader: widget.config.showLoader && isLoading),
      theme: _theme,
      isLoading: isLoading,
      onTap: _tapContinueReady ? _navigate : null,
      onSkip: _navigate,
    );

    return _applyAnimation(content, widget.config.animation.type);
  }

  Widget _applyAnimation(Widget child, SplashAnimationType type) {
    switch (type) {
      case SplashAnimationType.none:
        return child;
      case SplashAnimationType.fadeIn:
        return FadeTransition(opacity: _fadeAnim, child: child);
      case SplashAnimationType.scaleUp:
        return ScaleTransition(scale: _scaleAnim, child: child);
      case SplashAnimationType.scaleDown:
        return AnimatedBuilder(
          animation: _animationController,
          builder: (_, c) => Transform.scale(
            scale: Tween<double>(begin: 1.4, end: 1.0)
                .animate(CurvedAnimation(
                    parent: _animationController,
                    curve: widget.config.animation.curve))
                .value,
            child: c,
          ),
          child: child,
        );
      case SplashAnimationType.slideUp:
      case SplashAnimationType.slideDown:
      case SplashAnimationType.slideLeft:
      case SplashAnimationType.slideRight:
        return SlideTransition(position: _slideAnim, child: child);
      case SplashAnimationType.rotate:
        return RotationTransition(turns: _rotateAnim, child: child);
      case SplashAnimationType.fadeScale:
        return FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(scale: _scaleAnim, child: child),
        );
      case SplashAnimationType.sequence:
        // For sequence: run animations in order
        return FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(scale: _scaleAnim, child: child),
        );
    }
  }

  Widget _buildErrorOverlay() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(_controller.retry, _theme);
    }
    return ColoredBox(
      color: (_theme.backgroundColor).withAlpha(230),
      child: SplashWidgets.errorState(
        onRetry: () {
          _navigationTriggered = false;
          _controller.retry();
        },
        theme: _theme,
      ),
    );
  }
}
