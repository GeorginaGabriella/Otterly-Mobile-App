import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class OrganizationEmptyWidget extends StatelessWidget {
  const OrganizationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.groups_rounded,
              size: 65,
              color: AppColors.pink,
            ),
            const SizedBox(height: 14),
            const Text(
              'No Organizations Found',
              style: TextStyle(
                color: AppColors.burgundy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Try another keyword or category.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
