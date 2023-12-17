// // // ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/models/buyer_request_model.dart';
import 'package:shopper_cart/models/delivery_info.dart';
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
          List<String> shoppingList = request.requestedItems
              .map((item) => item.name as String)
              .toList();
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Requested Items: ${shoppingList.join(', ')}",
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
                  "Room No: ${request.address['room']}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Hostel: ${request.address['hostel']}",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "College: ${request.address['college']}",
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

                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Room No: ${request.address['room']}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Hostel: ${request.address['hostel']}",
                      style: TextStyle(fontSize: 20),
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
                          DataCell(Text(item
                              .getDisplayQuantity())), // Use the display value
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
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => DeliveryInfoPopup(request),
                            // ).then((deliveryInfo) {
                            //   if (deliveryInfo != null) {
                            //     // Handle the collected delivery information
                            //     // You can pass it to SellerListPage or handle it as needed
                            //     print(
                            //         "Delivery Time: ${deliveryInfo.deliveryTime}");
                            //     print(
                            //         "Delivery Charges: ${deliveryInfo.deliveryCharges}");

                            //     // Get the current user's Google user ID
                            //     GoogleSignInAccount? googleUserId =
                            //         Provider.of<UserProvider>(context,
                            //                 listen: false)
                            //             .user;

                            //     // Get the current date and time
                            //     DateTime currentDate = DateTime.now();

                            //     // Create a map with the information to be stored
                            //     Map<String, dynamic> SellerList = {
                            //       'googleUserEmail': googleUserId!.email,
                            //       'deliveryTime': deliveryInfo.deliveryTime,
                            //       'deliveryCharges':
                            //           deliveryInfo.deliveryCharges,
                            //       'dateTime': currentDate,
                            //     };

                            //     // Store the information in Firebase
                            //     FirebaseFirestore.instance
                            //         .collection('SellerList')
                            //         .add(SellerList)
                            //         .then((value) {
                            //       // Handle success, if needed
                            //       print("Invitation stored successfully");
                            //     }).catchError((error) {
                            //       // Handle error, if needed
                            //       print("Error storing invitation: $error");
                            //     });
                            //   }
                            // });
                            showDialog(
                              context: context,
                              builder: (context) => DeliveryInfoPopup(request),
                            ).then((deliveryInfo) {
                              if (deliveryInfo != null) {
                                // Get the current user's Google user ID
                                GoogleSignInAccount? googleUserId =
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user;

                                if (googleUserId != null) {
                                  // Create a document reference with the Google user ID
                                  DocumentReference sellerListRef =
                                      FirebaseFirestore.instance
                                          .collection('SellerList')
                                          .doc(googleUserId.id);

                                  // Get the current date and time
                                  DateTime currentDate = DateTime.now();

                                  // Create a map with the information to be stored
                                  Map<String, dynamic> sellerListData = {
                                    'googleUserEmail': googleUserId.email,
                                    'deliveryTime': deliveryInfo.deliveryTime,
                                    'deliveryCharges':
                                        deliveryInfo.deliveryCharges,
                                    'dateTime': currentDate,
                                  };

                                  // Store the information in Firebase using the set method to overwrite any existing data
                                  sellerListRef
                                      .set(sellerListData)
                                      .then((value) {
                                    // Handle success, if needed
                                    print("Invitation stored successfully");
                                  }).catchError((error) {
                                    // Handle error, if needed
                                    print("Error storing invitation: $error");
                                  });
                                }
                              }
                            });
                          },
                          child: Text("Send Invitation"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
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
                    DataCell(Text(item.getDisplayQuantity())),
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

// class DeliveryInfoPopup extends StatefulWidget {
//   final BuyerRequest request;

//   DeliveryInfoPopup(this.request);

//   @override
//   _DeliveryInfoPopupState createState() => _DeliveryInfoPopupState();
// }

// class _DeliveryInfoPopupState extends State<DeliveryInfoPopup> {
//   late TextEditingController deliveryTimeController;
//   late TextEditingController deliveryChargesController;
//   List<double> deliveryChargesSuggestions = [30, 50, 100];

//   @override
//   void initState() {
//     super.initState();
//     deliveryTimeController = TextEditingController();
//     deliveryChargesController = TextEditingController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Delivery Information"),
//       content: Container(
//         width: 300,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField<double>(
//               value: deliveryChargesController.text.isNotEmpty
//                   ? double.parse(deliveryChargesController.text)
//                   : null,
//               items: deliveryChargesSuggestions
//                   .map(
//                     (charge) => DropdownMenuItem<double>(
//                       value: charge,
//                       child: Text("\₹ $charge"),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   deliveryChargesController.text = value.toString();
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: "Delivery Charges (₹)",
//                 hintText: "Select charges",
//               ),
//             ),
//             SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: deliveryTimeController.text.isNotEmpty
//                   ? deliveryTimeController.text
//                   : null,
//               items: [
//                 "10 minutes",
//                 "15 minutes",
//                 "30 minutes",
//                 "1 hour",
//                 "2 hours",
//               ]
//                   .map(
//                     (time) => DropdownMenuItem<String>(
//                       value: time,
//                       child: Text(time),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   deliveryTimeController.text = value!;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: "Expected Delivery Time",
//                 hintText: "Select time",
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the popup
//           },
//           child: Text("Cancel"),
//         ),
//         TextButton(
//           onPressed: () {
//             // Validate and collect the delivery information
//             String deliveryTime = deliveryTimeController.text.trim();
//             double deliveryCharges =
//                 double.tryParse(deliveryChargesController.text) ?? 0.0;

//             if (deliveryTime.isNotEmpty && deliveryCharges >= 0.0) {
//               // Pass the collected delivery information back to the calling screen
//               Navigator.of(context).pop(
//                 DeliveryInfo(
//                   deliveryTime: deliveryTime,
//                   deliveryCharges: deliveryCharges,
//                 ),
//               );
//             } else {
//               // Handle validation error
//               // You can show a snackbar or dialog indicating invalid input
//             }
//           },
//           child: Text("Send"),
//         ),
//       ],
//     );
//   }
// }

class DeliveryInfoPopup extends StatefulWidget {
  final BuyerRequest request;

  DeliveryInfoPopup(this.request);

  @override
  _DeliveryInfoPopupState createState() => _DeliveryInfoPopupState();
}

class _DeliveryInfoPopupState extends State<DeliveryInfoPopup> {
  late TextEditingController deliveryTimeController;
  late TextEditingController deliveryChargesController;
  late TextEditingController shoppingLocationController; // Add this line
  List<double> deliveryChargesSuggestions = [30, 50, 100];

  @override
  void initState() {
    super.initState();
    deliveryTimeController = TextEditingController();
    deliveryChargesController = TextEditingController();
    shoppingLocationController = TextEditingController(); // Add this line
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delivery Information"),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: shoppingLocationController.text.isNotEmpty
                  ? shoppingLocationController.text
                  : null,
              items: [
                "Canteen",
                "Nescafe",
                "Kashmir University Road",
                "Lal Chowk",
                "Shwarma Hut",
                "Parsa's",
                "Turfah Restaurant",
                "Domino's",
                "City One Mall",
              ]
                  .map(
                    (location) => DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  shoppingLocationController.text = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Shopping Location",
                hintText: "Select location",
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<double>(
              value: deliveryChargesController.text.isNotEmpty
                  ? double.parse(deliveryChargesController.text)
                  : null,
              items: deliveryChargesSuggestions
                  .map(
                    (charge) => DropdownMenuItem<double>(
                      value: charge,
                      child: Text("\₹ $charge"),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  deliveryChargesController.text = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: "Delivery Charges (₹)",
                hintText: "Select charges",
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: deliveryTimeController.text.isNotEmpty
                  ? deliveryTimeController.text
                  : null,
              items: [
                "10 minutes",
                "15 minutes",
                "30 minutes",
                "1 hour",
                "2 hours",
              ]
                  .map(
                    (time) => DropdownMenuItem<String>(
                      value: time,
                      child: Text(time),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  deliveryTimeController.text = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Expected Delivery Time",
                hintText: "Select time",
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Validate and collect the delivery information
            String deliveryTime = deliveryTimeController.text.trim();
            double deliveryCharges =
                double.tryParse(deliveryChargesController.text) ?? 0.0;
            String shoppingLocation =
                shoppingLocationController.text.trim(); // Add this line

            if (deliveryTime.isNotEmpty &&
                deliveryCharges >= 0.0 &&
                shoppingLocation.isNotEmpty) {
              // Pass the collected delivery information back to the calling screen
              Navigator.of(context).pop(
                DeliveryInfo(
                  deliveryTime: deliveryTime,
                  deliveryCharges: deliveryCharges,
                  shoppingLocation: shoppingLocation, // Add this line
                ),
              );
            } else {
              // Handle validation error
              // You can show a snackbar or dialog indicating invalid input
            }
          },
          child: Text("Send"),
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
    quantityController = TextEditingController(
        text: item.quantity.toStringAsFixed(0)); // Format as integer

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
            int newQuantity = int.parse(quantityController.text);
            // Update the item with new values
            item.price = newPrice;
            item.quantity = newQuantity.toDouble();
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
