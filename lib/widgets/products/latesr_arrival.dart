import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_market/models/product_model.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/provider/viewed_prod_provider.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import '../../screens/inner_screens/product_details.dart';
import 'heart_btn.dart';

class LatestArrivalProductWidget extends StatefulWidget {
  const LatestArrivalProductWidget({super.key});

  @override
  _LatestArrivalProductWidgetState createState() =>
      _LatestArrivalProductWidgetState();
}

class _LatestArrivalProductWidgetState
    extends State<LatestArrivalProductWidget> {
  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    Size size = MediaQuery.of(context).size;

    // Check if product is already in the cart
    isAddedToCart =
        cartProvider.isProductInCart(productId: productModel.productId);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addOViewedProdToHistory(
              productId: productModel.productId);
          await Navigator.pushNamed(context, ProductDetails.routName,
              arguments: productModel.productId);
        },
        child: SizedBox(
          width: size.width * .45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    width: size.width * .28,
                    height: size.width * .28,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        productModel.productTitle ?? 'Unknown Product',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(
                            productId: productModel.productId,
                            size: 18,
                            color: Colors.transparent,
                          ),
                          IconButton(
                            onPressed: () async {
                              // if (!isAddedToCart) {
                              //   cartProvider.addProductToCart(productId: productModel.productId);
                              //   setState(() {
                              //     isAddedToCart = true;
                              //   });
                              // }
                              if (cartProvider.isProductInCart(
                                  productId: productModel.productId)) {
                                return;
                              }
                              /* cartProvider.addProductToCart(
                                      productId: getCurrentProduct.productId);*/
                              try {
                                await cartProvider.addToCartFirebase(
                                    productId: productModel.productId,
                                    qty: 1,
                                    context: context);
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                MyAppMethods.showErrorOrWarningDialog(
                                    context: context,
                                    subtitle: e.toString(),
                                    fct: () {});
                              }
                            },
                            icon: Icon(
                              isAddedToCart
                                  ? Icons.done
                                  : Icons.add_shopping_cart_rounded,
                              color: isAddedToCart ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubtitleTextWidget(
                          label: "${productModel.productPrice}\$",
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
