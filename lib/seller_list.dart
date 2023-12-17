// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:shopper_cart/orders_details_list.dart';

class SellerListPage extends StatefulWidget {
  @override
  State<SellerListPage> createState() => _SellerListPageState();
}

class _SellerListPageState extends State<SellerListPage> {
  late List<Seller> sellers = [];

  @override
  void initState() {
    super.initState();
    fetchSellersFromFirebase();
  }

  Future<void> fetchSellersFromFirebase() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('SellerList').get();

    final List<Seller> sellers =
        snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      final data = doc.data()!;

      return Seller(
        shoppinglocation: data['shoppinglocation'],
        deliveryTime: data['deliveryTime'],
        modifiedList: data['modifiedList'] ?? false,
        phoneNumber: data['phoneNumber'],
      );
    }).toList();

    setState(() {
      this.sellers = sellers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Change the app bar color
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: sellers.length,
        itemBuilder: (BuildContext context, int index) {
          final seller = sellers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(
                    seller: seller,
                    showModifiedListButton: seller.modifiedList,
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Shopping Location: ${seller.shoppinglocation}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, // Subtitle color
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Delivery Time: ${seller.deliveryTime}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, // Subtitle color
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                trailing: ModifiedListButton(
                  modifiedList: seller.modifiedList,
                  seller: seller,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ModifiedListButton extends StatelessWidget {
  final bool modifiedList;
  final Seller seller;

  ModifiedListButton({required this.modifiedList, required this.seller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              seller: seller,
              showModifiedListButton: modifiedList,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: modifiedList ? Colors.green : Colors.red, // Button color
        textStyle: TextStyle(fontSize: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(
        modifiedList ? 'Modified List' : 'Order Now',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
