// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shopper_cart/models/makelistmodel.dart';
import 'package:shopper_cart/models/seller_model.dart';
import 'package:shopper_cart/page_changer.dart';
import 'package:shopper_cart/shopper_page.dart';
import 'package:shopper_cart/user_provider.dart';
import 'package:shopper_cart/orders_details_list.dart';

class MakeListPage extends StatefulWidget {
  @override
  _MakeListPageState createState() => _MakeListPageState();
}

class _MakeListPageState extends State<MakeListPage> {
  List<MakeListModel> shoppingList = [];
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _itemNameController = TextEditingController();

  List<String> itemSuggestions = [
    'Tea',
    'Samosa',
    'Cigarette',
    'Biryani',
    'Wazwan',
    'Vada Pav',
    'Chicken fried momos',
    'Veg steam momos',
    'Tea',
  ];

  List<String> priceSuggestions = [
    '10',
    '12',
    '20',
    '100',
    '200',
    '500',
    '1000'
  ];

  List<String> quantitySuggestions = ['1', '2', 'full', 'half', '5', '10'];
  Future<void> fetchShoppingList() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.id)
        .get();

    final data = documentSnapshot.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('shoppingList')) {
      setState(() {
        shoppingList = List<MakeListModel>.from(
          data['shoppingList'].map((item) => MakeListModel.fromJson(item)),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchShoppingList();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    _itemNameController.dispose();
    super.dispose();
  }

  Future<void> updateShoppingListInFirestore(List<MakeListModel> shoppingList,
      double grandTotal, bool findShoppersClicked) async {
    // Get the current user
    GoogleSignInAccount? user =
        Provider.of<UserProvider>(context, listen: false).user;

    // Check if the "Find Shoppers" button is clicked
    if (findShoppersClicked) {
      // Update the shopping list and grand total in Firestore only when "Find Shoppers" is clicked
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.id)
          .update({
        'shoppingList': shoppingList.map((item) {
          return {
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
          };
        }).toList(),
        'grandTotal': grandTotal, // Add the grand total to Firestore
      });
    }
  }

  // double calculateGrandTotal() {
  //   double total = 0;
  //   for (var item in shoppingList) {
  //     total += item.price * item.quantity;
  //   }
  //   return total;
  // }
  double calculateGrandTotal() {
    double total = 0;

    for (var item in shoppingList) {
      double quantity = (item.quantity.toLowerCase() == 'half')
          ? 0.5
          : (item.quantity.toLowerCase() == 'full')
              ? 1.0
              : double.tryParse(item.quantity) ?? 0;

      total += item.price * quantity;
    }

    return total;
  }

  void addItem(String itemName, String price, String quantity) {
    final itemPrice = double.tryParse(price) ?? 0;
    String itemQuantity = '';

    if (quantity.toLowerCase() == 'half') {
      itemQuantity = 'half';
    } else if (quantity.toLowerCase() == 'full') {
      itemQuantity = 'full';
    } else {
      itemQuantity = double.tryParse(quantity)?.toString() ?? '';
    }

    if (itemName.isNotEmpty && itemPrice > 0 && itemQuantity.isNotEmpty) {
      final newItem = MakeListModel(
          name: itemName, price: itemPrice, quantity: itemQuantity);
      setState(() {
        shoppingList.add(newItem);
      });

      double grandTotal = calculateGrandTotal();

      updateShoppingListInFirestore(shoppingList, grandTotal, false);
      _priceController.clear();
      _quantityController.clear();
      _itemNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields with valid values.'),
        ),
      );
    }
  }

  void deleteItem(int index) {
    setState(() {
      shoppingList.removeAt(index);
    });

    double grandTotal = calculateGrandTotal();

    updateShoppingListInFirestore(shoppingList, grandTotal, false);
  }

  void findShoppers(BuildContext context) async {
    // Calculate the grand total before navigating to SellerListPage
    double grandTotal = calculateGrandTotal();

    // Set findShoppersClicked to true before navigating to SellerListPage
    Provider.of<UserProvider>(context, listen: false).findShoppersClicked =
        true;

    if (shoppingList.isNotEmpty) {
      // Update the shopping list and grand total in Firestore before navigating
      await updateShoppingListInFirestore(shoppingList, grandTotal, true);

      // Navigate to ShopperPage and pass the shopping list
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PageChanger(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least 1 item to your cart.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Add Items to Your Shopping Cart",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) {
                  return itemSuggestions;
                }
                return itemSuggestions.where((item) =>
                    item.toLowerCase().contains(pattern.toLowerCase()));
              },
              noItemsFoundBuilder: (context) {
                return SizedBox(
                  height: 0,
                  width: 0,
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _itemNameController.text = suggestion;
                  _priceController.clear();
                  _quantityController.clear();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Price (\₹)",
                      ),
                    ),
                    noItemsFoundBuilder: (context) {
                      return SizedBox(
                        height: 0,
                        width: 0,
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return priceSuggestions;
                      }
                      return priceSuggestions.where((price) =>
                          price.toLowerCase().contains(pattern.toLowerCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _priceController.text = suggestion;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: "Quantity",
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return quantitySuggestions;
                      }
                      return quantitySuggestions.where((quantity) => quantity
                          .toLowerCase()
                          .contains(pattern.toLowerCase()));
                    },
                    noItemsFoundBuilder: (context) {
                      return SizedBox(
                        height: 0,
                        width: 0,
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      _quantityController.text = suggestion;
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                addItem(
                  _itemNameController.text,
                  _priceController.text,
                  _quantityController.text,
                );
              },
              child: Text("Add Item"),
              style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.length,
              itemBuilder: (context, index) {
                final item = shoppingList[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      "Price: \$${item.price.toStringAsFixed(2)}, Quantity: ${item.quantity}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItem(index);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grand Total: \₹${calculateGrandTotal().toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    findShoppers(context);
                  },
                  child: Text("Find Shoppers"),
                  style: ElevatedButton.styleFrom(
                      //     primary: Colors.green,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
