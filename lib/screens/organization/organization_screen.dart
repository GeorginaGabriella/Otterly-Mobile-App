import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/organization_data.dart';
import '../../models/organization_model.dart';
import '../../widgets/organization/organization_card_widget.dart';
import '../../widgets/organization/organization_category_widget.dart';
import '../../widgets/organization/organization_empty_widget.dart';
import '../../widgets/organization/organization_search_widget.dart';
import 'organization_detail_screen.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = const [
    'All',
    'Student Government',
    'Academic',
    'Creative',
    'Sports',
    'Language',
  ];

  late List<OrganizationModel> organizations;

  @override
  void initState() {
    super.initState();
    organizations =
        List<OrganizationModel>.from(OrganizationData.organizations);
  }

  List<OrganizationModel> get filteredOrganizations {
    return organizations.where((organization) {
      final matchesCategory = selectedCategory == 'All' ||
          organization.category == selectedCategory;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          organization.name.toLowerCase().contains(query) ||
          organization.category.toLowerCase().contains(query) ||
          organization.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleJoin(OrganizationModel organization) {
    setState(() {
      final index =
          organizations.indexWhere((item) => item.id == organization.id);

      if (index == -1) return;

      final current = organizations[index];
      final joining = !current.isJoined;

      organizations[index] = current.copyWith(
        isJoined: joining,
        members: current.members + (joining ? 1 : -1),
      );
    });
  }

  Future<void> _openOrganization(
    OrganizationModel organization,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OrganizationDetailScreen(
          organization: organization,
          onJoin: () => _toggleJoin(organization),
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredOrganizations;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organizations',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Find your community and grow together!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  OrganizationSearchWidget(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  OrganizationCategoryWidget(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onSelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Explore Organizations (${results.length})',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const OrganizationEmptyWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final organization = results[index];

                        return OrganizationCardWidget(
                          organization: organization,
                          onTap: () => _openOrganization(organization),
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
