import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/cart_provider.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const WishlistScreen(),
    CartScreen(onBrowse: () => setState(() => _currentIndex = 0)),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  index: 0,
                  current: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite_rounded,
                  index: 1,
                  current: _currentIndex,
                  badge: context.watch<CartProvider>().wishlist.isNotEmpty
                      ? '${context.watch<CartProvider>().wishlist.length}'
                      : null,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  index: 2,
                  current: _currentIndex,
                  badge: context.watch<CartProvider>().itemCount > 0
                      ? '${context.watch<CartProvider>().itemCount}'
                      : null,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  index: 3,
                  current: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final int index;
  final int current;
  final String? badge;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.current,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.grey,
                size: 26,
              ),
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
