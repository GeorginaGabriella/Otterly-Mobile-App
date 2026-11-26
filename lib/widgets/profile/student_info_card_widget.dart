import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class StudentInfoCardWidget extends StatelessWidget {
  final String faculty;
  final String studyProgram;
  final String entryYear;
  final String nim;
  final bool isVerified;
  final bool hideSensitiveNim;

  const StudentInfoCardWidget({
    super.key,
    required this.faculty,
    required this.studyProgram,
    required this.entryYear,
    required this.nim,
    this.isVerified = false,
    this.hideSensitiveNim = false,
  });

  String _maskedNim(String rawNim) {
    if (!hideSensitiveNim || rawNim.length < 4) return rawNim;
    return '${rawNim.substring(0, 3)}••••${rawNim.substring(rawNim.length - 2)}';
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.cream.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.burgundy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Student Information',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isVerified
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVerified
                          ? Icons.verified_user_rounded
                          : Icons.school_outlined,
                      size: 13,
                      color:
                          isVerified ? AppColors.success : AppColors.burgundy,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isVerified ? 'Verified Student' : 'UNTAR Student',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            isVerified ? AppColors.success : AppColors.burgundy,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _infoTile(
            icon: Icons.account_balance_outlined,
            label: 'Faculty',
            value: faculty,
          ),
          const SizedBox(height: 12),
          _infoTile(
            icon: Icons.menu_book_rounded,
            label: 'Study Program',
            value: '$studyProgram • Angkatan $entryYear',
          ),
          const SizedBox(height: 12),
          _infoTile(
            icon: Icons.badge_outlined,
            label: 'Student ID (NIM)',
            value: _maskedNim(nim),
          ),
        ],
      ),
    );
  }
}
