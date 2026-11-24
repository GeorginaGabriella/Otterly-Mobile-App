import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AvatarSelector extends StatelessWidget {
  final String selectedAvatar;
  final ValueChanged<String> onChanged;

  const AvatarSelector({
    super.key,
    required this.selectedAvatar,
    required this.onChanged,
  });

  static const List<String> avatars = [
    'assets/images/otter_pink.png',
    'assets/images/otter_blue.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Otter Avatar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: avatars.map((avatar) {
            final isSelected = selectedAvatar == avatar;

            return GestureDetector(
              onTap: () => onChanged(avatar),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(5),
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.pink
                        : AppColors.border,
                    width: isSelected ? 3 : 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        avatar,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (isSelected)
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.pink,
                          child: Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 17,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Choose your favorite character!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
