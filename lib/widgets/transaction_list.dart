import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saleData = Provider.of<SalesProvider>(context);
    return saleData.sales.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrains) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'এখনো কোনো বিক্রয় হয়নি',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constrains.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: saleData.sales.length,
            itemBuilder: (ctx, i) =>
                TransactionItem(saleItem: saleData.sales[i]),
          );
  }
}
