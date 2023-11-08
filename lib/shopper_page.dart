// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:shopper_cart/models/buyer_request_model.dart';
import 'package:shopper_cart/models/requested_model.dart';

class ShopperPage extends StatefulWidget {
  final List<RequestedItem> shoppingList;

  ShopperPage({required this.shoppingList});

  @override
  _ShopperPageState createState() => _ShopperPageState();
}

class _ShopperPageState extends State<ShopperPage> {
  List<BuyerRequest> buyerRequests = [];

  void updateBuyerRequest(BuyerRequest updatedRequest) {
    setState(() {
      final index = buyerRequests.indexWhere((request) =>
          request.address == updatedRequest.address &&
          request.requestTime == updatedRequest.requestTime);

      if (index != -1) {
        buyerRequests[index] = updatedRequest;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final buyerRequest = BuyerRequest(
      address: "123 Main Street",
      requestedItems: widget.shoppingList,
      requestTime: DateTime.now(),
    );

    buyerRequests.add(buyerRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seller Page"),
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
                    "Address: ${request.address}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Grand Total: ₹${request.getGrandTotal().toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Requested Items:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: request.requestedItems
                      .map((item) => Chip(
                            label: Text(item.name),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RequestDetailScreen(request, updateBuyerRequest),
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

class RequestDetailScreen extends StatefulWidget {
  final BuyerRequest request;
  final Function(BuyerRequest) onUpdate;

  RequestDetailScreen(this.request, this.onUpdate);

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detailed Description",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Address: ${widget.request.address}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
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
                    label: Text("Price (₹)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Quantity"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Total (₹)"),
                    numeric: true,
                  ),
                ],
                rows: widget.request.requestedItems.map((item) {
                  final total = item.price * item.quantity;
                  return DataRow(
                    cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text("₹${item.price.toStringAsFixed(2)}")),
                      DataCell(Text(item.quantity.toString())),
                      DataCell(Text("₹${total.toStringAsFixed(2)}")),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Grand Total: ₹${widget.request.getGrandTotal().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ModifyInvitationDialog(
                        widget.request,
                        widget.onUpdate,
                        () {
                          setState(() {});
                        },
                      ),
                    );
                  },
                  child: Text("Modify Invitation"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle cancellation logic here
                  },
                  child: Text("Cancel Invitation"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle sending invitation logic here
                  },
                  child: Text("Send Invitation"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ModifyInvitationDialog extends StatefulWidget {
  final BuyerRequest request;
  final Function(BuyerRequest) onUpdate;
  final VoidCallback onDone;

  ModifyInvitationDialog(this.request, this.onUpdate, this.onDone);

  @override
  _ModifyInvitationDialogState createState() => _ModifyInvitationDialogState();
}

class _ModifyInvitationDialogState extends State<ModifyInvitationDialog> {
  double _grandTotal = 0.0;

  void updateItemsAndTotal(List<RequestedItem> updatedItems) {
    final updatedRequest = BuyerRequest(
      address: widget.request.address,
      requestedItems: updatedItems,
      requestTime: widget.request.requestTime,
    );

    setState(() {
      widget.onUpdate(updatedRequest);
      _grandTotal = updatedRequest.getGrandTotal();
    });
  }

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
                    label: Text("Price (₹)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Quantity"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Total (₹)"),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text("Actions"),
                    numeric: false,
                  ),
                ],
                rows: widget.request.requestedItems.map((item) {
                  final total = item.price * item.quantity;
                  return DataRow(
                    cells: [
                      DataCell(Text(item.name)),
                      DataCell(Text("₹${item.price.toStringAsFixed(2)}")),
                      DataCell(Text(item.quantity.toString())),
                      DataCell(Text("₹${total.toStringAsFixed(2)}")),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditPriceDialog(
                                    item,
                                    (newPrice, newQuantity) {
                                      // Update the item and notify the changes
                                      final updatedItems = widget
                                          .request.requestedItems
                                          .map((existingItem) =>
                                              existingItem == item
                                                  ? RequestedItem(
                                                      name: existingItem.name,
                                                      price: newPrice,
                                                      quantity: newQuantity,
                                                    )
                                                  : existingItem)
                                          .toList();

                                      updateItemsAndTotal(updatedItems);
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  widget.request.requestedItems.remove(item);
                                  _grandTotal = widget.request.getGrandTotal();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Grand Total: ₹${_grandTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.onDone();
            widget.onUpdate(widget.request);
            Navigator.pop(context);
          },
          child: Text("Done"),
        ),
      ],
    );
  }
}

class EditPriceDialog extends StatefulWidget {
  final RequestedItem item;
  final Function(double newPrice, int newQuantity) onSave;

  EditPriceDialog(this.item, this.onSave);

  @override
  _EditPriceDialogState createState() => _EditPriceDialogState();
}

class _EditPriceDialogState extends State<EditPriceDialog> {
  late TextEditingController priceController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    priceController =
        TextEditingController(text: widget.item.price.toStringAsFixed(2));
    quantityController =
        TextEditingController(text: widget.item.quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Price and Quantity"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "New Price (₹)"),
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
            setState(() {
              double newPrice = double.parse(priceController.text);
              int newQuantity = int.parse(quantityController.text);

              // Update the item with new values
              widget.item.price = newPrice;
              widget.item.quantity = newQuantity;

              // Call onSave to save changes
              widget.onSave(newPrice, newQuantity);
              Navigator.of(context).pop();
            });
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
