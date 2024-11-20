import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../widgets/products/heart_btn.dart';

class ProductDetails extends StatefulWidget {
  static const routName = '/productdetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findByProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(
          fontSize: 30,
        ),
        centerTitle: true,
      ),
      body: getCurrentProduct == null
          ? SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrentProduct.productImage,
                    height: size.height * .38,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                flex: 5,
                                child: Text(
                                  getCurrentProduct.productTitle,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                                child: Text(
                              "${getCurrentProduct.productPrice}\$",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.5),
                            )),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              HeartButtonWidget(
                                productId: getCurrentProduct.productId,
                                color: Colors.teal,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () async{
                                      // if (cartProvider.isProductInCart(
                                      //     productId:
                                      //         getCurrentProduct.productId)) {
                                      //   return;
                                      // }
                                      // cartProvider.addProductToCart(
                                      //     productId:
                                      //         getCurrentProduct.productId);

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
                                    icon: Icon(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrentProduct.productId)
                                          ? Icons.done_outline_rounded
                                          : Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  getCurrentProduct.productId)
                                          ? "Already in Cart"
                                          : "Add to Cart",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleTextWidget(label: "About This Item"),
                            SubtitleTextWidget(
                                label: getCurrentProduct.productCategory)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SubtitleTextWidget(
                            label: getCurrentProduct.productDescription)
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
