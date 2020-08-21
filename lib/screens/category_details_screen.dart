import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_item.dart';

class CategoryDetailsScreen extends StatelessWidget {
  static const routeName = '/category-details';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];

    // final productsData = Provider.of<ProductsProvider>(context);
    // final categoryProduct = productsData.getByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cart, ch) => cart.itemCount > 0
                ? Badge(
                    child: ch,
                    value: cart.itemCount.toString(),
                    color: Colors.orange,
                    right: 8,
                    top: 8,
                  )
                : ch,
            child: IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (ctx, product, child) {
          final categoryProduct = product.getByCategory(categoryId);
          return GridView.builder(
            padding: EdgeInsets.all(5),
            itemBuilder: (ctx, index) {
              return ProductItem(
                categoryProduct[index].id,
              );
            },
            itemCount: categoryProduct.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 3 / 4,
            ),
          );
        },
      ),
    );
  }
}
