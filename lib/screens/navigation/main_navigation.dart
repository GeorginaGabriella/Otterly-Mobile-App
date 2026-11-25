import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

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
                if (_selectedIndex == 4)
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.burgundy,
                    ),
                    onPressed: _showLogoutDialog,
                  ),
              ],
            ),

      // Tampilkan HomeScreen Garini ketika tab Home dipilih.
      body: _selectedIndex == 0 ? const HomeScreen() : _buildPlaceholder(user),

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
