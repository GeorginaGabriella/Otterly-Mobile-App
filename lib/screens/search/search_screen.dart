import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../providers/social_profile_provider.dart';
import '../events/event_screen.dart';
import '../organization/organization_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Students',
    'Posts',
    'Events',
    'Organizations',
  ];

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialProfileProvider);
    final students = socialState.filteredDirectory;

    final showStudents =
        selectedCategory == 'All' || selectedCategory == 'Students';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Find your friends and campus community!',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  TextField(
                    onChanged: (value) {
                      ref
                          .read(socialProfileProvider.notifier)
                          .updateSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search name, username, NIM...',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.pink,
                      ),
                      suffixIcon: socialState.searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                ref
                                    .read(socialProfileProvider.notifier)
                                    .clearFilters();
                              },
                              icon: const Icon(Icons.close_rounded),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                        borderSide: const BorderSide(
                          color: AppColors.pink,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search categories
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      if (category == 'Events') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventsScreen(),
                          ),
                        );
                      } else if (category == 'Organizations') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrganizationScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                    selectedColor: AppColors.pink,
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Results title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                showStudents
                    ? socialState.searchQuery.isEmpty
                          ? 'Suggested Students'
                          : 'Search Results (${students.length})'
                    : selectedCategory,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),

            // Search results
            Expanded(
              child: !showStudents
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedCategory == 'Posts'
                                ? Icons.article_outlined
                                : selectedCategory == 'Events'
                                ? Icons.event_outlined
                                : Icons.groups_outlined,
                            size: 55,
                            color: AppColors.pink,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$selectedCategory coming soon!',
                            style: const TextStyle(
                              color: AppColors.burgundy,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'This feature is currently being developed.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : socialState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.pink),
                    )
                  : students.isEmpty
                  ? const Center(
                      child: Text(
                        'No students found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        return Card(
                          color: AppColors.white,
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.cream,
                              backgroundImage: student.avatar.isNotEmpty
                                  ? AssetImage(student.avatar)
                                  : null,
                              child: student.avatar.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: AppColors.burgundy,
                                    )
                                  : null,
                            ),
                            title: Text(
                              student.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                '@${student.username}\n'
                                '${student.faculty}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            isThreeLine: true,
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: AppColors.pink,
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
