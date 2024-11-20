import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_market/consts/theme_data.dart';
import 'package:social_market/provider/them_provider.dart';
import 'package:social_market/root_screen.dart';
import 'package:social_market/screens/auth/forgot_password.dart';
import 'package:social_market/screens/auth/login_screen.dart';
import 'package:social_market/screens/auth/register.dart';
import 'package:social_market/screens/inner_screens/orders/orders_screen.dart';
import 'package:social_market/screens/inner_screens/product_details.dart';
import 'package:social_market/screens/inner_screens/viewed_recently.dart';
import 'package:social_market/screens/inner_screens/wishlits.dart';
import 'package:social_market/screens/search_screen.dart';
import 'package:social_market/screens/splash/splash_screen.dart';
import 'provider/cart_provider.dart';
import 'provider/product_provider.dart';
import 'provider/user_provider.dart';
import 'provider/viewed_prod_provider.dart';
import 'provider/wishlistprovider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: SelectableText("An Error ${snapshot.error}")),
              );
            }
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return ThemeProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return ProductProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return CartProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return WishlistProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return ViewedProdProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return UserProvider();
                }),
      
              ],
              child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'shop Smart',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const SplashScreen(),
                  // home: LoginScreen(),
                  routes: {
                     SplashScreen.routeName: (context) => const SplashScreen(),
                    ProductDetails.routName: (context) => const ProductDetails(),
                    WishlistScreen.routName: (context) => const WishlistScreen(),
                    ViewedRecentlyScreen.routName: (context) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routName: (context) => const RegisterScreen(),
                    OrdersScreen.routName: (context) => const OrdersScreen(),
                    LoginScreen.routName: (context) => const LoginScreen(),
                    ForgotPassword.routName: (context) => const ForgotPassword(),
                    SearchScreen.routName: (context) => const SearchScreen(),
                    RootScreen.routName: (context) => const RootScreen(),
      
                  },
                );
              }),
            );
          }),
    );
  }
}


