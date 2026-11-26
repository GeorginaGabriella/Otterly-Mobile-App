import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/social_profile_provider.dart';
import '../../widgets/media/post_composer_sheet.dart';
import '../friends/friends_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'Home',
    'Search',
    'Create',
    'Activity',
    'Profile',
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.add_circle_outline_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // AppBar disembunyikan pada Home karena HomeScreen
      // sudah memiliki tampilan header sendiri.
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  color: AppColors.burgundy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (_selectedIndex == 4) ...[
                  _buildFriendsButton(),
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.burgundy,
                    ),
                    onPressed: _showLogoutDialog,
                  ),
                ],
              ],
            ),

      // Tampilkan HomeScreen Garini ketika tab Home dipilih,
      // PostComposerSheet pada tab Create,
      // dan ProfileScreen Felicia ketika tab Profile dipilih.
      body: _selectedIndex == 0
          ? const HomeScreen()
          : _selectedIndex == 2
              ? PostComposerSheet(
                  authorName: user?.fullName ?? 'Otter Friend',
                  authorAvatar: user?.avatar ?? AppConstants.pinkAvatarPath,
                  asFullPage: true,
                  onPublish: (result) async {
                    final messenger = ScaffoldMessenger.of(context);
                    final activeUser = user ?? buildFallbackDemoUser();
                    await ref
                        .read(socialProfileProvider.notifier)
                        .addProfilePost(
                          author: activeUser,
                          category: result.category,
                          content: result.content,
                          location: result.location,
                          audience: result.audience,
                          imagePaths: result.imagePaths,
                          videoPath: result.videoPath,
                        );
                    if (!mounted) return;
                    setState(() {
                      _selectedIndex = 0;
                    });
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Postingan berhasil dipublikasikan!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                )
              : _selectedIndex == 4
                  ? const ProfileScreen(showAppBar: false)
                  : _buildPlaceholder(user),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsButton() {
    final pendingCount =
        ref.watch(socialProfileProvider).incomingRequests.length;

    return IconButton(
      tooltip: 'Friends & Requests',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FriendsScreen(
              initialTabIndex: pendingCount > 0 ? 1 : 0,
            ),
          ),
        );
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.people_outline_rounded,
            color: AppColors.burgundy,
          ),
          if (pendingCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '$pendingCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Placeholder untuk halaman yang belum diintegrasikan.
  Widget _buildPlaceholder(user) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icons[_selectedIndex], size: 65, color: AppColors.pink),

            const SizedBox(height: 20),

            const Text(
              'Welcome to Otter.ly!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.burgundy,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user == null
                  ? 'Welcome to ${_titles[_selectedIndex]}'
                  : 'Hello, ${user.fullName}!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 12),

            Text(
              '${_titles[_selectedIndex]} page is ready.',
              style: const TextStyle(color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text(
            'Logout',
            style: TextStyle(
              color: AppColors.burgundy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);

                await ref.read(authProvider.notifier).logout();

                if (!mounted) return;

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
