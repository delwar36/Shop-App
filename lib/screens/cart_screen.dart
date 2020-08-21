import 'package:flutter/material.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart' as ci;
import 'all_product_screen.dart';
import 'my_home_page.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cusNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final product = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Bag'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\u09f3${cart.totalSoldAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('বিক্রি করুন'),
                    onPressed: (cart.items.length <= 0 || _isLoading)
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('ক্রেতার নাম কি?'),
                                content: TextField(
                                  decoration: InputDecoration(
                                      labelText: 'নাম (ঐচ্ছিক)'),
                                  controller: cusNameController,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('বাতিল'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('ঠিক আছে'),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      Navigator.of(context).pop();
                                      final cusName = cusNameController.text;
                                      try {
                                        await Provider.of<SalesProvider>(
                                                context,
                                                listen: false)
                                            .addSale(
                                          cart.items.values.toList(),
                                          cart.totalSoldAmount,
                                          'https://pngimage.net/wp-content/uploads/2018/06/logo-contact-png-2.png',
                                          cusName,
                                          DateTime.now(),
                                        );
                                        for (int i = 0;
                                            i < cart.items.length;
                                            i++) {
                                          product.decreaseById(
                                              cart.items.keys.toList()[i],
                                              cart.getQuantity(
                                                  cart.items.keys.toList()[i]));
                                        }
                                        Navigator.of(context)
                                            .pushNamed(MyHomePage.routeName);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        cart.clear();
                                      } catch (error) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('সমস্যা!'),
                                            content:
                                                Text('কোনো সমস্যা হয়েছে'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('আচ্ছা'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: cart.itemCount == 0
                ? LayoutBuilder(
                    builder: (ctx, constrains) {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'বাজারের ব্যাগ খালি!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: constrains.maxHeight * 0.5,
                                  child: Image.asset(
                                    'assets/images/waiting.png',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text('কিছু যোগ করুন'),
                              onPressed: () {
                                Navigator.of(ctx).pushNamed(
                                  AllProductScreen.routeName,
                                  arguments: {
                                    'title': 'সকল পণ্য',
                                  },
                                );
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (ctx, index) => ci.CartItem(
                      id: cart.items.values.toList()[index].id,
                      price: cart.items.values.toList()[index].sPrice,
                      imageUrl: cart.items.values.toList()[index].productImage,
                      productId: cart.items.keys.toList()[index],
                      unit: cart.items.values.toList()[index].unit,
                      quantity: cart.items.values.toList()[index].quantiy,
                      title: cart.items.values.toList()[index].title,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
