// ignore_for_file: sized_box_for_whitespace, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/add_address_page.dart';
import 'package:shopper_cart/user_provider.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
);

class BuyerPage extends StatefulWidget {
  @override
  _BuyerPageState createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> suggestedPlaces = [
    "Canteen",
    "Nescafe",
    "Kashmir University Road",
    "Lal Chowk",
    "Shwarma Hut",
    "Parsa's",
    "Turfah Restaurant",
    "Domino's",
    "City One Mall",
    // Add more
    //suggested places here
  ];

  List<String> filteredPlaces = [];
  String selectedLocation = "";

  @override
  void initState() {
    super.initState();
    filteredPlaces = suggestedPlaces;
  }

  void _filterPlaces(String query) {
    setState(() {
      filteredPlaces = suggestedPlaces
          .where((place) => place.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToMakeListPage() {
    Navigator.of(context).pushNamed("/makelist");
  }

  void _showLocationSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Location"),
          content: Container(
            width: double.maxFinite,
            child: FutureBuilder<List<String>>(
              future: _fetchLocationsFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No locations available");
                } else {
                  List<String> locations = snapshot.data!;
                  locations.add("Add New Address");

                  return Column(
                    children: [
                      DropdownButton<String>(
                        value:
                            selectedLocation.isEmpty ? null : selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });
                        },
                        items: locations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedLocation == "Add New Address") {
                            Navigator.pop(context); // Close the current dialog
                            _navigateToAddNewAddress(
                                context); // Navigate to add new address page
                          } else {
                            Navigator.pop(context);
                            _navigateToSelectAddress();
                          }
                        },
                        child: Text("Select Address"),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _fetchLocationsFromFirebase() async {
    // final currentUser = _googleSignIn.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    if (currentUser == null || currentUser.id == null) {
      // User not authenticated
      return ["User not authenticated."];
    }

    print("Current user ID: ${currentUser.id}");

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .get();

      print("User document data: ${userSnapshot.data()}");

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final address = userData.containsKey('address')
            ? userData['address'] as Map<String, dynamic>
            : null;

        print("Address data: $address");

        if (address != null && address.containsKey('area')) {
          final area = address['area'] as String;
          return [area];
        } else {
          // Address data is incomplete or missing
          return [
            "Your address is not available. Please add your address to proceed."
          ];
        }
      } else {
        // User document does not exist
        return ["User data not found."];
      }
    } catch (error) {
      print("Error fetching data: $error");
      // Handle errors here, e.g., show a user-friendly message or log the error
      return ["Error fetching data. Please try again later."];
    }
  }

  void _navigateToAddNewAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    ).then((value) {
      if (value == true) {
        _fetchLocationsFromFirebase().then((locations) {
          setState(() {
            selectedLocation = locations.last;
          });
        });
      }
    });
  }

  void _navigateToSelectAddress() {
    Navigator.pushNamed(context, "/selectaddress").then((selectedAddress) {
      if (selectedAddress != null) {
        setState(() {
          selectedLocation = selectedAddress as String? ?? "";
        });
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _showLocationSelectionDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Where do you want to buy from?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPlaces,
              onSubmitted: (value) {
                _navigateToMakeListPage();
              },
              decoration: InputDecoration(
                hintText: "Search for places...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _navigateToMakeListPage,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Suggested Places",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                final placeName = filteredPlaces[index];
                return _buildSuggestedPlace(placeName, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPlace(String placeName, BuildContext context) {
    return GestureDetector(
      onTap: _navigateToMakeListPage,
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
        title: Text(
          placeName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
