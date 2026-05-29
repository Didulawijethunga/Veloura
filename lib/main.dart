import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/theme.dart';
import 'utils/theme_provider.dart';
import 'utils/cart_provider.dart';
import 'utils/auth_provider.dart';
import 'providers/product_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/main_shell.dart';
import 'screens/product_detail_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/orders_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VelouraApp());
}

class VelouraApp extends StatelessWidget {
  const VelouraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            cart!.setUserId(auth.userId);
            return cart;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Veloura',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.theme,
            darkTheme: AppTheme.darkTheme,
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/main': (_) => const MainShell(),
              '/product': (_) => const ProductDetailScreen(),
              '/checkout': (_) => const CheckoutScreen(),
              '/orders': (_) => const OrdersScreen(),
            },
          );
        },
      ),
    );
  }
}
