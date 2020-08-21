import 'package:flutter/material.dart';
// import 'package:shop_mangement/helpers/db_helper.dart';
import '../models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  // String tableName = 'products';
  // String dbName = 'product';
  // String creatTable =
  //     'CREATE TABLE products(id TEXT PRIMARY KEY, title TEXT, categories TEXT, pPrice DOUBLE(50, 2), sPrice DOUBLE(50, 2), unit TEXT, amount DOUBLE(50, 2), imageUrl TEXT, dateTime TEXT)';

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> getByCategory(String categoryId) {
    return _items.where((product) {
      return product.categories.contains(categoryId);
    }).toList();
  }

  Product getById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> decreaseById(String id, double amount) async {
    Product product = _items.firstWhere((prod) => prod.id == id);
    final url =
        'https://shop-management-721b3.firebaseio.com/products/$id.json';
    await http.patch(url,
        body: json.encode({
          'amount': product.amount - amount,
        }));
    product.amount -= amount;
    notifyListeners();
  }

  Future<void> fetchAllProduct() async {
    _items.clear();
    const url = 'https://shop-management-721b3.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      // print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      // final extractData = await DBHelper.getData(tableName, dbName, creatTable);
      if (extractData == null) {
        return;
      }

      extractData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            amount: prodData['amount'],
            categories: prodData['categories'],
            pPrice: prodData['pPrice'],
            sPrice: prodData['sPrice'],
            unit: prodData['unit'],
            imageUrl: prodData['imageUrl'],
            dateTime: DateTime.parse(prodData['dateTime']),
          ),
        );
      });
      _items = loadedProduct;

      // _items = extractData
      //     .map((item) => Product(
      //           id: item['id'],
      //           title: item['title'],
      //           amount: item['amount'],
      //           pPrice: item['pPrice'],
      //           sPrice: item['sPrice'],
      //           unit: item['unit'],
      //           imageUrl: item['imageUrl'],
      //           dateTime: DateTime.parse(item['dateTime']),
      //           categories: <String>[],
      //         ))
      //     .toList();

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    Map<String, dynamic> remmoteProduct = {
      'title': product.title,
      'categories': product.categories,
      'pPrice': product.pPrice,
      'sPrice': product.sPrice,
      'unit': product.unit,
      'amount': product.amount,
      'imageUrl': product.imageUrl,
      'dateTime': product.dateTime.toIso8601String(),
    };

    const url = 'https://shop-management-721b3.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: json.encode(remmoteProduct),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        // id: DateTime.now().toIso8601String(),
        categories: [...product.categories],
        title: product.title,
        pPrice: product.pPrice,
        sPrice: product.sPrice,
        unit: product.unit,
        amount: product.amount,
        dateTime: product.dateTime,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);

      // DBHelper.insert(tableName, dbName, creatTable, {
      //   'id': newProduct.id,
      //   'title': newProduct.title,
      //   'pPrice': newProduct.pPrice,
      //   'sPrice': newProduct.sPrice,
      //   'unit': newProduct.unit,
      //   'amount': newProduct.amount,
      //   'imageUrl': newProduct.imageUrl,
      //   'dateTime': newProduct.dateTime.toIso8601String(),
      // });

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://shop-management-721b3.firebaseio.com/products/$productId.json';
    try {
      await http.delete(url);
      _items.remove(_items.firstWhere((prod) => prod.id == productId));
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
