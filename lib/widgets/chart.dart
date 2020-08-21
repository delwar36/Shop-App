import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../providers/sales_provider.dart';
import '../widgets/chart_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  List<Map<String, Object>> groupedTransactionValues(List<Sale> sales) {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < sales.length; i++) {
        if (sales[i].dateTime.day == weekDay.day &&
            sales[i].dateTime.month == weekDay.month &&
            sales[i].dateTime.year == weekDay.year) {
          totalSum += sales[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double totalSpending(List<Sale> product) {
    return groupedTransactionValues(product).fold(0.0, (sum, item) {
      return sum += item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SalesProvider>(context).sales;
    print(groupedTransactionValues);
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Container(
        height: 160,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues(sales).map((data) {
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
                totalSpending(sales) > 0
                    ? (data['amount'] as double) / totalSpending(sales)
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
