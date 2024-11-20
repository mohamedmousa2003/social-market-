import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_market/models/cart_model.dart';
import 'package:social_market/models/wishlist_model.dart';
import 'package:social_market/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};
  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

  bool isProductInWishlist({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }


 


// firebase

  final usersDB = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

 /// add to wishlist
  Future<void> addToWishlistFirebase({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorOrWarningDialog(
          context: context, fct: () {}, subtitle: 'login to Access this option ');
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();

    try {
      usersDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            "wishlistId": wishlistId,
            "productId": productId,
            
          }
        ])
      });
      // await fetchWishlist();
      Fluttertoast.showToast(
        msg: 'Item has been added to your wishlist',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      rethrow;
    }
  }

// fetch wishlist

  Future<void> fetchWishlist() async {
    User? user = auth.currentUser;
    if (user == null) {
      // if null delete all cart
      _wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await usersDB.doc(user.uid).get();
      final data = userDoc.data();
      // check userWish in firebase 
      if (data == null || !data.containsKey("userWish")) {
        return;
      }

      final length = userDoc.get("userWish").length;
      for (int i = 0; i < length; i++) {
        _wishlistItems.putIfAbsent(
          userDoc.get('userWish')[i]['productId'],
              () => WishlistModel(
                id: userDoc.get('userWish')[i]['wishlistId'],
            productId: userDoc.get('userWish')[i]['productId'],
            
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }


//clear wishlist
  Future<void> clearWishlistFromFirebase() async {
    User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userWish": [],
      });
      _wishlistItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }


//remove from wishlist
  Future<void> removeWishlistItemFirebase({
    required String wishlistId,
    required String productId,

  }) async {
    User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            "wishlistId": wishlistId,
            "productId": productId,
           
          }
        ]),
      });
      _wishlistItems.remove(productId);
      // await fetchWishlist();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
   





  void addOrRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(productId,
          () => WishlistModel(id: const Uuid().v4(), productId: productId));
    }
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
