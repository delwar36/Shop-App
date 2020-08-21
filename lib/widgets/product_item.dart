import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  final String id;

  ProductItem(this.id);

  @override
  Widget build(BuildContext context) {
    final product =
        Provider.of<ProductsProvider>(context, listen: false).getById(id);
    final cart = Provider.of<CartProvider>(context, listen: true);

    return InkWell(
      onTap: () {
        if (product.amount > cart.getQuantity(product.id)) {
          cart.addItem(product.id, product.sPrice, product.pPrice,
              product.title, product.imageUrl, product.unit);
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('This product has been out of stock'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: cart.getQuantity(product.id) == 0
          ? ProductCard(product: product)
          : Badge(
              value: cart.getQuantity(product.id).toStringAsFixed(0),
              color: Colors.red,
              child: ProductCard(product: product),
              right: 2,
              top: 3,
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Stack(
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: Image.network(
                product.imageUrl,
                height: 150,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                color: Colors.black54,
                child: Text(
                  '\u09f3${product.sPrice.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Text(
                product.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
