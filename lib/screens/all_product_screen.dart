import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class AllProductScreen extends StatelessWidget {
  static const routeName = '/all-product';

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];

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
      body: RefreshIndicator(
        onRefresh: () => _refreshList(context),
        child: AllProductList(),
      ),
    );
  }
}

class AllProductList extends StatelessWidget {
  const AllProductList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final categoryProduct = Provider.of<ProductsProvider>(context).items;
    return Consumer<ProductsProvider>(
      builder: (ctx, product, child) {
        final categoryProduct = product.items;
        return GridView.builder(
          padding: EdgeInsets.all(5),
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onLongPress: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Delete the product?'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    textColor: Colors.red,
                    label: 'Delete',
                    onPressed: () {
                      product.deleteProduct(categoryProduct[index].id);
                    },
                  ),
                ));
              },
              child: ProductItem(
                categoryProduct[index].id,
              ),
            );
          },
          itemCount: categoryProduct.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            childAspectRatio: 3 / 4,
          ),
        );
      },
    );
  }
}
