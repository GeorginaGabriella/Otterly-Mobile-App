import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';

class OtterLogoWidget extends StatelessWidget {
  final double logoSize;
  final bool showSlogan;

  const OtterLogoWidget({
    super.key,
    this.logoSize = 110,
    this.showSlogan = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppConstants.logoPath,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.pets,
              size: logoSize * 0.7,
              color: AppColors.burgundy,
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appName,
          style: const TextStyle(
            fontFamily: 'BukhariScript',
            fontSize: 38,
            color: AppColors.burgundy,
          ),
        ),
        if (showSlogan) ...[
          const SizedBox(height: 4),
          const Text(
            AppConstants.slogan,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}