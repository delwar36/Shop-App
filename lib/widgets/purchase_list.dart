import 'package:flutter/material.dart';
import '../providers/purchase_provider.dart';
import '../widgets/purchase_item.dart';
import 'package:provider/provider.dart';

class PurchaseList extends StatelessWidget {
  final Function addNewPurchase;
  PurchaseList({this.addNewPurchase});
  @override
  Widget build(BuildContext context) {
    final purchaseData = Provider.of<PurchaseProvider>(context);
    return purchaseData.items.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrains) {
              return Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: constrains.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'এখনো কিছু কেনা হয়নি',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text('কিছু কিনুন'),
                    onPressed: () => addNewPurchase(context),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
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
