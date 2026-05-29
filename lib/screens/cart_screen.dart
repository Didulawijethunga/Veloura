import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onBrowse;
  const CartScreen({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          const VelouraHeader(showBackButton: false, centerTitle: 'My Cart'),
      body: cart.items.isEmpty
          ? _EmptyCart(onBrowse: onBrowse)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartItemTile(
                        item: item,
                        onRemove: () => cart.removeFromCart(index),
                        onDecrement: () =>
                            cart.updateQuantity(index, item.quantity - 1),
                        onIncrement: () =>
                            cart.updateQuantity(index, item.quantity + 1),
                      );
                    },
                  ),
                ),
                _OrderSummary(cart: cart),
              ],
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback? onBrowse;
  const _EmptyCart({this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 80, color: AppColors.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: GoogleFonts.lato(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onBrowse ?? () => Navigator.pushReplacementNamed(context, '/main'),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 90,
                  color: AppColors.accent,
                  child: const Icon(Icons.image_outlined,
                      color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.selectedColor} · ${item.selectedSize}',
                    style:
                        GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: onDecrement,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.remove, size: 14),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('${item.quantity}',
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ),
                            GestureDetector(
                              onTap: onIncrement,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.add,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onRemove,
                        child: const Icon(Icons.delete_outline,
                            color: AppColors.error, size: 22),
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

class _OrderSummary extends StatelessWidget {
  final CartProvider cart;

  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _SummaryRow('Subtotal (${cart.itemCount} items)',
              '\$${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _SummaryRow(
            'Shipping',
            cart.shipping == 0
                ? 'Free'
                : '\$${cart.shipping.toStringAsFixed(2)}',
            valueColor:
                cart.shipping == 0 ? AppColors.success : AppColors.darkGrey,
          ),
          const SizedBox(height: 8),
          _SummaryRow('Tax', '\$${cart.tax.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.lightGrey),
          ),
          _SummaryRow(
            'Total',
            '\$${cart.total.toStringAsFixed(2)}',
            isBold: true,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Proceed to Checkout',
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow(this.label, this.value,
      {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.black : AppColors.grey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.darkGrey,
          ),
        ),
      ],
    );
  }
}
