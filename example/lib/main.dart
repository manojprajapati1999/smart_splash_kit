import 'package:flutter/material.dart';
import 'package:smart_splash_kit/smart_splash_kit.dart';

void main() {
  runApp(const DemoChooserApp());
}

// ---------------------------------------------------------------------------
// Root: Template Chooser
// ---------------------------------------------------------------------------
class DemoChooserApp extends StatelessWidget {
  const DemoChooserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Splash Kit Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TemplateSelectorPage(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/onboarding': (_) => const OnboardingScreen(),

        // Template splash routes
        '/splash/simple': (_) => const SimpleLogoSplash(),
        '/splash/animated': (_) => const AnimatedLogoSplash(),
        '/splash/loader': (_) => const LoaderSplash(),
        '/splash/branding': (_) => const BrandingSplash(),
        '/splash/config': (_) => const ConfigBasedSplash(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Template Selector
// ---------------------------------------------------------------------------
class TemplateSelectorPage extends StatelessWidget {
  const TemplateSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final templates = [
      _TemplateItem(
        emoji: '🖼️',
        title: 'Simple Logo Splash',
        subtitle: 'Center logo, fade animation, clean white background.',
        color: Colors.blue,
        route: '/splash/simple',
      ),
      _TemplateItem(
        emoji: '✨',
        title: 'Animated Logo Splash',
        subtitle: 'Sequence animation: fade-scale then slide-up text.',
        color: Colors.purple,
        route: '/splash/animated',
      ),
      _TemplateItem(
        emoji: '⏳',
        title: 'Loader Splash',
        subtitle: 'Shows loader while API call completes. Retry on error.',
        color: Colors.teal,
        route: '/splash/loader',
      ),
      _TemplateItem(
        emoji: '🎨',
        title: 'Branding Splash',
        subtitle: 'Gradient background, app name, tagline, dark theme.',
        color: Colors.deepOrange,
        route: '/splash/branding',
      ),
      _TemplateItem(
        emoji: '⚙️',
        title: 'Config-Based Splash',
        subtitle: 'JSON-driven splash — change config, change everything.',
        color: Colors.green,
        route: '/splash/config',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text('Smart Splash Kit'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Choose a template to preview:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          ...templates.map((t) => _TemplateCard(item: t)),
        ],
      ),
    );
  }
}

class _TemplateItem {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  const _TemplateItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });
}

class _TemplateCard extends StatelessWidget {
  final _TemplateItem item;
  const _TemplateCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(item.route),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.subtitle,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: item.color),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Template 1 – Simple Logo Splash
// ---------------------------------------------------------------------------
class SimpleLogoSplash extends StatelessWidget {
  const SimpleLogoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartSplash(
      config: SplashConfig(
        durationMs: 2500,
        animation: SplashAnimation.fadeIn(durationMs: 900),
        backgroundColor: Colors.white,
        layoutType: SplashLayoutType.logoCenter,
        logo: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withAlpha(80),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.rocket_launch_rounded,
              size: 60, color: Colors.white),
        ),
        showLoader: false,
      ),
      theme: SplashTheme.light(),
      onInit: () async {
        await Future.delayed(const Duration(seconds: 2));
        return SplashRoute.home();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Template 2 – Animated Logo Splash
// ---------------------------------------------------------------------------
class AnimatedLogoSplash extends StatelessWidget {
  const AnimatedLogoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartSplash(
      config: SplashConfig(
        durationMs: 3000,
        animation: SplashAnimation.fadeScale(durationMs: 1000),
        backgroundColor: const Color(0xFF1A1035),
        layoutType: SplashLayoutType.logoWithText,
        logo: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FBE), Color(0xFF4A90E2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FBE).withAlpha(100),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome_rounded,
              size: 56, color: Colors.white),
        ),
        appName: 'Smart Splash Kit',
        tagline: 'Beautiful. Smart. Fast.',
        appNameStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
        taglineStyle: TextStyle(
          fontSize: 14,
          color: Colors.white.withAlpha(180),
          letterSpacing: 2.0,
        ),
        showLoader: false,
      ),
      theme: SplashTheme.dark(),
      onInit: () async {
        await Future.delayed(const Duration(milliseconds: 2500));
        return SplashRoute.home();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Template 3 – Loader Splash (API simulation)
// ---------------------------------------------------------------------------
class LoaderSplash extends StatelessWidget {
  const LoaderSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartSplash(
      config: SplashConfig(
        durationMs: 0,
        animation: SplashAnimation.fadeIn(durationMs: 700),
        backgroundColor: Colors.white,
        layoutType: SplashLayoutType.logoWithText,
        logo: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.teal.shade100, width: 2),
          ),
          child: Icon(Icons.cloud_sync_rounded,
              size: 52, color: Colors.teal.shade600),
        ),
        appName: 'DataSync',
        tagline: 'Connecting to server...',
        appNameStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A3C34),
        ),
        taglineStyle: TextStyle(
          fontSize: 13,
          color: Colors.teal.shade400,
          letterSpacing: 0.5,
        ),
        showLoader: true,
        customLoader: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade500),
          ),
        ),
      ),
      theme: SplashTheme.light(),
      errorFallbackRoute: SplashRoute.login(),
      onInit: () async {
        // Simulate API call with ApiLoader
        final result = await ApiLoader.run<Map<String, dynamic>>(
          () async {
            await Future.delayed(const Duration(seconds: 2));
            // Simulate checking auth token
            const isLoggedIn = true;
            if (isLoggedIn) return {'user': 'Manoj', 'token': 'abc123'};
            throw Exception('Not authenticated');
          },
          timeout: const Duration(seconds: 8),
          maxRetries: 1,
        );

        if (result.success) return SplashRoute.home();
        return SplashRoute.login();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Template 4 – Branding Splash
// ---------------------------------------------------------------------------
class BrandingSplash extends StatelessWidget {
  const BrandingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SmartSplash(
      config: SplashConfig(
        durationMs: 3000,
        animation: SplashAnimation.slideUp(durationMs: 900),
        backgroundGradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFE91E63), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        layoutType: SplashLayoutType.logoWithText,
        logo: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(80), width: 2),
          ),
          child:
              const Icon(Icons.bolt_rounded, size: 56, color: Colors.white),
        ),
        appName: 'Brandify',
        tagline: 'Your brand, reimagined.',
        appNameStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
        taglineStyle: TextStyle(
          fontSize: 15,
          color: Colors.white.withAlpha(220),
          letterSpacing: 1.0,
        ),
        showLoader: false,
        showSkipButton: true,
        skipButtonLabel: 'Skip',
      ),
      theme: SplashTheme.custom(
        backgroundColor: const Color(0xFFFF6B35),
        loaderColor: Colors.white,
        textColor: Colors.white,
      ),
      onInit: () async {
        await Future.delayed(const Duration(seconds: 2));
        // First launch: go to onboarding, otherwise home
        const isFirstLaunch = true;
        if (isFirstLaunch) return SplashRoute.onboarding();
        return SplashRoute.home();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Template 5 – Config-Based Splash (JSON driven)
// ---------------------------------------------------------------------------
class ConfigBasedSplash extends StatelessWidget {
  const ConfigBasedSplash({super.key});

  // Simulated remote/JSON config
  static const String _jsonConfig = '''
  {
    "type": "logo_with_text",
    "animation": "scale_up",
    "duration": 2500,
    "background_color": "#0D1B2A",
    "app_name": "ConfigApp",
    "tagline": "Powered by JSON config",
    "show_loader": false
  }
  ''';

  @override
  Widget build(BuildContext context) {
    // Parse config from JSON
    final parsedConfig = SplashConfigParser.fromJson(_jsonConfig);

    // Merge with our logo widget (JSON can't carry widgets directly)
    final config = (parsedConfig ?? const SplashConfig()).copyWith(
      logo: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.data_object_rounded,
            size: 52, color: Colors.white),
      ),
      appNameStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      taglineStyle: TextStyle(
        fontSize: 13,
        color: Colors.white.withAlpha(180),
        letterSpacing: 1.0,
      ),
      enablePerformanceMonitoring: true,
    );

    return SmartSplash(
      config: config,
      theme: SplashTheme.dark(),
      onInit: () async {
        await Future.delayed(const Duration(seconds: 2));
        return SplashRoute.home();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Destination screens
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (r) => false),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 72, color: Colors.green),
            SizedBox(height: 16),
            Text('You reached Home! 🎉',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Splash → Home navigation worked.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (r) => false),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text('Login Screen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Splash → Login navigation worked.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FF),
      appBar: AppBar(
        title: const Text('Onboarding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (r) => false),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.waving_hand_rounded, size: 64, color: Colors.purple),
            SizedBox(height: 16),
            Text('Welcome!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Splash → Onboarding navigation worked.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
