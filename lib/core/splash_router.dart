import 'package:flutter/widgets.dart';

/// Represents a named route destination returned by the splash [onInit] callback.
///
/// Use the static factory constructors to create route destinations
/// for common navigation targets.
class SplashRoute {
  /// The named route string (e.g. '/home', '/login').
  final String route;

  /// Optional arguments to pass to the destination route.
  final Object? arguments;

  /// Creates a [SplashRoute] with the given [route] and optional [arguments].
  const SplashRoute(this.route, {this.arguments});

  /// Creates a route pointing to the home screen.
  factory SplashRoute.home({Object? arguments}) =>
      SplashRoute('/home', arguments: arguments);

  /// Creates a route pointing to the login screen.
  factory SplashRoute.login({Object? arguments}) =>
      SplashRoute('/login', arguments: arguments);

  /// Creates a route pointing to the onboarding screen.
  factory SplashRoute.onboarding({Object? arguments}) =>
      SplashRoute('/onboarding', arguments: arguments);

  /// Creates a route pointing to a custom named [path].
  factory SplashRoute.custom(String path, {Object? arguments}) =>
      SplashRoute(path, arguments: arguments);

  @override
  String toString() => 'SplashRoute(route: $route, arguments: $arguments)';
}

/// Handles navigation after the splash screen completes.
///
/// Call [navigate] to push the resolved [SplashRoute] onto the navigator.
class SplashRouter {
  /// Navigates to the given [splashRoute] using the provided [context].
  ///
  /// Replaces the current route so the splash screen is removed from the stack.
  static void navigate(BuildContext context, SplashRoute splashRoute) {
    Navigator.of(context).pushReplacementNamed(
      splashRoute.route,
      arguments: splashRoute.arguments,
    );
  }

  /// Navigates using a [PageRouteBuilder] for custom transition support.
  ///
  /// Supply a [pageBuilder] that returns the destination widget.
  static void navigateWithTransition(
    BuildContext context, {
    required Widget Function(BuildContext) pageBuilder,
    Duration transitionDuration = const Duration(milliseconds: 400),
  }) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: transitionDuration,
        pageBuilder: (ctx, _, __) => pageBuilder(ctx),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
