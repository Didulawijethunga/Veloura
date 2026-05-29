import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/theme_provider.dart';
import '../utils/auth_provider.dart';
import '../utils/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const VelouraHeader(showBackButton: false),
      body: auth.isLoggedIn ? _LoggedInProfile() : _GuestProfile(),
    );
  }
}

class _LoggedInProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return ListView(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      auth.userName.isNotEmpty
                          ? auth.userName[0].toUpperCase()
                          : 'U',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                auth.userName,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                auth.userEmail,
                style: GoogleFonts.lato(fontSize: 13, color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(label: 'Orders', value: '${cart.orders.length}'),
                  Container(width: 1, height: 36, color: AppColors.lightGrey),
                  _StatChip(
                      label: 'Wishlist', value: '${cart.wishlist.length}'),
                  Container(width: 1, height: 36, color: AppColors.lightGrey),
                  const _StatChip(label: 'Reviews', value: '0'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _MenuSection(
          title: 'Account',
          items: [
            _MenuItem(
              icon: Icons.person_outline,
              label: 'Edit Profile',
              onTap: () => _showEditProfile(context, auth),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              label: 'Delivery Address',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.payment_outlined,
              label: 'Payment Methods',
              onTap: () => _showPaymentMethodsDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MenuSection(
          title: 'Orders',
          items: [
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'My Orders',
              badge: cart.orders.isNotEmpty ? '${cart.orders.length}' : null,
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            _MenuItem(
              icon: Icons.replay_outlined,
              label: 'Returns & Refunds',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MenuSection(
          title: 'Preferences',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () {},
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark Mode',
                  onTap: () =>
                      themeProvider.toggleTheme(!themeProvider.isDarkMode),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(value),
                    activeThumbColor: AppColors.primary,
                  ),
                );
              },
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              label: 'Language',
              onTap: () {},
              value: 'English',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MenuSection(
          title: 'Support',
          items: [
            _MenuItem(
              icon: Icons.help_outline,
              label: 'Help Center',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: Text('Log Out',
                style: GoogleFonts.lato(
                    color: AppColors.error, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showEditProfile(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.userName);
    final emailCtrl = TextEditingController(text: auth.userEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profile',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final err = await auth.updateProfile(
                      nameCtrl.text, emailCtrl.text);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  if (err != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(err)),
                    );
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodsDialog(BuildContext context) {
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
                'Payment Methods',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.payment, color: AppColors.primary),
                title:
                    Text('Visa *1234', style: GoogleFonts.lato(fontSize: 16)),
                trailing:
                    const Icon(Icons.check_circle, color: AppColors.primary),
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: AppColors.primary),
                title: Text('Mastercard *5678',
                    style: GoogleFonts.lato(fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: AppColors.primary),
                title: Text('PayPal', style: GoogleFonts.lato(fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.payment, color: AppColors.primary),
                title: Text('Apple Pay', style: GoogleFonts.lato(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GuestProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.person_outline,
                  size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Join Veloura',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Create an account to enjoy exclusive deals,\ntrack orders, and more.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 14, color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Create Account',
              onPressed: () => Navigator.pushNamed(context, '/register'),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Log In',
                  style: GoogleFonts.lato(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary)),
        Text(label,
            style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey)),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.lato(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey,
                  letterSpacing: 1.2),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final String? value;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style:
                    GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(badge!,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              )
            else if (value != null)
              Text(value!,
                  style: GoogleFonts.lato(fontSize: 13, color: AppColors.grey))
            else if (trailing != null)
              trailing!
            else
              const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
