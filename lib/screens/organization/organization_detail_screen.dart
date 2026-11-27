import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/organization_model.dart';

class OrganizationDetailScreen extends StatefulWidget {
  final OrganizationModel organization;
  final VoidCallback onJoin;

  const OrganizationDetailScreen({
    super.key,
    required this.organization,
    required this.onJoin,
  });

  @override
  State<OrganizationDetailScreen> createState() =>
      _OrganizationDetailScreenState();
}

class _OrganizationDetailScreenState
    extends State<OrganizationDetailScreen> {
  late bool isJoined;

  @override
  void initState() {
    super.initState();
    isJoined = widget.organization.isJoined;
  }

  void _handleJoin() {
    widget.onJoin();

    setState(() {
      isJoined = !isJoined;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isJoined
              ? 'You joined ${widget.organization.name}!'
              : 'You left ${widget.organization.name}.',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final organization = widget.organization;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.burgundy,
        elevation: 0,
        title: const Text(
          'Organization Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColors.burgundy,
                size: 85,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              organization.category,
              style: const TextStyle(
                color: AppColors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              organization.name,
              style: const TextStyle(
                color: AppColors.burgundy,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _infoRow(
              Icons.people_outline_rounded,
              '${organization.members} members',
            ),
            _infoRow(
              Icons.location_on_outlined,
              organization.location,
            ),
            const SizedBox(height: 24),
            _section('About Organization', organization.description),
            _section('Vision', organization.vision),
            _section('Activities', organization.activities),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isJoined ? AppColors.textSecondary : AppColors.pink,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isJoined ? 'Leave Organization' : 'Join Organization',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(icon, color: AppColors.pink, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
