// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:shopper_cart/orders_details_list.dart';

class SellerListPage extends StatelessWidget {
  final List<Seller> sellers = [
    Seller(
      name: 'Adil Shaikh',
      shoppinglocation: 'Canteen',
      deliveryTime: '30 minutes',
      deliveryPersonHomeAddress: 'chenab -308',
      phoneNumber: '9103109066',
    ),
    Seller(
      name: 'Danish Shaikh',
      shoppinglocation: 'Friday Market',
      deliveryTime: '1 hour',
      modifiedList: true,
      deliveryPersonHomeAddress: 'jhelum extension -29',
      phoneNumber: '9011897964',
    ),
    Seller(
      name: 'Tauhid Qureshi',
      shoppinglocation: 'Lal Chowk',
      deliveryTime: '1 hour',
      modifiedList: true,
      deliveryPersonHomeAddress: 'jhelum extension -29',
      phoneNumber: '9011897964',
    ),
  ];

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
                title: Text(
                  seller.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.indigo, // Text color
                  ),
                ),
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
