import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/cart_provider.dart';
import '../widgets/widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressCtrl = TextEditingController(text: '123 Main Street, City');
  String _paymentMethod = 'Visa *1234';
  final String _promoCode = '';
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) return;

    setState(() => _isPlacingOrder = true);
    await Future.delayed(const Duration(seconds: 1));
    await cart.placeOrder(_addressCtrl.text);
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Order Placed!',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully. We will notify you once it is shipped.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 13, color: AppColors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          const VelouraHeader(showBackButton: true, centerTitle: 'Checkout'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'SHIPPING',
            trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
            child: GestureDetector(
              onTap: () => _showEditDialog('Shipping Address', _addressCtrl),
              child: Text(
                _addressCtrl.text,
                style: GoogleFonts.lato(fontSize: 14, color: AppColors.grey),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'DELIVERY',
            trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Free',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success)),
                Text('Standard | 3-4 days',
                    style:
                        GoogleFonts.lato(fontSize: 12, color: AppColors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'PAYMENT',
            trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
            child: GestureDetector(
              onTap: _showPaymentMethodPicker,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F71),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('VISA',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    Text(_paymentMethod,
                        style: GoogleFonts.lato(
                            fontSize: 14, color: AppColors.grey)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'PROMOS',
            trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Apply promo code',
                style: GoogleFonts.lato(
                    fontSize: 14,
                    color: _promoCode.isEmpty
                        ? AppColors.grey
                        : AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Items (${cart.itemCount})',
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 50,
                                height: 50,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    '${item.selectedSize} · Qty: ${item.quantity}',
                                    style: GoogleFonts.lato(
                                        fontSize: 11, color: AppColors.grey)),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _PriceRow('Subtotal (${cart.itemCount})',
                    '\$${cart.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _PriceRow(
                    'Shipping total',
                    cart.shipping == 0
                        ? 'Free'
                        : '\$${cart.shipping.toStringAsFixed(2)}',
                    valueColor: AppColors.success),
                const SizedBox(height: 8),
                _PriceRow('Taxes', '\$${cart.tax.toStringAsFixed(2)}'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.lightGrey),
                ),
                _PriceRow('Total', '\$${cart.total.toStringAsFixed(2)}',
                    isBold: true, valueColor: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Place Order',
            onPressed: _placeOrder,
            isLoading: _isPlacingOrder,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showEditDialog(String title, TextEditingController ctrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  void _showPaymentMethodPicker() {
    final paymentMethods = [
      'Visa *1234',
      'Mastercard *5678',
      'PayPal',
      'Apple Pay'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Payment Method',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...paymentMethods.map((method) => ListTile(
                    leading:
                        const Icon(Icons.payment, color: AppColors.primary),
                    title: Text(method, style: GoogleFonts.lato(fontSize: 16)),
                    trailing: _paymentMethod == method
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _paymentMethod = method;
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey,
                        letterSpacing: 1.2)),
                const SizedBox(height: 6),
                child,
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow(this.label, this.value,
      {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: isBold ? AppColors.black : AppColors.grey)),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: isBold ? 16 : 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? AppColors.darkGrey)),
      ],
    );
  }
}
