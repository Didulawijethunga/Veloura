import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';
import '../widgets/widgets.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          const VelouraHeader(showBackButton: false, centerTitle: 'Wishlist'),
      body: cart.wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline,
                      size: 80,
                      color: AppColors.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save items you love',
                    style:
                        GoogleFonts.lato(fontSize: 14, color: AppColors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: cart.wishlist.length,
              itemBuilder: (context, index) {
                final product = cart.wishlist[index];
                return ProductCard(
                  product: product,
                  isWishlisted: true,
                  onWishlist: () => cart.toggleWishlist(product),
                  onTap: () => Navigator.pushNamed(context, '/product',
                      arguments: product),
                );
              },
            ),
    );
  }
}
