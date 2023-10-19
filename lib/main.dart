// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shopper_cart/buyer_page.dart';
import 'package:shopper_cart/choice_page.dart';
import 'package:shopper_cart/login_page.dart';
import 'package:shopper_cart/makelist_page.dart';
import 'package:shopper_cart/models/requested_model.dart';
import 'package:shopper_cart/page_changer.dart';
import 'package:shopper_cart/profile_page.dart';
import 'package:shopper_cart/seller_list.dart';
import 'package:shopper_cart/seller_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoginPage(),
        "/profile": (context) => ProfilePage(),
        "/sellerlist": (context) => SellerListPage(),
        "/makelist": (context) => MakeListPage(),
        "/buy": (context) => BuyerPage(),
        "/page": (context) => PageChanger(),
        '/login': (context) => LoginPage(),
        "/choice": (context) => BuyAndDeliverPage(),
        "/sell": (context) => SellerPage(
              shoppingList: [
                RequestedItem(name: "Chai", price: 10.0, quantity: 2),
                RequestedItem(name: "Samosa", price: 15.0, quantity: 1),
                RequestedItem(name: "Biryani", price: 8.0, quantity: 3),
              ],
            ),
      },
    );
  }
}
