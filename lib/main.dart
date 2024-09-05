// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:shopper_cart/available_listpage.dart';
import 'package:shopper_cart/buyer_page.dart';
import 'package:shopper_cart/choice_page.dart';
import 'package:shopper_cart/login_page.dart';
import 'package:shopper_cart/makelist_page.dart';
import 'package:shopper_cart/models/requested_model.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:shopper_cart/orders_details_list.dart';
import 'package:shopper_cart/page_changer.dart';
import 'package:shopper_cart/profile_page.dart';
import 'package:shopper_cart/seller_list.dart';
import 'package:shopper_cart/shopper_page.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBL75T2KzIOqlV63eWiWpykTx7aP9_DUS8",
      appId: "1:927121172191:android:6b01af9a8a8ea13c0bab6a",
      messagingSenderId: "927121172191",
      projectId: "leaao-66139",
    ),
  );
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
        // "/": (context) => OrderDetailsScreen(
        //       seller: Seller(
        //           shoppinglocation: "Canteen",
        //           deliveryTime: "30 min",
        //           phoneNumber: "9103109066"),
        //       showModifiedListButton: false,
        //     ),
        "/": (context) => LoginPage(),
        "/profile": (context) => ProfilePage(),
        "/sellerlist": (context) => SellerListPage(),
        "/makelist": (context) => MakeListPage(),
        "/buy": (context) => BuyerPage(),
        "/page": (context) => PageChanger(),
        '/login': (context) => LoginPage(),
        "/choice": (context) => BuyAndDeliverPage(),
        "/sell": (context) => ShopperPage(),
      },
    );
  }
}
