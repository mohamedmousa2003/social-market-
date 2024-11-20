import 'package:social_market/screens/cart/cart_widget.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:social_market/widgets/empty_bag.dart';
import 'package:social_market/widgets/title_text.dart';

import 'orders_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routName = '/OrdersScreen';

  const OrdersScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            title: "Your Order list empty",
            imagepath: AssetsMamager.shoppingBasket,
            subtitle:
                "Looks like you didn't add any thing to your list \n go ahead start shopping now",
            buttonText: "Shop now",
          ))
        : Scaffold(
            appBar: AppBar(
              title: TitleTextWidget(label: "Orders "),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsMamager.shoppingCart),
              ),
            ),
            body: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return const OrdersWidget();
                }),
          );
  }
}
