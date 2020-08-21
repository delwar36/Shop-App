import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class PurchaseItem extends StatefulWidget {
  final Product productItem;
  const PurchaseItem({
    @required this.productItem,
  });

  @override
  _PurchaseItemState createState() => _PurchaseItemState();
}

class _PurchaseItemState extends State<PurchaseItem> {
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
            radius: 28,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
                widget.productItem.imageUrl,
              ),
            // FittedBox(
            //     child: Text(
            //         '${widget.productItem.amount} ${widget.productItem.unit}')),
          ),
          title: Text(
            widget.productItem.title,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle:
              Text(DateFormat.yMMMd().format(widget.productItem.dateTime)),
          trailing: Container(
            padding: EdgeInsets.all(7),
            child: Text(
              '${widget.productItem.amount.toStringAsFixed(1)} ${widget.productItem.unit}',
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
