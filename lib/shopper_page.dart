// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Requested Items:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    shoppingList.join(', '),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: \$${request.grandTotal.toStringAsFixed(2)}",
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
                    onPressed: () {
                      // Handle sending invitation logic here
                    },
                    child: Text("Send Invitation"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

  void _showModifyDialog() {
    showDialog(
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
              onPressed: () {
                setState(() {
                  widget.request.calculateGrandTotal();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
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
//     FirebaseFirestore.instance
//         .collection('users')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       setState(() {
//         buyerRequests = querySnapshot.docs
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
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text(
//                     "Requested Items: ${shoppingList.join(', ')}",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     "Grand Total: \$${request.grandTotal.toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Address:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Room No: ${request.address['room']}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   "Hostel: ${request.address['hostel']}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   "College: ${request.address['college']}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 // Add more fields as needed
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RequestDetailScreen(request),
//                       ),
//                     );
//                   },
//                   child: Text("View Details"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class RequestDetailScreen extends StatefulWidget {
//   final BuyerRequest request;

//   RequestDetailScreen(this.request);

//   @override
//   State<RequestDetailScreen> createState() => _RequestDetailScreenState();
// }

// class _RequestDetailScreenState extends State<RequestDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Request Details"),
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16),
//                   Center(
//                     child: Text(
//                       "Room No: ${widget.request.address['room']}",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Center(
//                     child: Text(
//                       "Hostel: ${widget.request.address['hostel']}",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Text(
//                     "Requested Items:",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       columnSpacing: 40.0,
//                       columns: [
//                         DataColumn(label: Text("Item")),
//                         DataColumn(
//                           label: Text("Price (\₹)"),
//                           numeric: true,
//                         ),
//                         DataColumn(
//                           label: Text("Quantity"),
//                           numeric: true,
//                         ),
//                         DataColumn(
//                           label: Text("Total (\₹)"),
//                           numeric: true,
//                         ),
//                       ],
//                       rows: widget.request.requestedItems.map((item) {
//                         return DataRow(cells: [
//                           DataCell(Text(item.name)),
//                           DataCell(Text(item.price.toString())),
//                           DataCell(Text(item.quantity.toString())),
//                           DataCell(
//                             Text((item.price * item.quantity)
//                                 .toStringAsFixed(2)),
//                           ),
//                         ]);
//                       }).toList(),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     "Grand Total: \₹${widget.request.grandTotal.toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 32),
//                   Center(
//                     child: Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: _showModifyDialog,
//                           child: Text("Modify Invitation"),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.yellow),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             // Handle cancellation logic here
//                           },
//                           child: Text("Cancel Invitation"),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             // Handle sending invitation logic here
//                           },
//                           child: Text("Send Invitation"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showModifyDialog() {
//     showDialog(
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
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text('Price: ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
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

//                                 //item.price.toString()
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   item.price = double.tryParse(value) ?? 0;
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Text('Quantity: ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
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
//                                 //item.quantity.toString()
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   item.quantity = double.tryParse(value) ?? 0.0;
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
//               onPressed: () {
//                 setState(() {
//                   widget.request.calculateGrandTotal();
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
