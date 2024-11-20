import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/provider/viewed_prod_provider.dart';
import 'package:social_market/screens/inner_screens/product_details.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/title_text.dart';

import '../subtitle_text.dart';
import 'heart_btn.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProdProvider>(context);

    //final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProdId(widget.productId);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                viewedProvider.addOViewedProdToHistory(
                    productId: getCurrentProduct.productId);

                await Navigator.pushNamed(context, ProductDetails.routName,
                    arguments: getCurrentProduct.productId);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      width: double.infinity,
                      height: size.height * .25,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 5,
                          child: TitleTextWidget(
                              label: getCurrentProduct.productTitle)),
                      Flexible(
                          flex: 1,
                          child: HeartButtonWidget(
                            productId: getCurrentProduct.productId,
                            size: 24,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 3,
                          child: SubtitleTextWidget(
                              label: "${getCurrentProduct.productPrice}\$")),
                      Flexible(
                          flex: 1,
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.lightBlue,
                            child: InkWell(
                                onTap: () async {
                                  if (cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)) {
                                    return;
                                  }
                                 /* cartProvider.addProductToCart(
                                      productId: getCurrentProduct.productId);*/
                                  try{
                               await   cartProvider.addToCartFirebase(productId: getCurrentProduct.productId,
                                      qty: 1,
                                      context: context);
                                }catch(e){
                                    // ignore: use_build_context_synchronously
                                    MyAppMethods.showErrorOrWarningDialog(context: context,
                                        subtitle:e.toString() ,
                                        fct: (){});
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(cartProvider.isProductInCart(
                                          productId:
                                              getCurrentProduct.productId)
                                      ? Icons.done_outline_rounded
                                      : IconlyLight.bag2),
                                )
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
