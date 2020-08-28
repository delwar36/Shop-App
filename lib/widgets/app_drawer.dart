import 'package:flutter/material.dart';
import '../screens/my_home_page.dart';
import '../screens/sales_screen.dart';
import '../screens/stock_screen.dart';

// ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  Function onSignOut;
  AppDrawer(
    this.onSignOut,
  );

  Widget buildTile(
      String title, IconData iconData, String route, BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        if (route != null) {
          Navigator.of(context).pushNamed(route);
        } else {
          onSignOut();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, top: 40),
              alignment: Alignment.topLeft,
              color: Theme.of(context).primaryColor,
              child: Text(
                'আমার দোকান',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildTile('হোম', Icons.home, MyHomePage.routeName, context),
            buildTile(
                'বিক্রয় ইতিহাস', Icons.history, SalesScreen.routeName, context),
            buildTile('স্টক পণ্য', Icons.store, StockScreen.routeName, context),
            buildTile('লগআউট', Icons.exit_to_app, null, context)
          ],
        ),
      ),
    );
  }
}
