import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    NavigationDestination(
      icon: Icon(Icons.add_box_outlined),
      selectedIcon: Icon(Icons.add_box_rounded),
      label: 'Create',
    ),
    NavigationDestination(
      icon: Icon(Icons.notifications_none),
      selectedIcon: Icon(Icons.notifications),
      label: 'Activity',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.cream,
      destinations: destinations,
    );
  }
}
