import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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
      child: Slidable(
        actions: <Widget>[
          IconSlideAction(
            caption: 'আর্কাইভ',
            color: Colors.blue,
            icon: Icons.archive,
          ),
          IconSlideAction(
            caption: 'শেয়ার',
            color: Colors.indigo,
            icon: Icons.share,
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'আরো',
            color: Colors.black45,
            icon: Icons.more_horiz,
          ),
          IconSlideAction(
            caption: 'মুছুন',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => () {},
          ),
        ],
        actionPane: SlidableScrollActionPane(),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage:  NetworkImage(
                widget.saleItem.cusImageUrl,

              ),
          ),
          title: Text(
            widget.saleItem.cusName,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(DateFormat.yMMMd().format(widget.saleItem.dateTime)),
          trailing: Container(
            padding: EdgeInsets.all(7),
            child: Text(
              '\u09f3${widget.saleItem.amount}',
              style: TextStyle(
                color: _color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
