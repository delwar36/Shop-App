import 'package:flutter/foundation.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double getQuantity(String id) {
    if (_items[id] == null) {
      return 0;
    }
    return _items[id].quantiy;
  }

  double get totalSoldAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.sPrice * cartItem.quantiy;
    });
    return total;
  }

  double get totalPurchaseAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.pPrice * cartItem.quantiy;
    });
    return total;
  }

  void addItem(String productId, double sPrice, double pPrice, String title,
      String productIamge, String unit) {
    if (_items.containsKey(productId)) {
      //
      _items.update(
        productId,
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          sPrice: existingCartItem.sPrice,
          pPrice: existingCartItem.pPrice,
          unit: existingCartItem.unit,
          productImage: existingCartItem.productImage,
          quantiy: existingCartItem.quantiy + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
            id: DateTime.now().toIso8601String(),
            title: title,
            sPrice: sPrice,
            pPrice: pPrice,
            unit: unit,
            productImage: productIamge,
            quantiy: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseProduct(String productId) {
    _items.update(
      productId,
      (existingCartItem) => Cart(
        id: existingCartItem.id,
        title: existingCartItem.title,
        sPrice: existingCartItem.sPrice,
        pPrice: existingCartItem.pPrice,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: existingCartItem.quantiy + 0.5,
      ),
    );
    notifyListeners();
  }

  void decreaseProduct(String productId) {
    if (getQuantity(productId) <= 1) {
      removeItem(productId);
    }
    _items.update(
      productId,
      (existingCartItem) => Cart(
        id: existingCartItem.id,
        title: existingCartItem.title,
        sPrice: existingCartItem.sPrice,
        pPrice: existingCartItem.pPrice,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: existingCartItem.quantiy - 1,
      ),
    );
    notifyListeners();
  }

  void replaceAmount(String id, double amount) {
    if (getQuantity(id) <= 1) {
      removeItem(id);
    }
    _items.update(
      id,
      (existingCartItem) => Cart(
        id: existingCartItem.id,
        title: existingCartItem.title,
        sPrice: existingCartItem.sPrice,
        pPrice: existingCartItem.pPrice,
        unit: existingCartItem.unit,
        productImage: existingCartItem.productImage,
        quantiy: amount,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
