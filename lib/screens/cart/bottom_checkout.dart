import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/cart_provider.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    int numberQty =6;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(top: BorderSide(width: 1, color: Colors.grey))),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 16,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextWidget(
                            label:
                                "Total(${cartProvider.getCartItems.length} product /${cartProvider.getQty()}Items )"),
                        SubtitleTextWidget(
                          label:
                              "${cartProvider.getTotal(productProvider: productProvider)}\$",
                          color: Colors.blue,
                        )
                      ],
                    ),
                  ),
                 ElevatedButton(
  onPressed: () async {
    // Access the cart item count
    int cartItemCount = cartProvider.getQty();

    
    if (cartItemCount >= numberQty) {
      MyAppMethods.showErrorOrWarningDialog(
        context: context,
        subtitle: "Error: Too many items in cart",
        fct: () {},
      );
    } else {
      MyAppMethods.showErrorOrWarningDialog(
        context: context,
        subtitle: "OK: Cart is under the limit",
        fct: () {},
      );
    }
  },
  child: const Text('Check Out'),
)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
if (cartProvider.getCartItems.length >= 5) {
                          MyAppMethods.showErrorOrWarningDialog(
                          context: context,
                           subtitle: "Error",
                            fct: (){}
                            );
                        }else{
                           MyAppMethods.showErrorOrWarningDialog(
                          context: context,
                           subtitle: "OK",
                            fct: (){}
                            );
                        }
*/