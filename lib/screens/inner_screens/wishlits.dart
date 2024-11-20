import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/wishlistprovider.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/empty_bag.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../widgets/products/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = '/WishlistScreen';
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    Size size = MediaQuery.of(context).size;
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            title: "Your Wishlist is empty",
            imagepath: AssetsMamager.shoppingBasket,
            subtitle:
                "Looks like you didn't add any thing to your Wishlist \n go ahead start shopping now",
            buttonText: "Shop now",
          ))
        : Scaffold(
            appBar: AppBar(
              title: TitleTextWidget(
                  label:
                      "Wishlist (${wishlistProvider.getWishlistItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsMamager.shoppingCart),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppMethods.showErrorOrWarningDialog(
                          context: context,
                          subtitle: "Clear Wishlist",
                          fct: () async{
                            await wishlistProvider.clearWishlistFromFirebase();
                            wishlistProvider.clearLocalWishlist(); //local 
                          });
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ))
              ],
            ),
            body: DynamicHeightGridView(
                itemCount: wishlistProvider.getWishlistItems.length,
                builder: (context, index) {
                  return ProductWidget(
                    productId: wishlistProvider.getWishlistItems.values
                        .toList()[index]
                        .productId,
                  );
                },
                crossAxisCount: 2),
          );
  }
}
