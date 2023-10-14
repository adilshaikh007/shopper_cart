// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shopper_cart/models/makelistmodel.dart';
import 'package:shopper_cart/seller_list.dart';

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

    // Add more suggested names here
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

  List<String> quantitySuggestions = ['1', '2', '5', '10'];

  @override
  void dispose() {
    _priceController.dispose();
    _quantityController.dispose();
    _itemNameController.dispose(); // Dispose the item name controller
    super.dispose();
  }

  double calculateGrandTotal() {
    double total = 0;
    for (var item in shoppingList) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(String itemName, String price, String quantity) {
    final itemPrice = double.tryParse(price) ?? 0;
    final itemQuantity = int.tryParse(quantity) ?? 0;

    if (itemName.isNotEmpty && itemPrice > 0 && itemQuantity > 0) {
      final newItem = MakeListModel(
          name: itemName, price: itemPrice, quantity: itemQuantity);
      setState(() {
        shoppingList.add(newItem);
      });
      _priceController.clear();
      _quantityController.clear();
      _itemNameController.clear(); // Clear the item name field
    } else {
      // Handle validation or display an error message
    }
  }

  void findShoppers(BuildContext context) {
    if (shoppingList.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SellerListPage(),
        ),
      );
    } else {
      // Show a snackbar message when the shopping list is empty
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
                // Show all items if the field is empty
                if (pattern.isEmpty) {
                  return itemSuggestions;
                }

                // Otherwise, return matching suggestions
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
                  _itemNameController.text =
                      suggestion; // Fill the item name field
                  _priceController.clear(); // Clear the price field
                  _quantityController.clear(); // Clear the quantity field
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
                      // Show all prices if the field is empty
                      if (pattern.isEmpty) {
                        return priceSuggestions;
                      }

                      // Otherwise, return matching price suggestions
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
                      // Show all quantities if the field is empty
                      if (pattern.isEmpty) {
                        return quantitySuggestions;
                      }

                      // Otherwise, return matching quantity suggestions
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
                ); // Use item name controller
              },
              child: Text("Add Item"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
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
                    findShoppers(context); // Pass context to findShoppers
                  },
                  child: Text("Find Shoppers"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
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
