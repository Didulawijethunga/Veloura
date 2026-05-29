import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../utils/theme.dart';

class VelouraHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? centerTitle;
  final List<Widget>? actions;

  const VelouraHeader({
    super.key,
    this.showBackButton = false,
    this.centerTitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (!showBackButton)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                ),
                child: const ClipOval(
                  child: Icon(Icons.person, color: AppColors.primary, size: 22),
                ),
              )
            else
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.chevron_left,
                    size: 28, color: AppColors.black),
              ),
            const Spacer(),
            if (centerTitle != null)
              Text(
                centerTitle!,
                style: GoogleFonts.lato(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              )
            else
              Text(
                'VELOURA',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 3,
                ),
              ),
            const Spacer(),
            const Icon(Icons.notifications_outlined,
                color: AppColors.black, size: 24),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.lightGrey),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class VelouraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showLogo;
  final bool automaticallyImplyLeading;

  const VelouraAppBar({
    super.key,
    this.title,
    this.actions,
    this.showLogo = false,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return VelouraHeader(
      showBackButton: automaticallyImplyLeading,
      centerTitle: showLogo ? null : title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class VelouraBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VelouraBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite_rounded,
                  index: 1,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  index: 2,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  index: 3,
                  current: currentIndex,
                  onTap: onTap),
            ],
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
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isActive ? activeIcon : icon,
            key: ValueKey(isActive),
            color: isActive ? AppColors.primary : AppColors.grey,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onWishlist;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlist,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.accent,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.primary, size: 48),
                      ),
                    ),
                  ),
                  if (product.isOnSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercent.round()}%',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlist,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4)
                          ],
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 18,
                          color: isWishlisted ? Colors.red : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${product.rating}',
                        style: GoogleFonts.lato(
                            fontSize: 11, color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
