import 'package:flutter/material.dart';

class Category { 
  final String id;
  final String title;
  final Color color;
  final DateTime dateTime;
  final String thumbnailLink;

  const Category({
    @required this.id,
    @required this.title,
    @required this.dateTime,
    this.color = Colors.blue,
    this.thumbnailLink = 'https://pluspng.com/img-png/vegetable-png-hd-vegetable-png-transparent-image-1799.png', 
  });
}
