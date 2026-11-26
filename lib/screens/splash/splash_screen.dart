import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/otter_logo_widget.dart';
import '../../widgets/social_background.dart';
import '../auth/login_screen.dart';
import '../navigation/main_navigation.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.wait<void>([
      Future<void>.delayed(const Duration(seconds: 3)),
      ref.read(authProvider.notifier).restoreSession(),
    ]);

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final currentUser = ref.read(authProvider);

    if (!mounted) return;

    final Widget destination;
    if (currentUser != null) {
      destination = const MainNavigation();
    } else if (hasSeenOnboarding) {
      destination = const LoginScreen();
    } else {
      destination = const OnboardingScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SocialBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OtterLogoWidget(
                  logoSize: 170,
                  showSlogan: true,
                ),
                SizedBox(height: 35),
                CircularProgressIndicator(
                  color: AppColors.pink,
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
