import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String title;
  final double quantiy;
  final String productImage;
  final double sPrice;
  final double pPrice;
  final String unit;

  Cart({
    @required this.id,
    @required this.title,
    @required this.quantiy,
    @required this.productImage,
    @required this.sPrice,
    @required this.pPrice,
    @required this.unit,
  });
}