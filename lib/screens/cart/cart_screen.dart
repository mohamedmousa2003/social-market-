import 'package:provider/provider.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/screens/cart/cart_widget.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/empty_bag.dart';
import 'package:social_market/widgets/title_text.dart';

import 'bottom_checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            title: "Your cart is empty",
            imagepath: AssetsMamager.shoppingBasket,
            subtitle:
                "Looks like you didn't add any thing to your cart \n go ahead start shopping now",
            buttonText: "Shop now",
          ))
        : Scaffold(
            appBar: AppBar(
              title: TitleTextWidget(
                  label: "Cart (${cartProvider.getCartItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsMamager.shoppingCart),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppMethods.showErrorOrWarningDialog(
                          context: context,
                          subtitle: "Clear Cart",
                          fct: () async{
                            // cartProvider.clearLocalCart();
                           await cartProvider.clearCartFromFirebase();
                          });
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ))
              ],
            ),
            bottomSheet: const CartBottomCheckout(),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cartProvider.getCartItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartProvider.getCartItems.values
                                .toList()
                                .reversed
                                .toList()[index],
                            child: CartWidget());
                      }),
                ),
                SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                ),
              ],
            ),
          );
  }
}
