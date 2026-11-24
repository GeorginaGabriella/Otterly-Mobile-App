import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingIndicator({
    super.key,
    required this.currentPage,
    this.pageCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final bool isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.pink
                : AppColors.cream,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
