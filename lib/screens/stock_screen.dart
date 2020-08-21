import 'package:flutter/material.dart';
import '../widgets/stock_item.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';

class StockScreen extends StatelessWidget {
  static const routeName = '/stock-product';

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('স্টক পণ্য'),
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
      // drawer: AppDrawer(),
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
    return Consumer<ProductsProvider>(
      builder: (ctx, product, child) {
        final categoryProduct = product.items;
        return GridView.builder(
          padding: EdgeInsets.all(5),
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onLongPress: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('পণ্যটি মুছে ফেলুন?'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    textColor: Colors.red,
                    label: 'মুছুন',
                    onPressed: () {
                      product.deleteProduct(categoryProduct[index].id);
                    },
                  ),
                ));
              },
              child: StockItem(
                categoryProduct[index].id,
              ),
            );
          },
          itemCount: categoryProduct.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 3 / 4,
          ),
        );
      },
    );
  }
}
