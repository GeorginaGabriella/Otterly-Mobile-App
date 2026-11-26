import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ProfileStatsRowWidget extends StatelessWidget {
  final int friendsCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onFriendsTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const ProfileStatsRowWidget({
    super.key,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    this.onFriendsTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  Widget _buildStatCard({
    required String label,
    required int count,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(icon, size: 18, color: AppColors.pink),
                const SizedBox(height: 6),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          label: 'Friends',
          count: friendsCount,
          icon: Icons.people_alt_rounded,
          onTap: onFriendsTap,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          label: 'Followers',
          count: followersCount,
          icon: Icons.favorite_rounded,
          onTap: onFollowersTap,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          label: 'Following',
          count: followingCount,
          icon: Icons.person_pin_circle_rounded,
          onTap: onFollowingTap,
        ),
      ],
    );
  }
}
