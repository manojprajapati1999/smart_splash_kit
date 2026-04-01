import 'package:flutter_test/flutter_test.dart';
import 'package:smart_splash_kit/smart_splash_kit.dart';

void main() {
  group('SplashRoute', () {
    test('SplashRoute.home() returns /home', () {
      final route = SplashRoute.home();
      expect(route.route, '/home');
    });

    test('SplashRoute.login() returns /login', () {
      final route = SplashRoute.login();
      expect(route.route, '/login');
    });

    test('SplashRoute.onboarding() returns /onboarding', () {
      final route = SplashRoute.onboarding();
      expect(route.route, '/onboarding');
    });

    test('SplashRoute.custom() returns correct path', () {
      final route = SplashRoute.custom('/dashboard');
      expect(route.route, '/dashboard');
    });

    test('SplashRoute supports arguments', () {
      final route = SplashRoute.home(arguments: {'userId': 42});
      expect(route.arguments, {'userId': 42});
    });
  });

  group('SplashAnimation', () {
    test('SplashAnimation.fadeIn() has correct type', () {
      final anim = SplashAnimation.fadeIn();
      expect(anim.type, SplashAnimationType.fadeIn);
    });

    test('SplashAnimation.scaleUp() has correct type', () {
      final anim = SplashAnimation.scaleUp();
      expect(anim.type, SplashAnimationType.scaleUp);
    });

    test('SplashAnimation.slideUp() has correct type', () {
      final anim = SplashAnimation.slideUp();
      expect(anim.type, SplashAnimationType.slideUp);
    });

    test('SplashAnimation.rotate() has correct type', () {
      final anim = SplashAnimation.rotate();
      expect(anim.type, SplashAnimationType.rotate);
    });

    test('SplashAnimation.fadeScale() has correct type', () {
      final anim = SplashAnimation.fadeScale();
      expect(anim.type, SplashAnimationType.fadeScale);
    });

    test('SplashAnimation.none() has zero duration', () {
      final anim = SplashAnimation.none();
      expect(anim.durationMs, 0);
    });

    test('SplashAnimation.sequence() aggregates duration', () {
      final seq = SplashAnimation.sequence([
        SplashAnimation.fadeIn(durationMs: 500),
        SplashAnimation.scaleUp(durationMs: 600),
      ]);
      expect(seq.type, SplashAnimationType.sequence);
      expect(seq.durationMs, 1100);
    });

    test('totalDuration includes delay', () {
      final anim = SplashAnimation.fadeIn(durationMs: 800, delayMs: 200);
      expect(anim.totalDuration, const Duration(milliseconds: 1000));
    });
  });

  group('SplashTheme', () {
    test('SplashTheme.light() has white background', () {
      final theme = SplashTheme.light();
      expect(theme.backgroundColor.value, const Color(0xFFFFFFFF).value);
    });

    test('SplashTheme.dark() has dark background', () {
      final theme = SplashTheme.dark();
      expect(theme.backgroundColor.value, const Color(0xFF121212).value);
    });

    test('SplashTheme.copyWith() overrides correctly', () {
      final theme = SplashTheme.light().copyWith(
        backgroundColor: const Color(0xFF0000FF),
      );
      expect(theme.backgroundColor.value, const Color(0xFF0000FF).value);
    });
  });

  group('SplashConfig', () {
    test('SplashConfig default durationMs is 2500', () {
      const config = SplashConfig();
      expect(config.durationMs, 2500);
    });

    test('SplashConfig copyWith overrides durationMs', () {
      const config = SplashConfig(durationMs: 3000);
      final copied = config.copyWith(durationMs: 5000);
      expect(copied.durationMs, 5000);
    });

    test('SplashConfig default layoutType is logoCenter', () {
      const config = SplashConfig();
      expect(config.layoutType, SplashLayoutType.logoCenter);
    });
  });

  group('SplashConfigParser', () {
    test('fromJson parses animation type correctly', () {
      const json = '{"animation": "scale_up", "duration": 2000}';
      final config = SplashConfigParser.fromJson(json);
      expect(config, isNotNull);
      expect(config!.animation.type, SplashAnimationType.scaleUp);
      expect(config.durationMs, 2000);
    });

    test('fromJson parses fade animation', () {
      const json = '{"animation": "fade", "duration": 1500}';
      final config = SplashConfigParser.fromJson(json);
      expect(config!.animation.type, SplashAnimationType.fadeIn);
    });

    test('fromJson parses background_color', () {
      const json = '{"background_color": "#FF0000"}';
      final config = SplashConfigParser.fromJson(json);
      expect(config!.backgroundColor, isNotNull);
    });

    test('fromJson returns null for invalid JSON', () {
      final config = SplashConfigParser.fromJson('{invalid}');
      expect(config, isNull);
    });

    test('fromMap parses layout type', () {
      final config = SplashConfigParser.fromMap({
        'type': 'logo_with_text',
        'duration': 3000,
      });
      expect(config.layoutType, SplashLayoutType.logoWithText);
    });

    test('toMap round-trips durationMs', () {
      const config = SplashConfig(durationMs: 4000);
      final map = SplashConfigParser.toMap(config);
      expect(map['duration'], 4000);
    });
  });

  group('SplashController', () {
    test('initializes and completes successfully', () async {
      final controller = SplashController(
        onInit: () async => SplashRoute.home(),
        minimumDuration: 0,
      );
      await controller.initialize();
      expect(controller.state, SplashState.completed);
      expect(controller.resolvedRoute?.route, '/home');
      controller.dispose();
    });

    test('falls back to errorFallbackRoute on exception', () async {
      final controller = SplashController(
        onInit: () async => throw Exception('Test error'),
        minimumDuration: 0,
        errorFallbackRoute: SplashRoute.login(),
      );
      await controller.initialize();
      expect(controller.state, SplashState.completed);
      expect(controller.resolvedRoute?.route, '/login');
      controller.dispose();
    });

    test('sets error state when no fallback route provided', () async {
      final controller = SplashController(
        onInit: () async => throw Exception('Test error'),
        minimumDuration: 0,
      );
      await controller.initialize();
      expect(controller.state, SplashState.error);
      expect(controller.error, isNotNull);
      controller.dispose();
    });

    test('retry resets state and re-runs onInit', () async {
      int callCount = 0;
      final controller = SplashController(
        onInit: () async {
          callCount++;
          if (callCount == 1) throw Exception('First attempt fails');
          return SplashRoute.home();
        },
        minimumDuration: 0,
      );
      await controller.initialize();
      expect(controller.state, SplashState.error);

      await controller.retry();
      expect(controller.state, SplashState.completed);
      expect(callCount, 2);
      controller.dispose();
    });

    test('performance monitoring records load time', () async {
      final controller = SplashController(
        onInit: () async => SplashRoute.home(),
        minimumDuration: 0,
        enablePerformanceMonitoring: true,
      );
      await controller.initialize();
      expect(controller.loadTimeMs, isNotNull);
      expect(controller.loadTimeMs! >= 0, isTrue);
      controller.dispose();
    });
  });

  group('ApiLoader', () {
    test('returns success result on successful operation', () async {
      final result = await ApiLoader.run<String>(
        () async => 'hello',
        timeout: const Duration(seconds: 5),
      );
      expect(result.success, isTrue);
      expect(result.data, 'hello');
    });

    test('returns failure result on exception', () async {
      final result = await ApiLoader.run<String>(
        () async => throw Exception('Network error'),
        timeout: const Duration(seconds: 5),
        maxRetries: 0,
      );
      expect(result.success, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('retries the specified number of times', () async {
      int attempts = 0;
      final result = await ApiLoader.run<String>(
        () async {
          attempts++;
          if (attempts < 3) throw Exception('Retry me');
          return 'success after retries';
        },
        maxRetries: 2,
        retryDelay: Duration.zero,
      );
      expect(result.success, isTrue);
      expect(attempts, 3);
    });

    test('runAll executes all operations concurrently', () async {
      final results = await ApiLoader.runAll([
        () async => 'first',
        () async => 'second',
        () async => 'third',
      ]);
      expect(results.length, 3);
      expect(results.every((r) => r.success), isTrue);
    });
  });
}
