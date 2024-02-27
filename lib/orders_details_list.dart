import 'package:flutter/material.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Seller seller;
  final bool showModifiedListButton;

  OrderDetailsScreen(
      {required this.seller, required this.showModifiedListButton});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _orderPlaced = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Change app bar color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Shopping Location: ${widget.seller.shoppinglocation}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey, // Subtitle color
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Delivery Time: ${widget.seller.deliveryTime}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey, // Subtitle color
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_orderPlaced)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _orderPlaced = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      //    primary: Colors.red, // Button color
                      textStyle: TextStyle(fontSize: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Order Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (_orderPlaced && widget.showModifiedListButton ||
                    widget.seller.modifiedList == true)
                  ElevatedButton(
                    onPressed: () {
                      // Add action for Modified List button
                    },
                    style: ElevatedButton.styleFrom(
                      //    primary: Colors.green, // Button color
                      textStyle: TextStyle(fontSize: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Modified List',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (_orderPlaced)
                  ElevatedButton(
                    onPressed: () {
                      // Add action for Chat Now button
                    },
                    style: ElevatedButton.styleFrom(
                      //    primary: Colors.red, // Button color
                      textStyle: TextStyle(fontSize: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Chat Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (_orderPlaced)
                  ElevatedButton(
                    onPressed: () {
                      _launchPhoneDialer(widget.seller.phoneNumber);
                    },
                    style: ElevatedButton.styleFrom(
                      //    primary: Colors.black, // Button color
                      textStyle: TextStyle(fontSize: 16),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Call Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
