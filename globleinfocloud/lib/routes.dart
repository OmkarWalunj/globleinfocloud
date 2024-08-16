import 'package:flutter/cupertino.dart';
import 'package:globleinfocloud/screens/Home/BooksBuy.dart';
import 'package:globleinfocloud/screens/Home/BooksRent.dart';
import 'package:globleinfocloud/screens/splash/splash_screen.dart';



final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  '/all_rent': (context) => ProductList(),
  '/all_buy' :(context) => const BuyList(),

};
