import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';
import '../utils/auth_provider.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Woman', 'Men', 'Kids', 'Accessories'];

  List<Product> _buildProductList(ProductProvider pp) {
    return pp.searchInCategory(_selectedCategory, _searchQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pp = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HomeAppBarDelegate(context),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'SALE : Now Up To 50% OFF',
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Our Exclusive Selections',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.isLoggedIn
                            ? 'Welcome back, ${auth.userName.isNotEmpty ? auth.userName : 'User'}'
                            : 'Log in for a more customized experience',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 14, color: AppColors.grey, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.search, color: AppColors.black, size: 22),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: GoogleFonts.lato(
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(bottom: 2),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9B30D9), // primary color
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Category tabs
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    itemBuilder: (context, i) {
                      final cat = _categories[i];
                      final selected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.lightGrey),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.darkGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Product grid
          if (pp.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            _buildProductGrid(context, _buildProductList(pp)),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off,
                  size: 64,
                  color: AppColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 12),
              Text('No products found',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ProductCard(product: products[index]),
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
      ),
    );
  }
}

// ─── Home AppBar ─────────────────────────────────────────────────────────────

class _HomeAppBarDelegate extends SliverPersistentHeaderDelegate {
  final BuildContext ctx;
  const _HomeAppBarDelegate(this.ctx);

  @override
  double get minExtent => kToolbarHeight + 1;
  @override
  double get maxExtent => kToolbarHeight + 1;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final cart = context.watch<CartProvider>();
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                      border: Border.all(
                          color: AppColors.primaryLight, width: 1.5),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'VELOURA',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined,
                        color: AppColors.black, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: AppColors.lightGrey),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}


// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inWishlist = cart.isInWishlist(product);

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/product', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.accent,
                        child: const Icon(Icons.image_not_supported,
                            color: AppColors.grey),
                      ),
                    ),
                  ),
                  if (product.isOnSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                            '-${product.discountPercent.round()}%',
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => cart.toggleWishlist(product),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          inWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: inWishlist
                              ? AppColors.error
                              : AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand,
                        style: GoogleFonts.lato(
                            fontSize: 10, color: AppColors.grey)),
                    const SizedBox(height: 2),
                    Text(product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black)),
                    const Spacer(),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        if (product.isOnSale) ...[
                          const SizedBox(width: 4),
                          Text(
                            '\$${product.originalPrice!.toStringAsFixed(2)}',
                            style: GoogleFonts.lato(
                                fontSize: 10,
                                color: AppColors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: Color(0xFFFFC107)),
                        const SizedBox(width: 2),
                        Text(product.rating.toStringAsFixed(1),
                            style: GoogleFonts.lato(
                                fontSize: 10, color: AppColors.grey)),
                        Text(' (${product.reviewCount})',
                            style: GoogleFonts.lato(
                                fontSize: 10, color: AppColors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
