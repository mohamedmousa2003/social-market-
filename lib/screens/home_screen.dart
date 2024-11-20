import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_market/consts/app_constants.dart';
import 'package:social_market/provider/product_provider.dart';
import 'package:social_market/services/assets_manager.dart';
import 'package:social_market/widgets/app_name.text.dart';
import 'package:social_market/widgets/products/ctg_rounded_widget.dart';
import 'package:social_market/widgets/products/latesr_arrival.dart';
import 'package:social_market/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    Size size = MediaQuery.of(context).size;
    //final themeProvider = Provider.of<ThemeProvider>(context,listen: true);
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(
            fontSize: 22,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsMamager.shoppingCart),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * .24,
                  child: ClipRRect(
                    child: Swiper(
                      itemCount: AppConstants.bannerImages.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          AppConstants.bannerImages[index],
                          fit: BoxFit.fill,
                        );
                      },
                      autoplay: true,
                      pagination: const SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.black,
                          activeColor: Colors.red,
                        ),
                      ),
                      //control: SwiperControl(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const TitleTextWidget(label: "Latest Arrival"),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: productProvider.getProducts.isNotEmpty,
                  child: SizedBox(
                    height: size.height * .2,
                    child: ListView.builder(
                        itemCount: productProvider.getProducts.length<10?productProvider.getProducts.length:10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: productProvider.getProducts[index],
                              child: const LatestArrivalProductWidget());
                        }),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SingleChildScrollView(
                    child: TitleTextWidget(label: "Categories")),
                const SizedBox(
                  height: 15,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(AppConstants.categoriesList.length,
                      (index) {
                    return CategoryRoundedWidget(
                      image: AppConstants.categoriesList[index].image,
                      name: AppConstants.categoriesList[index].name,
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
