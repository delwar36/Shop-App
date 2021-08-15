import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login/auth.dart';
import 'login/pages/splash_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/category_provider.dart';
import 'providers/products_provider.dart';
import 'providers/purchase_provider.dart';
import 'providers/sales_provider.dart';
import 'screens/all_product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/category_details_screen.dart';
import 'screens/my_home_page.dart';
import 'screens/sales_screen.dart';
import 'screens/stock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BaseAuth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: SalesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CategoryProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PurchaseProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'দোকান ম্যানেজমেন্ট',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              )),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        home: SplashScreen(
          auth: auth,
        ),
        routes: {
          CategoryDetailsScreen.routeName: (ctx) => CategoryDetailsScreen(),
          AllProductScreen.routeName: (ctx) => AllProductScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          SalesScreen.routeName: (ctx) => SalesScreen(),
          MyHomePage.routeName: (ctx) => MyHomePage(
                auth: auth,
              ),
          StockScreen.routeName: (ctx) => StockScreen(),
        },
      ),
    );
  }
}
