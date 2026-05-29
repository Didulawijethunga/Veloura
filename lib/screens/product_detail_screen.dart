import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cart = context.watch<CartProvider>();
    final isWishlisted = cart.isInWishlist(product);

    _selectedSize ??= product.sizes.first;
    _selectedColor ??= product.colors.first;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: AppColors.black,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.accent,
                      child: const Icon(Icons.image_outlined,
                          size: 80, color: AppColors.primary),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.white, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_outline,
                  color: isWishlisted ? Colors.red : AppColors.black,
                ),
                onPressed: () => cart.toggleWishlist(product),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brand,
                              style: GoogleFonts.lato(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                          if (product.isOnSale)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.grey),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < product.rating.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 18,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating} (${product.reviewCount} reviews)',
                        style: GoogleFonts.lato(
                            fontSize: 13, color: AppColors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _Divider(),
                  const SizedBox(height: 16),
                  Text('Color',
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: product.colors
                        .map((color) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _selectedColor == color
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedColor == color
                                        ? AppColors.primary
                                        : AppColors.lightGrey,
                                  ),
                                ),
                                child: Text(
                                  color,
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: _selectedColor == color
                                        ? Colors.white
                                        : AppColors.darkGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Size',
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: product.sizes
                        .map((size) => GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _selectedSize == size
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _selectedSize == size
                                        ? AppColors.primary
                                        : AppColors.lightGrey,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedSize == size
                                          ? Colors.white
                                          : AppColors.darkGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  _Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Quantity',
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black)),
                      const Spacer(),
                      _QuantityControl(
                        quantity: _quantity,
                        onDecrement: () => setState(() {
                          if (_quantity > 1) _quantity--;
                        }),
                        onIncrement: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Divider(),
                  const SizedBox(height: 16),
                  Text('Description',
                      style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.lato(
                        fontSize: 14, color: AppColors.grey, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total',
                    style:
                        GoogleFonts.lato(fontSize: 12, color: AppColors.grey)),
                Text(
                  '\$${(product.price * _quantity).toStringAsFixed(2)}',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cart.addToCart(product, _selectedSize!, _selectedColor!);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'View Cart',
                        textColor: Colors.white,
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(color: AppColors.lightGrey, height: 1);
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _QBtn(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$quantity',
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          _QBtn(icon: Icons.add, onTap: onIncrement, filled: true),
        ],
      ),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 18, color: filled ? Colors.white : AppColors.darkGrey),
      ),
    );
  }
}
