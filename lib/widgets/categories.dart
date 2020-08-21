import 'package:flutter/material.dart';
import '../providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'category_item.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryItem = Provider.of<CategoryProvider>(context).categories;
    return GridView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            return CategoryItem(
              categoryItem[index].id,
              categoryItem[index].title,
              categoryItem[index].thumbnailLink,
            );
          },
          itemCount: categoryItem.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 5 / 4,
          ),
        );
  }
}
