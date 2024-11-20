import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/models/cart_model.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/screens/cart/quantity_btm_sheet.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

import '../../provider/product_provider.dart';
import '../../widgets/products/heart_btn.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct =
        productProvider.findByProdId(cartModelProvider.productId);

    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        height: size.height * .13,
                        width: size.width * .2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .6,
                                child: TitleTextWidget(
                                  label: getCurrentProduct.productTitle,
                                  maxLines: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () async{
                                        await cartProvider.removeCartItemFirebase(
                                          cartId: cartModelProvider.cartId,
                                          productId: getCurrentProduct.productId, 
                                          qty: cartModelProvider.quantity
                                        );
                                        // cartProvider.removeOneItem(
                                        //     productId:
                                        //         getCurrentProduct.productId);
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                  // IconButton(onPressed: (){}, icon:Icon(IconlyLight.heart, color: Colors.red,)  )
                                  HeartButtonWidget(
                                    productId: getCurrentProduct.productId,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleTextWidget(
                                label: "${getCurrentProduct.productPrice}\$",
                                color: Colors.blue,
                                fontsize: 18,
                              ),
                              OutlinedButton.icon(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        context: context,
                                        builder: (context) {
                                          return QuantityBottomSheetWidget(
                                            cartModel: cartModelProvider,
                                          );
                                        });
                                  },
                                  icon: const Icon(IconlyLight.arrowDown2),
                                  label: Text(
                                      "Qty : ${cartModelProvider.quantity}")),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
