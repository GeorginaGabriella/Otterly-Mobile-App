import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../widgets/onboarding_indicator.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_background.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
  {
    'title': 'Welcome to Otter.ly!',
    'description':
        'Your new favorite space to connect, share, and grow with the UNTAR student community.',
    'image': 'assets/images/onboarding/onboarding_1_welcome.png',
  },
  {
    'title': 'Connect with Students',
    'description':
        'Meet new friends, share your stories, and build meaningful connections with fellow students.',
    'image': 'assets/images/onboarding/onboarding_2_connect.png',
  },
  {
    'title': 'Discover Campus Life',
    'description':
        'Explore campus events, student organizations, and exciting activities around you.',
    'image': 'assets/images/onboarding/onboarding_3_campus.png',
  },
];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _nextPage() {
    if (_isLastPage) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SocialBackground(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 12),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    _isLastPage ? '' : 'Skip',
                    style: const TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page['image']!,
                          height: 260,
                          width: 260,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets,
                              size: 150,
                              color: AppColors.burgundy,
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.burgundy,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          page['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicator
            OnboardingIndicator(
              currentPage: _currentPage,
              pageCount: _pages.length,
            ),
            const SizedBox(height: 30),
            // Navigation button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: PrimaryButton(
                text: _isLastPage ? 'Get Started' : 'Next',
                onPressed: _nextPage,
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}