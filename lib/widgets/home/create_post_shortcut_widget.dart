import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CreatePostShortcutWidget extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;
  final VoidCallback? onPhotoTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onLocationTap;

  const CreatePostShortcutWidget({
    super.key,
    required this.userName,
    required this.onTap,
    this.onPhotoTap,
    this.onVideoTap,
    this.onLocationTap,
  });

  Widget _buildShortcutChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.yellow,
                child: Icon(Icons.person, color: AppColors.burgundy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'What’s on your mind, $userName?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Add photo',
                onPressed: onPhotoTap ?? onTap,
                icon: const Icon(Icons.image_outlined, color: AppColors.pink),
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.border),
          Row(
            children: [
              _buildShortcutChip(
                icon: Icons.photo_library_rounded,
                label: 'Photo',
                color: AppColors.pink,
                onPressed: onPhotoTap ?? onTap,
              ),
              Container(width: 1, height: 18, color: AppColors.border),
              _buildShortcutChip(
                icon: Icons.videocam_rounded,
                label: 'Video',
                color: AppColors.coral,
                onPressed: onVideoTap ?? onTap,
              ),
              Container(width: 1, height: 18, color: AppColors.border),
              _buildShortcutChip(
                icon: Icons.location_on_rounded,
                label: 'Location',
                color: AppColors.burgundy,
                onPressed: onLocationTap ?? onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
