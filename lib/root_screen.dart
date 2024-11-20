
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/provider/wishlistprovider.dart';
import 'package:social_market/screens/cart/cart_screen.dart';
import 'package:social_market/screens/home_screen.dart';
import 'package:social_market/screens/profile_screen.dart';
import 'package:social_market/screens/search_screen.dart';

class RootScreen extends StatefulWidget {
  static const routName = '/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  bool _isLoadingProds=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }
  Future<void> fetchFCT()async{
    final productsProvider = Provider.of<ProductProvider>(context,listen: false);
    final cartProvider = Provider.of<CartProvider>(context ,listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context ,listen: false);
    try{
      Future.wait({
        productsProvider.fetchProducts(),
        wishlistProvider.fetchWishlist(),
      });
      Future.wait({cartProvider.fetchCart()});
    }catch(error){
      log(error.toString());
    }finally{
setState(() {
  _isLoadingProds=false;

});    }
  }
@override
  void didChangeDependencies() {
    if(_isLoadingProds){
      fetchFCT();
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        elevation: 0,
        height: kBottomNavigationBarHeight,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
         const  NavigationDestination(
              selectedIcon: Icon(IconlyBold.home),
              icon: Icon(IconlyLight.home),
              label: 'Home'),
         const NavigationDestination(
              selectedIcon: Icon(IconlyBold.search),
              icon: Icon(IconlyLight.search),
              label: 'Search'),
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.bag2),
              icon: Badge(
                label: Text("${cartProvider.getCartItems.length}"),
                child: Icon(IconlyLight.bag2),
              ),
              label: 'Cart'),
         const NavigationDestination(
              selectedIcon: Icon(IconlyBold.profile),
              icon: Icon(IconlyLight.profile),
              label: 'Profile'),
        ],
      ),
    );
  }
}


