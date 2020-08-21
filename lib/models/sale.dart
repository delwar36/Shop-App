import 'package:flutter/material.dart';
import '../models/cart.dart';

class Sale {
  final String id;
  final double amount;
  final List<Cart> products;
  final String cusImageUrl;
  final String cusName;
  final DateTime dateTime;

  Sale({
    @required this.cusImageUrl,
    @required this.amount,
    @required this.cusName,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}