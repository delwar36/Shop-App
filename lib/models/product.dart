import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final List<dynamic> categories;
  double amount;
  final String unit;
  final double pPrice;
  final double sPrice;
  final String imageUrl;
  final DateTime dateTime;

  Product({
    this.id,
    @required this.title,
    @required this.categories,
    @required this.amount,
    @required this.pPrice,
    @required this.unit,
    @required this.sPrice,
    @required this.imageUrl,
    @required this.dateTime,
  });
}
