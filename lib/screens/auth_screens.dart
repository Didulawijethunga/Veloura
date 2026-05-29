import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/auth_provider.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final err = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (err == null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(err),
            backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const VelouraHeader(showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  'VELOURA',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Log in for a more customized experience',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 13, color: AppColors.grey),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email@domain.com',
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?',
                        style: GoogleFonts.lato(
                            color: AppColors.primary, fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                    text: 'Continue', onPressed: _login, isLoading: _loading),
                const SizedBox(height: 20),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('or',
                        style: GoogleFonts.lato(
                            color: AppColors.grey, fontSize: 13)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 16),
                _SocialButton(
                  icon: 'G',
                  label: 'Continue with Google',
                  onTap: () {},
                  color: const Color(0xFF4285F4),
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  icon: 'f',
                  label: 'Continue with Facebook',
                  onTap: () {},
                  color: const Color(0xFF1877F2),
                ),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account? ",
                      style: GoogleFonts.lato(
                          color: AppColors.grey, fontSize: 13)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text('Sign Up',
                        style: GoogleFonts.lato(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 16),
                Text(
                  'By clicking continue, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 11, color: AppColors.grey),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(icon,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Text(label,
                style:
                    GoogleFonts.lato(fontSize: 14, color: AppColors.darkGrey)),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passCtrl.text != _confirmPassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();

    final err = await auth.register(
        _nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (err == null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(err),
            backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const VelouraHeader(showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  'VELOURA',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Join the Community',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create an account to unlock premium features',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 13, color: AppColors.grey),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter your full name' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmPassCtrl,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Confirm your password' : null,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                    text: 'Continue',
                    onPressed: _register,
                    isLoading: _loading),
                const SizedBox(height: 20),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('or',
                        style: GoogleFonts.lato(
                            color: AppColors.grey, fontSize: 13)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 16),
                _SocialButton(
                    icon: 'G',
                    label: 'Continue with Google',
                    onTap: () {},
                    color: const Color(0xFF4285F4)),
                const SizedBox(height: 12),
                _SocialButton(
                    icon: 'f',
                    label: 'Continue with Facebook',
                    onTap: () {},
                    color: const Color(0xFF1877F2)),
                const SizedBox(height: 24),
                Text(
                  'By clicking continue, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 11, color: AppColors.grey),
                ),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Already have an account? ',
                      style: GoogleFonts.lato(
                          color: AppColors.grey, fontSize: 13)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Log In',
                        style: GoogleFonts.lato(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
