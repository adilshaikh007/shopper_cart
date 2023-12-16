// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// class BuyerPage extends StatefulWidget {
//   @override
//   _BuyerPageState createState() => _BuyerPageState();
// }

// class _BuyerPageState extends State<BuyerPage> {
//   TextEditingController _searchController = TextEditingController();
//   List<String> suggestedPlaces = [
//     "Canteen",
//     "Nescafe",
//     "Kashmir University Road",
//     "Lal Chowk",
//     "Shwarma Hut",
//     "Parsa's",
//     "Turfah Restaurant",
//     "Domino's",
//     "City One Mall",
//     // Add more suggested places here
//   ];

//   List<String> filteredPlaces = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredPlaces = suggestedPlaces;
//   }

//   void _filterPlaces(String query) {
//     setState(() {
//       filteredPlaces = suggestedPlaces
//           .where((place) => place.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _navigateToMakeListPage() {
//     // Navigate to the "/makelist" route
//     Navigator.of(context).pushNamed("/makelist");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Buyer Page"),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Where do you want to buy from?",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _filterPlaces,
//               onSubmitted: (value) {
//                 // Navigate to the "/makelist" route when the user presses Enter
//                 _navigateToMakeListPage();
//               },
//               decoration: InputDecoration(
//                 hintText: "Search for places...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _navigateToMakeListPage,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200], // Background color
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               "Suggested Places",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredPlaces.length,
//               itemBuilder: (context, index) {
//                 final placeName = filteredPlaces[index];
//                 return _buildSuggestedPlace(placeName, context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuggestedPlace(String placeName, BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the "/makelist" route when a suggested place is tapped
//         _navigateToMakeListPage();
//       },
//       child: ListTile(
//         leading: Icon(
//           Icons.location_on,
//           color: Colors.blue, // Icon color
//         ),
//         title: Text(
//           placeName,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    // Add more suggested places here
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
                            _navigateToAddNewAddress();
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

  void _navigateToAddNewAddress() {
    Navigator.pushNamed(context, "/addaddress").then((value) {
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

  Future<List<String>> _fetchLocationsFromFirebase() async {
    final currentUser = _googleSignIn.currentUser;

    if (currentUser != null && currentUser.id != null) {
      print("Current user ID: ${currentUser.id}");

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .get();

      print("User document data: ${userSnapshot.data()}");

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('address')) {
          Map<String, dynamic>? address = userData['address'];
          print("Address data: $address");

          if (address != null && address['city'] != null) {
            String city = address['city'];
            List<String> locations = [city];
            return locations;
          }
        }
      }
    }

    // Default return value if something goes wrong or no address found
    return ["No Address Found"];
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
