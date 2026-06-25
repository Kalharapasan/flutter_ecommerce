import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';
import 'package:flutter_ecommerce/providers/product_provider.dart';
import 'package:flutter_ecommerce/providers/theme_provider.dart';
import 'package:flutter_ecommerce/providers/user_data_provider.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:flutter_ecommerce/screens/home_screen.dart';
import 'package:flutter_ecommerce/screens/order_detail_screen.dart';
import 'package:flutter_ecommerce/screens/profile_screen.dart';
import 'package:flutter_ecommerce/screens/splash_screen.dart';
import 'package:flutter_ecommerce/utils/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'ShopHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            home: const MainNavigationShell(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/home':
                  return MaterialPageRoute(
                      builder: (_) => const HomeScreen());
                case '/cart':
                  return MaterialPageRoute(
                      builder: (_) => const CartScreen());
                case '/profile':
                  return MaterialPageRoute(
                      builder: (_) => const ProfileScreen());
                case '/splash':
                  return MaterialPageRoute(
                      builder: (_) => const SplashScreen());
                case '/orderDetail':
                  final order = settings.arguments as OrderItem;
                  return MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(order: order),
                  );
                default:
                  return MaterialPageRoute(
                      builder: (_) => const SplashScreen());
              }
            },
          );
        },
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Load persisted cart on startup
    Future.microtask(() => context.read<CartProvider>().loadCart());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
