import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:social_market/provider/wishlistprovider.dart';
import 'package:social_market/services/my_app_methods.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget(
      {super.key,
      this.size = 22,
      this.color = Colors.transparent,
      required this.productId});
  final double size;
  final Color? color;
  final String productId;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Material(
      shape: const CircleBorder(),
      color: widget.color,
      child: IconButton(
          onPressed: () async {
            // wishlistProvider.addOrRemoveFromWishlist(
            //     productId: widget.productId);
            setState(() {
              isLoading = true;
            });
            try {
              if (wishlistProvider.getWishlistItems
                  .containsKey(widget.productId)) {
                wishlistProvider.removeWishlistItemFirebase(
                  productId: widget.productId,
                  wishlistId:
                      wishlistProvider.getWishlistItems[widget.productId]!.id,
                );
              } else {
                wishlistProvider.addToWishlistFirebase(
                    productId: widget.productId, context: context);
              }
              await wishlistProvider.fetchWishlist();
            } catch (e) {
              MyAppMethods.showErrorOrWarningDialog(
                  context: context, subtitle: e.toString(), fct: () {});
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          },
          icon: isLoading
              ? const CircularProgressIndicator()
              : Icon(
                  wishlistProvider.isProductInWishlist(
                          productId: widget.productId)
                      ? IconlyBold.heart
                      : IconlyLight.heart,
                  size: widget.size,
                  color: wishlistProvider.isProductInWishlist(
                          productId: widget.productId)
                      ? Colors.red
                      : Colors.blueGrey,
                )),
    );
  }
}
