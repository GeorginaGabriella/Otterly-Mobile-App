import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class EventEmptyWidget extends StatelessWidget {
  const EventEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_busy_rounded,
              size: 65,
              color: AppColors.pink,
            ),
            const SizedBox(height: 14),
            const Text(
              'No Events Found',
              style: TextStyle(
                color: AppColors.burgundy,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Try searching with another keyword or category.',
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
