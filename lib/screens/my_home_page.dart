import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login/auth.dart';
import '../widgets/summary_widget.dart';
import '../providers/purchase_provider.dart';
import '../widgets/purchase_chart.dart';
// import '../models/category.dart';
import '../providers/category_provider.dart';
// import '../widgets/new_category.dart';
import '../widgets/purchase_list.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_provider.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import 'all_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../providers/products_provider.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/main';
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  MyHomePage({
    this.auth,
    this.onSignedOut,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final List<Transaction> _userTransactions = [];

  bool _showChart = false;
  bool _isLoading = true;
  // ignore: unused_field
  String _name = "Android", _email = "";

  // List<Transaction> get _recentTransactions {
  //   return _userTransactions.where((tx) {
  //     return tx.date.isAfter(
  //       DateTime.now().subtract(
  //         Duration(days: 7),
  //       ),
  //     );
  //   }).toList();
  // }
  void _onSignOut() async {
    try {
      await widget.auth.signOut();
      print("Signed Out");
      widget.onSignedOut();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<SalesProvider>(context, listen: false)
            .fetchAllSales();
        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchAllProduct();
        await Provider.of<PurchaseProvider>(context, listen: false)
            .fetchAllPurchase();
        await Provider.of<CategoryProvider>(context, listen: false)
            .fetchAllCategory();
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('সমস্যা!'),
            content: Text('কোনো সমস্যা হয়েছে'),
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
      setState(() {
        _isLoading = false;
      });
    });

    widget.auth.currentUser().then((user) {
      setState(() {
        if (user != null)
          _email = user.email.toString();
        else
          _email = "লোড হচ্ছে...";
      });
    });
    super.initState();
  }

  void _addNewTransaction(
      String enteredTitle,
      double enteredAmouont,
      double enteredPPrice,
      double enteredSPrice,
      String enteredUnit,
      String imageUrl) async {
    setState(() {
      _isLoading = true;
    });
    final product = Product(
      categories: [
        'c1',
        'c2',
      ],
      title: enteredTitle,
      pPrice: enteredPPrice,
      sPrice: enteredSPrice,
      unit: enteredUnit,
      amount: enteredAmouont,
      dateTime: DateTime.now(),
      imageUrl: imageUrl,
    );
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(product, );
      await Provider.of<PurchaseProvider>(context, listen: false)
          .addPurchase(product);
    } catch (error) {
      await showErrorDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void _addNewCategory(
  //   String enteredTitle,
  //   String enteredImageUrl,
  // ) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final category = Category(
  //     id: DateTime.now().toString(),
  //     title: enteredTitle,
  //     thumbnailLink: enteredImageUrl,
  //     dateTime: DateTime.now(),
  //   );

  //   try {
  //     await Provider.of<CategoryProvider>(context, listen: false)
  //         .addCategory(category);
  //   } catch (erroro) {
  //     showErrorDialog();
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future showErrorDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('সমস্যা!'),
        content: Text('কোনো সমস্যা হয়েছে'),
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

  // void _startAddNewCategory(BuildContext ctx) {
  //   showModalBottomSheet(
  //     elevation: 6,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(25),
  //       ),
  //     ),
  //     context: ctx,
  //     isScrollControlled: true,
  //     builder: (bCtx) {
  //       return GestureDetector(
  //         child: Padding(
  //           padding: const EdgeInsets.all(10),
  //           child: NewCategory(_addNewCategory),
  //         ),
  //         onTap: () {},
  //         behavior: HitTestBehavior.opaque,
  //       );
  //     },
  //   );
  // }

  void _startAddNew(BuildContext context, int index) {
    if (index == 0) {
      //nothing
    } else if (index == 1) {
      _selectAllProduct(context);
    } else {
      _startAddNewTransaction(context);
    }
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Newtransaction(_addNewTransaction),
          ),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _selectAllProduct(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      AllProductScreen.routeName,
      arguments: {
        'title': 'সকল পণ্য',
      },
    );
  }

  int _selectPageIndex = 1;
  String pageTitle = 'ক্রয়বিক্রয়';
  void _selectPage(int index, String title) {
    setState(() {
      _selectPageIndex = index;
      pageTitle = title;
    });
  }

  List<Widget> _buildLandscapeContent(
      AppBar appBar, Widget txListWidget, Widget ch) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'চার্ট দেখুন',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Colors.green,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      2 * appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: ch,
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      AppBar appBar, Widget txListWidget, Widget ch) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                2 * appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: ch,
      ),
      txListWidget
    ];
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<SalesProvider>(context, listen: false).fetchAllSales();
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAllProduct();
      await Provider.of<PurchaseProvider>(context, listen: false)
          .fetchAllPurchase();
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchAllCategory();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('সমস্যা!'),
          content: Text('কোনো সমস্যা হয়েছে'),
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
  }

  @override
  Widget build(BuildContext context) {
    final isLandscap =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(pageTitle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _selectPageIndex == 0
                    ? GestureDetector(
                        onTap: () => _startAddNewTransaction(context),
                        child: GestureDetector(
                          onTap: () => _startAddNewTransaction(context),
                          child: Icon(CupertinoIcons.minus_circled),
                        ),
                      )
                    : _selectPageIndex == 1
                        ? GestureDetector(
                            onTap: () => _startAddNewTransaction(context),
                            child: Icon(CupertinoIcons.add),
                          )
                        : Container(),
              ],
            ),
          )
        : AppBar(
            title: Text(pageTitle),
            actions: <Widget>[
              if (_selectPageIndex != 0)
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNew(context, _selectPageIndex),
                ),
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
          );

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              2 * appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(),
    );

    final pcsListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              2 * appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: PurchaseList(
        addNewPurchase: _startAddNewTransaction,
      ),
    );

    List<Map<String, Object>> _pages = [
      {
        'page': Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscap)
              ..._buildLandscapeContent(
                appBar,
                txListWidget,
                Chart(),
              ),
            if (!isLandscap)
              ..._buildPortraitContent(appBar, txListWidget, Chart()),
          ],
        ),
        'title': 'বিক্রয় লগ',
      },
      {
        'page': SummaryWidget(),
        'title': 'ক্রয়বিক্রয়',
      },
      {
        'page': Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscap)
              ..._buildLandscapeContent(
                appBar,
                pcsListWidget,
                PurchaseChart(),
              ),
            if (!isLandscap)
              ..._buildPortraitContent(appBar, pcsListWidget, PurchaseChart()),
          ],
        ),
        'title': 'ক্রয় লগ',
      },
    ];
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pages[_selectPageIndex]['page'],
            navigationBar: appBar,
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: AppDrawer(_onSignOut),
            appBar: appBar,
            body: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: RefreshIndicator(
                      child: _pages[_selectPageIndex]['page'],
                      onRefresh: () => _fetchData(),
                    ),
                  ),
            bottomNavigationBar: CurvedNavigationBar(
              index: _selectPageIndex,
              color: Theme.of(context).primaryColor,
              height: appBar.preferredSize.height,
              onTap: (index) => _selectPage(index, _pages[index]['title']),
              // type: BottomNavigationBarType.fixed,
              // unselectedItemColor: Colors.white,
              // selectedItemColor: Theme.of(context).accentColor,
              //currentIndex: _selectPageIndex,
              // type: BottomNavigationBarType.shifting,
              backgroundColor: Colors.white,
              animationDuration: Duration(milliseconds: 600),
              animationCurve: Curves.easeInOut,

              items: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.category,
                      size: 25,
                      color: Colors.white,
                    ),
                    _selectPageIndex == 0
                        ? Container()
                        : Text(
                            _pages[0]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_basket,
                      size: 25,
                      color: Colors.white,
                    ),
                    _selectPageIndex == 1
                        ? Container()
                        : Text(
                            _pages[1]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      size: 25,
                      color: Colors.white,
                    ),
                    _selectPageIndex == 2
                        ? Container()
                        : Text(
                            _pages[2]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          );
  }
}
