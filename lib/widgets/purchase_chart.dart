import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/purchase_provider.dart';
import '../widgets/chart_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PurchaseChart extends StatelessWidget {
  List<Map<String, Object>> groupedTransactionValues(List<Product> products) {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < products.length; i++) {
        if (products[i].dateTime.day == weekDay.day &&
            products[i].dateTime.month == weekDay.month &&
            products[i].dateTime.year == weekDay.year) {
          totalSum += products[i].pPrice * products[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double totalSpending(List<Product> product) {
    return groupedTransactionValues(product).fold(0.0, (sum, item) {
      return sum += item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<PurchaseProvider>(context).items;
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Container(
        height: 180,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues(products).map((data) {
            if (data['day'] == 'Mon') {
              data['day'] = 'সোম';
            } else if (data['day'] == 'Tue') {
              data['day'] = 'মঙ্গল';
            } else if (data['day'] == 'Wed') {
              data['day'] = 'বুধ';
            } else if (data['day'] == 'Thu') {
              data['day'] = 'বৃহঃ';
            } else if (data['day'] == 'Fri') {
              data['day'] = 'শুক্র';
            } else if (data['day'] == 'Sat') {
              data['day'] = 'শনি';
            } else {
              data['day'] = 'রবি';
            }
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending(products) > 0
                    ? (data['amount'] as double) / totalSpending(products)
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
