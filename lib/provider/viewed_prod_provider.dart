import 'package:flutter/cupertino.dart';
import 'package:social_market/models/viewed_prod_model.dart';
import 'package:social_market/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

class ViewedProdProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedProdItems = {};
  Map<String, ViewedProdModel> get getViewedItems {
    return _viewedProdItems;
  }

  bool isProductInWishlist({required String productId}) {
    return _viewedProdItems.containsKey(productId);
  }

  void addOViewedProdToHistory({required String productId}) {
    _viewedProdItems.putIfAbsent(productId,
        () => ViewedProdModel(id: const Uuid().v4(), productId: productId));

    notifyListeners();
  }

  void clearLocalViewedProd() {
    _viewedProdItems.clear();
    notifyListeners();
  }
}
