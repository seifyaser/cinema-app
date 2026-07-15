import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../widgets/liquid_glass_navbar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  void _onBranchSelected(int index) {
    navigationShell.goBranch(
      index,
      // Support navigating to the initial location when tapping the item that is already active
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          // Base layer: The active screen
          navigationShell,

          // Floating Liquid Glass Navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LiquidGlassNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onBranchSelected,
              items: [
                NavBarItem(icon: CupertinoIcons.home, label: 'Home'),
                NavBarItem(icon: CupertinoIcons.search, label: 'Search'),
                NavBarItem(icon: CupertinoIcons.ticket_fill, label: 'Tickets'),
                NavBarItem(
                  icon: CupertinoIcons.person_crop_circle,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
