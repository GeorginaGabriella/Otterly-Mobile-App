import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class ProfilePrivacyTileWidget extends StatelessWidget {
  final bool isPrivateAccount;
  final bool allowRequestsFromMutualsOnly;
  final bool showActivityStatus;
  final int blockedCount;
  final ValueChanged<bool> onPrivateAccountChanged;
  final ValueChanged<bool> onMutualsOnlyChanged;
  final ValueChanged<bool> onActivityStatusChanged;
  final VoidCallback onManageBlockedUsers;

  const ProfilePrivacyTileWidget({
    super.key,
    required this.isPrivateAccount,
    required this.allowRequestsFromMutualsOnly,
    required this.showActivityStatus,
    required this.blockedCount,
    required this.onPrivateAccountChanged,
    required this.onMutualsOnlyChanged,
    required this.onActivityStatusChanged,
    required this.onManageBlockedUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.burgundy, size: 20),
              SizedBox(width: 8),
              Text(
                'Account Privacy',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.pink,
            value: isPrivateAccount,
            onChanged: onPrivateAccountChanged,
            title: const Text(
              'Private Profile',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            subtitle: const Text(
              'Only approved friends can view your posts and full NIM.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 8, color: AppColors.border),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.pink,
            value: allowRequestsFromMutualsOnly,
            onChanged: onMutualsOnlyChanged,
            title: const Text(
              'Friend Requests from Mutuals Only',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            subtitle: const Text(
              'Limit incoming requests to students sharing mutual friends.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 8, color: AppColors.border),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.pink,
            value: showActivityStatus,
            onChanged: onActivityStatusChanged,
            title: const Text(
              'Show Active Campus Status',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            subtitle: const Text(
              'Let friends see when you are active on Otter.ly.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 8, color: AppColors.border),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: onManageBlockedUsers,
            leading: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.cream,
              child: Icon(
                Icons.block_rounded,
                size: 18,
                color: AppColors.burgundy,
              ),
            ),
            title: const Text(
              'Blocked Users',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            subtitle: Text(
              blockedCount == 0
                  ? 'No blocked students'
                  : '$blockedCount blocked student${blockedCount > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
