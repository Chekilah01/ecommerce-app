import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomerShellPage extends StatelessWidget {
  const CustomerShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = navigationShell.currentIndex;

    final activeColor = theme.colorScheme.onSurface;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Card(
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
              ),
              
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GNav(
                  rippleColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  hoverColor: theme.colorScheme.primary.withValues(alpha: 0.05),
                  gap: 6,
                  activeColor: activeColor,
                  iconSize: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  duration: const Duration(milliseconds: 300),
                  tabBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  color: inactiveColor,
                  selectedIndex: currentIndex,
                  onTabChange: (index) {
                    _onTap(context, index);
                  },
                  tabs: [
                    GButton(
                      icon: Iconsax.home_copy,
                      leading: Icon(
                        currentIndex == 0 ? Iconsax.home : Iconsax.home_copy,
                        color: currentIndex == 0 ? activeColor : inactiveColor,
                      ),
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.search_outlined,
                      leading: Icon(
                        currentIndex == 1 ? Icons.search : Icons.search_outlined,
                        color: currentIndex == 1 ? activeColor : inactiveColor,
                      ),
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.shopping_cart_outlined,
                      leading: Icon(
                        currentIndex == 2
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: currentIndex == 2 ? activeColor : inactiveColor,
                      ),
                      text: 'Cart',
                    ),
                    GButton(
                      icon: Icons.receipt_long_outlined,
                      leading: Icon(
                        currentIndex == 3
                            ? Icons.receipt_long
                            : Icons.receipt_long_outlined,
                        color: currentIndex == 3 ? activeColor : inactiveColor,
                      ),
                      text: 'Orders',
                    ),
                    GButton(
                      icon: Icons.person_outline,
                      leading: Icon(
                        currentIndex == 4 ? Icons.person : Icons.person_outline,
                        color: currentIndex == 4 ? activeColor : inactiveColor,
                      ),
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}