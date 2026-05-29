import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl, curve: const Interval(0, 0.65, curve: Curves.easeOut)),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.15, 0.75, curve: Curves.easeOut)),
    );
    _ctrl.forward();

  }

  void _navigate() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF9B30D9),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              children: [
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        Text(
                          'VELOURA',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 46,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Where Elegance Becomes You',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.88),
                            letterSpacing: 0.8,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SizedBox(
                    width: 220,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _navigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF72FB),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Let's Start",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
