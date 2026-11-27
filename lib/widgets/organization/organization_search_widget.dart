import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class OrganizationSearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const OrganizationSearchWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search organizations...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.pink,
        ),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.pink),
        ),
      ),
    );
  }
}
