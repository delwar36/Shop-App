import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/bangla_converters/number_converter.dart';
import 'dart:math';
import '../models/sale.dart';

class SaleItem extends StatefulWidget {
  final Sale sale;

  SaleItem(this.sale);

  @override
  _SaleItemState createState() => _SaleItemState();
}

class _SaleItemState extends State<SaleItem> {
  // var _expanded = false;
  int _position = 0;
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
        horizontal: 5,
        vertical: 3,
      ),
      child: Column(
        children: <Widget>[
          // ListTile(
          //   title: Text('\u09f3${widget.sale.amount.toStringAsFixed(2)}'),
          //   subtitle: Text(
          //     DateFormat('dd MM yyyy hh:mm').format(widget.sale.dateTime),
          //   ),
          //   trailing: IconButton(
          //     icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          //     onPressed: () {
          //       setState(() {
          //         _position = 0;
          //         _expanded = !_expanded;
          //       });
          //     },
          //   ),
          // ),
          InkWell(
            onTap: () {
              setState(() {
                // _expanded = !_expanded;
                _position = 0;
              });
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  widget.sale.cusImageUrl,
                ),
              ),
              title: Text(
                widget.sale.cusName,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(EnglishToBangla.englishToBanglaNumberFont(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.sale.dateTime))),
              trailing: Container(
                padding: EdgeInsets.all(7),
                child: Text(
                  EnglishToBangla.englishToBanglaNumberFont(
                      '\u09f3${widget.sale.amount.toStringAsFixed(2)}'),
                  style: TextStyle(
                    color: _color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15),
                height: min(widget.sale.products.length * 16.0 + 10, 120),
                child: ListView(
                  children: widget.sale.products.map((prod) {
                    _position++;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          EnglishToBangla.englishToBanglaNumberFont(
                              '${_position.toString()}. ${prod.title}'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(EnglishToBangla.englishToBanglaNumberFont(
                            '${prod.quantiy}  ${prod.unit} x \u09f3${prod.sPrice.toStringAsFixed(2)}')),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'মোট',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      EnglishToBangla.englishToBanglaNumberFont(
                          '\u09f3${widget.sale.amount.toStringAsFixed(2)}'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'পরিশোধ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      EnglishToBangla.englishToBanglaNumberFont(
                          '\u09f3${widget.sale.cusPaid.toStringAsFixed(2)}'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'বাকি',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      EnglishToBangla.englishToBanglaNumberFont(
                          '\u09f3${(widget.sale.amount - widget.sale.cusPaid).toStringAsFixed(2)}'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ],
      ),
    );
  }
}
