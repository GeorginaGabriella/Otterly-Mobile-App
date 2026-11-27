import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../providers/social_profile_provider.dart';

class BlockedUsersSheetWidget extends ConsumerStatefulWidget {
  final ValueChanged<String>? onUnblocked;

  const BlockedUsersSheetWidget({
    super.key,
    this.onUnblocked,
  });

  static Future<void> show(
    BuildContext context, {
    ValueChanged<String>? onUnblocked,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlockedUsersSheetWidget(onUnblocked: onUnblocked),
    );
  }

  @override
  ConsumerState<BlockedUsersSheetWidget> createState() =>
      _BlockedUsersSheetWidgetState();
}

class _BlockedUsersSheetWidgetState
    extends ConsumerState<BlockedUsersSheetWidget> {
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    final blocked = ref.watch(socialProfileProvider).blockedUsers;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blocked Users',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage accounts you have blocked on Otter.ly.',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            if (blocked.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 36,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No Blocked Users',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Users you block will appear here.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: blocked.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final student = blocked[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      tileColor: AppColors.white,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.cream,
                        child: ClipOval(
                          child: Image.asset(
                            student.avatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.pets,
                              color: AppColors.burgundy,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        student.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text('@${student.username}'),
                      trailing: TextButton(
                        onPressed: () async {
                          await ref
                              .read(socialProfileProvider.notifier)
                              .unblockUser(student.id);
                          if (!mounted) return;
                          setState(() {
                            _statusMessage = 'Unblocked ${student.fullName}.';
                          });
                          widget.onUnblocked?.call(student.fullName);
                        },
                        child: const Text(
                          'Unblock',
                          style: TextStyle(
                            color: AppColors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
