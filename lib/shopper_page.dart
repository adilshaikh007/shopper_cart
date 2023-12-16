// // // ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/models/buyer_request_model.dart';
import 'package:shopper_cart/models/requested_model.dart';
import 'package:shopper_cart/user_provider.dart';

class ShopperPage extends StatefulWidget {
  @override
  _ShopperPageState createState() => _ShopperPageState();
}

class _ShopperPageState extends State<ShopperPage> {
  List<BuyerRequest> buyerRequests = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        buyerRequests = querySnapshot.docs
            .map((doc) => BuyerRequest.fromSnapshot(doc))
            .where((request) => request.requestedItems.isNotEmpty)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopper Page"),
      ),
      body: ListView.builder(
        itemCount: buyerRequests.length,
        itemBuilder: (context, index) {
          final request = buyerRequests[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Name: ${request.displayName}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Grand Total: \$${request.grandTotal.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Address:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Area: ${request.address['area']}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "City: ${request.address['city']}",
                  style: TextStyle(fontSize: 16),
                ),
                // Add more fields as needed
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailScreen(request),
                      ),
                    );
                  },
                  child: Text("View Details"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RequestDetailScreen extends StatelessWidget {
  final BuyerRequest request;

  RequestDetailScreen(this.request);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Buyer Name: ${request.displayName}",
                  //   style: TextStyle(fontSize: 18),
                  // ),

                  Center(
                    child: Text(
                      "Address:",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Area: ${request.address['area']}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Text(
                      "City: ${request.address['city']}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Requested Items:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 40.0,
                      columns: [
                        DataColumn(label: Text("Item")),
                        DataColumn(
                          label: Text("Price (\$)"),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Quantity"),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Total (\$)"),
                          numeric: true,
                        ),
                      ],
                      rows: request.requestedItems.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item.name)),
                          DataCell(Text(item.price.toString())),
                          DataCell(Text(item.quantity.toString())),
                          DataCell(
                            Text((item.price * item.quantity)
                                .toStringAsFixed(2)),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Grand Total: \$${request.grandTotal.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ModifyInvitationDialog(request),
                            );
                          },
                          child: Text("Modify Invitation"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle cancellation logic here
                          },
                          child: Text("Cancel Invitation"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle sending invitation logic here
                          },
                          child: Text("Send Invitation"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModifyInvitationDialog extends StatelessWidget {
  final BuyerRequest request;

  ModifyInvitationDialog(this.request);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify Invitation"),
      content: Container(
        width: 300,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 40.0,
                columns: [
                  DataColumn(label: Text("Item")),
                  DataColumn(
                    label: Text("Price (\$)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Quantity"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Total (\$)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Actions"),
                    numeric: false,
                  ),
                ],
                rows: request.requestedItems.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text(item.price.toString())),
                    DataCell(Text(item.quantity.toString())),
                    DataCell(
                        Text((item.price * item.quantity).toStringAsFixed(2))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditPriceDialog(item),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Handle deletion logic here
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Grand Total: \$${request.grandTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Done"),
        ),
      ],
    );
  }
}

class EditPriceDialog extends StatelessWidget {
  final RequestedItem item;

  EditPriceDialog(this.item);

  @override
  Widget build(BuildContext context) {
    late TextEditingController priceController;
    late TextEditingController quantityController;

    priceController = TextEditingController(text: item.price.toString());
    quantityController = TextEditingController(text: item.quantity.toString());

    return AlertDialog(
      title: Text("Edit Price and Quantity"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "New Price (\$)"),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "New Quantity"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            double newPrice = double.parse(priceController.text);
            double newQuantity = double.parse(quantityController.text);

            // Update the item with new values
            // Call onSave to save changes
            Navigator.of(context).pop();
          },
          child: Text("Save"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
