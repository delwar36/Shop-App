import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';
import '../models/sale.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get sales {
    return [..._sales];
  }

  double get totalAmountSold {
    var total = 0.0;
    _sales.forEach((sale) {
      total += sale.amount;
    });
    return total;
  }

  Future<void> fetchAllSales() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    String userId = currentUser.uid.toString();
    final url =
        'https://shop-management-721b3.firebaseio.com/$userId/sales.json';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Sale> loadedSale = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach((prodId, prodData) {
        loadedSale.add(
          Sale(
            id: prodId,
            amount: prodData['amount'],
            cusPaid: prodData['cusPaid'],
            purchaseAmount: prodData['purchaseAmount'],
            dateTime: DateTime.parse(prodData['dateTime']),
            cusImageUrl: prodData['cusImageUrl'],
            cusName: prodData['cusName'],
            products: (prodData['products'] as List<dynamic>)
                .map(
                  (item) => Cart(
                      id: item['id'],
                      sPrice: item['sPrice'],
                      pPrice: item['pPrice'],
                      productImage: item['productImage'],
                      quantiy: item['quantiy'],
                      title: item['title'],
                      unit: item['unit']),
                )
                .toList(),
          ),
        );
      });
      _sales = loadedSale;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addSale(
      List<Cart> cartProducts,
      double total,
      double cusPaid,
      double totalPurchase,
      String cusImageUrl,
      String cusName,
      DateTime dateTime) async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    String userId = currentUser.uid.toString();
    final url =
        'https://shop-management-721b3.firebaseio.com/$userId/sales.json';

    Map<String, dynamic> remoteSale = {
      'amount': total,
      'cusPaid': cusPaid,
      'purchaseAmount': totalPurchase,
      'cusImageUrl': cusImageUrl,
      'cusName': cusName,
      'products': cartProducts
          .map((existingCartItem) => {
                'id': existingCartItem.id,
                'title': existingCartItem.title,
                'sPrice': existingCartItem.sPrice,
                'pPrice': existingCartItem.pPrice,
                'unit': existingCartItem.unit,
                'productImage': existingCartItem.productImage,
                'quantiy': existingCartItem.quantiy,
              })
          .toList(),
      'dateTime': dateTime.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(remoteSale),
      );
      _sales.add(
        Sale(
          amount: total,
          cusPaid: cusPaid,
          purchaseAmount: totalPurchase,
          dateTime: dateTime,
          id: json.decode(response.body)['name'],
          cusImageUrl: cusImageUrl,
          cusName: cusName,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
