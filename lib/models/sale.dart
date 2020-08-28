import 'package:flutter/material.dart';
import '../models/cart.dart';

class Sale {
  final String id;
  final double amount;
  final double cusPaid;
  final double purchaseAmount;
  final List<Cart> products;
  final String cusImageUrl;
  final String cusName;
  final DateTime dateTime;

  Sale({
    @required this.cusImageUrl,
    this.amount=0.0,
    this.cusPaid=0.0,
    this.purchaseAmount=0.0,
    @required this.cusName,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}