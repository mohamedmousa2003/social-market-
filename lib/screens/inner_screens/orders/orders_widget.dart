import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_market/consts/app_constants.dart';
import 'package:social_market/screens/cart/quantity_btm_sheet.dart';
import 'package:social_market/widgets/subtitle_text.dart';
import 'package:social_market/widgets/title_text.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FancyShimmerImage(
                    imageUrl: AppConstants.ProductImageUrl,
                    height: size.height * .2,
                    width: size.width * .2,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * .6,
                          child: TitleTextWidget(
                            label: "product tiltle ",
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        TitleTextWidget(label: "price: "),
                        const SubtitleTextWidget(
                          label: "16\$",
                          color: Colors.blue,
                          fontsize: 18,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TitleTextWidget(label: "Qty 10")
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
