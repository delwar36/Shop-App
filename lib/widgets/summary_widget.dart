import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/bangla_converters/number_converter.dart';
import 'package:shop_app/models/sale.dart';
import '../providers/sales_provider.dart';
import '../providers/products_provider.dart';
import '../providers/purchase_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/purchase_item.dart';

class SummaryWidget extends StatefulWidget {
  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AmountCard(),
          SomeProductCard(),
          LogCard(),
        ],
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key key,
  }) : super(key: key);

  double totalSalePriceToday(List<Sale> sales) {
    double totalSum = 0.0;
    final weekDay = DateTime.now();

    for (var i = 0; i < sales.length; i++) {
      if (sales[i].dateTime.day == weekDay.day &&
          sales[i].dateTime.month == weekDay.month &&
          sales[i].dateTime.year == weekDay.year) {
        totalSum += sales[i].amount;
      }
    }
    return totalSum;
  }

  double totalSoldPurchasePriceToday(List<Sale> sales) {
    double totalSum = 0.0;
    final weekDay = DateTime.now();

    for (var i = 0; i < sales.length; i++) {
      if (sales[i].dateTime.day == weekDay.day &&
          sales[i].dateTime.month == weekDay.month &&
          sales[i].dateTime.year == weekDay.year) {
        totalSum += sales[i].purchaseAmount;
      }
    }
    return totalSum;
  }

  double totalPaidPriceToday(List<Sale> sales) {
    double totalSum = 0.0;
    final weekDay = DateTime.now();

    for (var i = 0; i < sales.length; i++) {
      if (sales[i].dateTime.day == weekDay.day &&
          sales[i].dateTime.month == weekDay.month &&
          sales[i].dateTime.year == weekDay.year) {
        totalSum += sales[i].cusPaid;
      }
    }
    return totalSum;
  }

  @override
  Widget build(BuildContext context) {
    final sale = Provider.of<SalesProvider>(context, listen: false);
    final totalSale = totalSalePriceToday(sale.sales);
    final totalPurchase = totalSoldPurchasePriceToday(sale.sales);
    final totalPaid = totalPaidPriceToday(sale.sales);
    final totalDue = totalSale - totalPaid;

    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'আজকের হিসাব',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            // padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              EnglishToBangla.englishToBanglaNumberFont(
                                  '\u09f3${(totalSale - totalPurchase).toStringAsFixed(2)}'),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'লাভ হয়েছে',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        showPriceItem(
                          totalSale.toStringAsFixed(2),
                          'বিক্রিঃ',
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        showPriceItem(
                          totalPaid.toStringAsFixed(2),
                          'পেয়েছিঃ',
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                        ),
                        showPriceItem(
                          totalDue.toStringAsFixed(2),
                          'বাকিঃ',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container showPriceItem(String total, String type) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            EnglishToBangla.englishToBanglaNumberFont(type),
          ),
          Expanded(
            child: Text(
              EnglishToBangla.englishToBanglaNumberFont('\u09f3$total'),
              textAlign: TextAlign.end,
            ),
          ),
          Icon(
            Icons.navigate_next,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

class SomeProductCard extends StatelessWidget {
  const SomeProductCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'সর্বাধিক বিক্রিত পণ্য',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 210,
            child: Consumer<ProductsProvider>(
              builder: (ctx, product, child) {
                final categoryProduct = product.items;
                return categoryProduct.length == 0
                    ? Container(
                        padding: EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/waiting.png',
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(5),
                        itemBuilder: (ctx, index) {
                          return ProductItem(
                            categoryProduct[index].id,
                          );
                        },
                        itemCount: categoryProduct.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LogCard extends StatelessWidget {
  const LogCard({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final purchaseData = Provider.of<PurchaseProvider>(context).items;
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'সাম্প্রতিক লেনদেন',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: purchaseData.length == 0
                ? Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/waiting.png',
                    ),
                  )
                : Column(
                    children: <Widget>[
                      for (int i = 0; i < purchaseData.length; i++)
                        PurchaseItem(
                          productItem: purchaseData[i],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
