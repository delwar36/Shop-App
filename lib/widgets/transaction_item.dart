import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/bangla_converters/number_converter.dart';
import '../models/sale.dart';

class TransactionItem extends StatefulWidget {
  final Sale saleItem;
  const TransactionItem({
    @required this.saleItem,
  });

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _color;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.blue,
      Colors.black,
      Colors.purple,
    ];
    _color = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
            widget.saleItem.cusImageUrl,
          ),
        ),
        title: Text(
          widget.saleItem.cusName,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(EnglishToBangla.englishToBanglaNumberFont(
            DateFormat.yMMMd().format(widget.saleItem.dateTime))),
        trailing: Container(
          padding: EdgeInsets.all(7),
          child: Text(
            EnglishToBangla.englishToBanglaNumberFont(
                '\u09f3${widget.saleItem.amount}'),
            style: TextStyle(
              color: _color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    const availableColors = [
      Colors.red,
      Colors.blue,
      Colors.black,
      Colors.purple,
    ];
    return availableColors[Random().nextInt(4)];
  }
}
