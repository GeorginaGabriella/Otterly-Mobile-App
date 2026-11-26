import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/friend_profile_model.dart';

class MutualFriendsSheetWidget extends StatelessWidget {
  final String targetName;
  final List<StudentProfileModel> mutualFriends;
  final ValueChanged<StudentProfileModel> onSelectStudent;

  const MutualFriendsSheetWidget({
    super.key,
    required this.targetName,
    required this.mutualFriends,
    required this.onSelectStudent,
  });

  static Future<void> show(
    BuildContext context, {
    required String targetName,
    required List<StudentProfileModel> mutualFriends,
    required ValueChanged<StudentProfileModel> onSelectStudent,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => MutualFriendsSheetWidget(
        targetName: targetName,
        mutualFriends: mutualFriends,
        onSelectStudent: (student) {
          Navigator.pop(sheetContext);
          onSelectStudent(student);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mutual Friends with $targetName',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${mutualFriends.length} mutual connection${mutualFriends.length == 1 ? '' : 's'} at UNTAR',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            if (mutualFriends.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'No mutual friends yet. Say hi and start connecting!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: mutualFriends.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final friend = mutualFriends[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      tileColor: AppColors.white,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.cream,
                        backgroundImage: AssetImage(friend.avatar),
                      ),
                      title: Text(
                        friend.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      subtitle: Text(
                        '${friend.studyProgram} • ${friend.entryYear}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.burgundy,
                      ),
                      onTap: () => onSelectStudent(friend),
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
