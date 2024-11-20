import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/viewed_prod_provider.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:social_market/widgets/empty_bag.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../widgets/products/product_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = '/ViewedRecentlyScreen';
  const ViewedRecentlyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProdProvider>(context);

    Size size = MediaQuery.of(context).size;
    return viewedProvider.getViewedItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            title: "Your Viewed recently is empty",
            imagepath: AssetsMamager.shoppingBasket,
            subtitle:
                "Looks like you didn't add any thing to your Viewed list \n go ahead start shopping now",
            buttonText: "Shop now",
          ))
        : Scaffold(
            appBar: AppBar(
              title: TitleTextWidget(
                  label:
                      "Viewed Recently (${viewedProvider.getViewedItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsMamager.shoppingCart),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ))
              ],
            ),
            body: DynamicHeightGridView(
                itemCount: viewedProvider.getViewedItems.length,
                builder: (context, index) {
                  return ProductWidget(
                    productId: viewedProvider.getViewedItems.values
                        .toList()[index]
                        .productId,
                  );
                },
                crossAxisCount: 2),
          );
  }
}
