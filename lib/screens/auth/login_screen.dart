import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/otter_logo_widget.dart';
import '../../widgets/social_background.dart';
import '../../widgets/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SocialBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OtterLogoWidget(
                  logoSize: 115,
                  showSlogan: false,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue your Otter.ly journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Login form will be implemented next.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 25),
                PrimaryButton(
                  text: 'Continue',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login functionality is coming next!'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}