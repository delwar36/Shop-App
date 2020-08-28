import 'package:flutter/material.dart';
import 'package:shop_app/bangla_converters/number_converter.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String productId;
  final String imageUrl;
  final double quantity;
  final String unit;
  final String title;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.productId,
    @required this.imageUrl,
    @required this.quantity,
    @required this.unit,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);



    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the shopping bag?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 30,
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      EnglishToBangla.englishToBanglaNumberFont(
                          'মোট: \u09f3${(price * quantity).toStringAsFixed(2)}'),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Colors.red,
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .decreaseProduct(productId);
                      },
                    ),
                    Text(
                      EnglishToBangla.englishToBanglaNumberFont(
                          '${quantity.toStringAsFixed(1)}'),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.green,
                      onPressed: () {
                        if (product.getById(productId).amount >
                            cart.getQuantity(product.getById(productId).id) +
                                1) {
                          cart.increaseProduct(productId);
                        } else {
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('এই পণ্যটি শেষ হয়ে গেছে'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
