import 'package:flutter/material.dart';
import '../providers/purchase_provider.dart';
import '../widgets/purchase_item.dart';
import 'package:provider/provider.dart';

class PurchaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purchaseData = Provider.of<PurchaseProvider>(context);
    return purchaseData.items.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrains) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'এখনো কিছু কেনা হয়নি',
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
            itemCount: purchaseData.items.length,
            itemBuilder: (ctx, i) =>
                PurchaseItem(productItem: purchaseData.items[i]),
          );
  }
}
