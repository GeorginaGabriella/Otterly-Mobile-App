import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SocialBackground extends StatelessWidget {
  final Widget child;

  const SocialBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.cream,
            Color(0xFFFFE4E2),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -65,
            right: -55,
            child: _circle(190, AppColors.yellow.withValues(alpha: 0.3)),
          ),
          Positioned(
            bottom: -70,
            left: -55,
            child: _circle(180, AppColors.coral.withValues(alpha: 0.12)),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
