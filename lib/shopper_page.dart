// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:shopper_cart/models/buyer_request_model.dart';
// import 'package:shopper_cart/models/delivery_info.dart';
// import 'package:shopper_cart/models/requested_model.dart';
// import 'package:shopper_cart/models/seller_model.dart';
// import 'package:shopper_cart/orders_details_list.dart';
// import 'package:shopper_cart/user_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ShopperPage extends StatefulWidget {
//   @override
//   _ShopperPageState createState() => _ShopperPageState();
// }

// class _ShopperPageState extends State<ShopperPage> {
//   List<BuyerRequest> buyerRequests = [];
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final currentUser = userProvider.user;
//     FirebaseFirestore.instance
//         .collection('users')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       setState(() {
//         buyerRequests = querySnapshot.docs
//             .map((doc) => BuyerRequest.fromSnapshot(doc))
//             .where((request) =>
//                 request.requestedItems.isNotEmpty &&
//                 request!.id != currentUser!.id)
//             .toList();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Shopper Page"),
//       ),
//       body: ListView.builder(
//         itemCount: buyerRequests.length,
//         itemBuilder: (context, index) {
//           final request = buyerRequests[index];
//           List<String> shoppingList = request.requestedItems
//               .map((item) => item.name as String)
//               .toList();
//           return Card(
//             elevation: 4,
//             margin: EdgeInsets.all(16),
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     shoppingList.join(', '),
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     "hostel: \ ${request.address['hostel']}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "College: \ ${request.address['college']}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Total: \ ${request.grandTotal.toStringAsFixed(2)}",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   RequestDetailScreen(request),
//                             ),
//                           );
//                         },
//                         child: Text("View Details"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class RequestDetailScreen extends StatefulWidget {
//   final BuyerRequest request;
//   late Seller seller;
//   RequestDetailScreen(this.request);

//   @override
//   State<RequestDetailScreen> createState() => _RequestDetailScreenState();
// }

// class _RequestDetailScreenState extends State<RequestDetailScreen> {
//   fetchData() {
//     FirebaseFirestore.instance
//         .collection('users')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       setState(() {
//         List<BuyerRequest> seller = querySnapshot.docs
//             .map((doc) => BuyerRequest.fromSnapshot(doc))
//             .where((request) => request.requestedItems.isNotEmpty)
//             .toList();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Details"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 "Room No: ${widget.request.address['room']}",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: Text(
//                 "Hostel: ${widget.request.address['hostel']}",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 30),
//             Center(
//               child: Text(
//                 "Requested Items:",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green),
//               ),
//             ),
//             SizedBox(height: 16),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columnSpacing: 40.0,
//                 columns: [
//                   DataColumn(label: Text("Item")),
//                   DataColumn(
//                     label: Text("Price (\₹)"),
//                     numeric: true,
//                   ),
//                   DataColumn(
//                     label: Text("Quantity"),
//                     numeric: true,
//                   ),
//                   DataColumn(
//                     label: Text("Total (\₹)"),
//                     numeric: true,
//                   ),
//                 ],
//                 rows: widget.request.requestedItems.map((item) {
//                   return DataRow(cells: [
//                     DataCell(Text(item.name)),
//                     DataCell(Text(item.price.toString())),
//                     DataCell(Text(item.quantity.toString())),
//                     DataCell(
//                       Text((item.price * item.quantity).toStringAsFixed(2)),
//                     ),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Grand Total: \₹${widget.request.grandTotal.toStringAsFixed(2)}",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 32),
//             Center(
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: _showModifyDialog,
//                     child: Text("Modify Invitation"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.yellow,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle cancellation logic here
//                     },
//                     child: Text("Cancel Invitation"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Fetch seller data from Firestore
//                       Seller seller = await fetchData();

//                       // Create an instance of OrderDetailScreen and pass Seller information
//                       OrderDetailsScreen orderDetailScreen = OrderDetailsScreen(
//                         seller: seller,
//                         showModifiedListButton: false,
//                       );

//                       // Display the OrderDetailScreen without navigation
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return orderDetailScreen;
//                         },
//                       );
//                     },
//                     child: Text("Send Invitation"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightGreenAccent,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showModifyDialog() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Modify Items'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: widget.request.requestedItems.map((item) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.name,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             'Price: ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: 'Enter price',
//                                 border: OutlineInputBorder(),
//                               ),
//                               controller: TextEditingController(
//                                 text: item.price
//                                     .toString()
//                                     .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   item.price = double.tryParse(value) ?? 0;
//                                   // Update grand total in state after price change
//                                   widget.request.calculateGrandTotal();
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Text(
//                             'Quantity: ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                 hintText: 'Enter quantity',
//                                 border: OutlineInputBorder(),
//                               ),
//                               controller: TextEditingController(
//                                 text: item.quantity
//                                     .toString()
//                                     .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   item.quantity = double.tryParse(value) ?? 0.0;
//                                   // Update grand total in state after quantity change
//                                   widget.request.calculateGrandTotal();
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Divider(color: Colors.grey),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Save', style: TextStyle(color: Colors.blue)),
//               onPressed: () async {
//                 // Update Firebase with modified data
//                 await FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(widget.request.id) // Assuming 'id' is the document ID
//                     .update({
//                   'shoppingList': widget.request.requestedItems
//                       .map((item) => item.toMap())
//                       .toList(),
//                   'grandTotal': widget.request.grandTotal,
//                 });

//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/models/buyer_request_model.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:shopper_cart/orders_details_list.dart';
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        buyerRequests = querySnapshot.docs
            .map((doc) => BuyerRequest.fromSnapshot(doc))
            .where((request) =>
                request.requestedItems.isNotEmpty &&
                request!.id != currentUser!.id)
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
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoppingList.join(', '),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "hostel: ${request.address['hostel']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "College: ${request.address['college']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${request.grandTotal.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RequestDetailScreen(request),
                            ),
                          );
                        },
                        child: Text("View Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RequestDetailScreen extends StatefulWidget {
  final BuyerRequest request;

  RequestDetailScreen(this.request);

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  Future<Seller> fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    if (currentUser == null) {
      throw Exception("User not found");
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser
            .id) // Assuming the seller document ID matches the user ID
        .get();

    if (doc.exists) {
      return Seller.fromSnapshot(doc);
    } else {
      throw Exception("Seller data not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Room No: ${widget.request.address['room']}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                "Hostel: ${widget.request.address['hostel']}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Requested Items:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 40.0,
                columns: [
                  DataColumn(label: Text("Item")),
                  DataColumn(
                    label: Text("Price (\₹)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Quantity"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Total (\₹)"),
                    numeric: true,
                  ),
                ],
                rows: widget.request.requestedItems.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item.name)),
                    DataCell(Text(item.price.toString())),
                    DataCell(Text(item.quantity.toString())),
                    DataCell(
                      Text((item.price * item.quantity).toStringAsFixed(2)),
                    ),
                  ]);
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Grand Total: \₹${widget.request.grandTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _showModifyDialog,
                    child: Text("Modify Invitation"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle cancellation logic here
                    },
                    child: Text("Cancel Invitation"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Fetch seller data from Firestore
                        Seller seller = await fetchData();

                        // Create an instance of OrderDetailScreen and pass Seller information
                        OrderDetailsScreen orderDetailScreen =
                            OrderDetailsScreen(
                          seller: seller,
                          showModifiedListButton: false,
                        );

                        // Display the OrderDetailScreen without navigation
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: orderDetailScreen,
                            );
                          },
                        );
                      } catch (e) {
                        print("Error fetching seller data: $e");
                        // Handle error (e.g., show a snackbar or dialog with an error message)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error fetching seller data")),
                        );
                      }
                    },
                    child: Text("Send Invitation"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModifyDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Items'),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.request.requestedItems.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter price',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: item.price
                                    .toString()
                                    .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  item.price = double.tryParse(value) ?? 0;
                                  // Update grand total in state after price change
                                  widget.request.calculateGrandTotal();
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Quantity: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter quantity',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: item.quantity
                                    .toString()
                                    .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  item.quantity = double.tryParse(value) ?? 0.0;
                                  // Update grand total in state after quantity change
                                  widget.request.calculateGrandTotal();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.blue)),
              onPressed: () async {
                // Update Firebase with modified data
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.request.id) // Assuming 'id' is the document ID
                    .update({
                  'shoppingList': widget.request.requestedItems
                      .map((item) => item.toMap())
                      .toList(),
                  'grandTotal': widget.request.grandTotal,
                });

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
