import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          const VelouraHeader(showBackButton: true, centerTitle: 'My Orders'),
      body: cart.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 80,
                      color: AppColors.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No orders yet',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Your completed orders will appear here',
                      style: GoogleFonts.lato(
                          fontSize: 14, color: AppColors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.orders.length,
              itemBuilder: (context, i) => _OrderCard(order: cart.orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status,
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _formatDate(order.date),
              style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.lightGrey, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                ...order.items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    )),
                if (order.items.length > 3)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('+${order.items.length - 3}',
                          style: GoogleFonts.lato(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total',
                        style: GoogleFonts.lato(
                            fontSize: 11, color: AppColors.grey)),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Delivery: ${order.deliveryAddress}',
                style: GoogleFonts.lato(fontSize: 11, color: AppColors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
