// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
    // Navigate to the "/makelist" route
    Navigator.of(context).pushNamed("/makelist");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer Page"),
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
                // Navigate to the "/makelist" route when the user presses Enter
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
                fillColor: Colors.grey[200], // Background color
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
      onTap: () {
        // Navigate to the "/makelist" route when a suggested place is tapped
        _navigateToMakeListPage();
      },
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: Colors.blue, // Icon color
        ),
        title: Text(
          placeName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
