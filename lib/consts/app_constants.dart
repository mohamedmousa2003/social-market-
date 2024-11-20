import '../models/categories_model.dart';
import '../services/assets_manager.dart';

class AppConstants {
  static String ProductImageUrl =
      'https://th.bing.com/th/id/OIP.pYLElWme1CoIXbL5BeYWXQAAAA?rs=1&pid=ImgDetMain';

  static List<String> bannerImages = [
    AssetsMamager.banner1,
    AssetsMamager.banner2
  ];
  static List<CategoryModel> categoriesList = [
    CategoryModel(
        image: AssetsMamager.book, id: AssetsMamager.book, name: "book"),
    CategoryModel(
        image: AssetsMamager.electronics,
        id: AssetsMamager.electronics,
        name: "electronics"),
    CategoryModel(
        image: AssetsMamager.fashion,
        id: AssetsMamager.fashion,
        name: "fashion"),
    CategoryModel(
        image: AssetsMamager.mobiles,
        id: AssetsMamager.mobiles,
        name: "phones"),
    CategoryModel(
        image: AssetsMamager.pc, id: AssetsMamager.pc, name: "laptops"),
    CategoryModel(
        image: AssetsMamager.shoes, id: AssetsMamager.shoes, name: "shoes"),
    CategoryModel(
        image: AssetsMamager.cosmetics,
        id: AssetsMamager.cosmetics,
        name: "cosmetics"),
  ];
}
