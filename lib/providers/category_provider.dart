import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CategoryProvider with ChangeNotifier {
  String tableName = 'categories';
  String dbName = 'category';
  String creatTable =
      'CREATE TABLE categories(id TEXT PRIMARY KEY, title TEXT, image TEXT, dateTime TEXT)';

  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Future<void> fetchAllCategory() async {
    const url = 'https://shop-management-721b3.firebaseio.com/categories.json';
    try {
      final response = await http.get(url);
      // print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      // final extractData = await DBHelper.getData(tableName, dbName, creatTable);
      final List<Category> loadedCategory = [];
      if (extractData == null) {
        return;
      }

      // _categories = extractData
      //     .map((item) => Category(
      //           id: item['id'],
      //           title: item['title'],
      //           thumbnailLink: item['image'],
      //           dateTime: DateTime.parse(item['dateTime']),
      //         ))
      //     .toList();

      extractData.forEach((cateId, cateData) {
        print(cateId);
        loadedCategory.add(
          Category(
            id: cateId,
            title: cateData['title'],
            thumbnailLink: cateData['thumbnailLink'],
            dateTime: DateTime.parse(cateData['dateTime']),
          ),
        );
      });
      _categories = loadedCategory;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addCategory(Category category) async {
    Map<String, dynamic> remoteCategory = {
      'title': category.title,
      'thumbnailLink': category.thumbnailLink,
      'dateTime': category.dateTime.toIso8601String(),
    };

    const url = 'https://shop-management-721b3.firebaseio.com/categories.json';

    try {
      final response = await http.post(
        url,
        body: json.encode(remoteCategory),
      );
      final newCategory = Category(
        id: json.decode(response.body)['name'],
        // id: DateTime.now().toIso8601String(),
        title: category.title,
        dateTime: category.dateTime,
        thumbnailLink: category.thumbnailLink,
        color: category.color,
      );
      _categories.add(newCategory);
      notifyListeners();
      DBHelper.insert(tableName, dbName, creatTable, {
        'id': newCategory.id,
        'title': newCategory.title,
        'image': newCategory.thumbnailLink,
        'dateTime': newCategory.dateTime.toIso8601String(),
      });
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
