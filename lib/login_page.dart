// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/models/makelistmodel.dart';
import 'package:shopper_cart/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? currentUser;
  List<MakeListModel> shoppingList = [];

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account;
      });
      if (currentUser != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
        print("User is already authenticated");
      }
    });

    _googleSignIn.signInSilently();

    super.initState();
  }

  Future<void> storeUserDataInFirestore(GoogleSignInAccount user) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    await users.doc(user.id).set({
      'id': user.id,
      'displayName': user.displayName,
      'email': user.email,
      'photoUrl': user.photoUrl,
    });
  }

  void navigateToAddressInputScreen(GoogleSignInAccount currentUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddressInputScreen(currentUser: currentUser)),
    );
  }

  void handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      final currentUser = _googleSignIn.currentUser;
      Provider.of<UserProvider>(context, listen: false).setUser(currentUser);

      await storeUserDataInFirestore(currentUser!);

      navigateToAddressInputScreen(currentUser);
    } catch (error) {
      print('ERROR: $error');
    }
  }

  void handleSignOut() async {
    _googleSignIn.signOut();
    _googleSignIn.disconnect();
    Provider.of<UserProvider>(context, listen: false).signOut();
    print("User signed out");
  }

  Widget buildBody() {
    GoogleSignInAccount? user =
        currentUser ?? Provider.of<UserProvider>(context).user;

    if (user != null) {
      print(user.displayName);

      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                "assets/ll.png",
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Welcome to Shopper-Cart",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Don't have an account? SignIn",
                style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  handleSignIn();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/google.png",
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(
        child: buildBody(),
      ),
    );
  }
}

class AddressInputScreen extends StatefulWidget {
  final GoogleSignInAccount currentUser;

  const AddressInputScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final TextEditingController roomController = TextEditingController();
  final TextEditingController hostelController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: roomController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'Room/House No'),
              ),
              TextField(
                controller: hostelController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'Hostel Name'),
              ),
              TextField(
                controller: collegeController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'College Name'),
              ),
              TextField(
                controller: areaController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'Area'),
              ),
              TextField(
                controller: cityController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'City/District'),
              ),
              TextField(
                controller: stateController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: phoneController,
                onChanged: (_) => setState(() {}),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: isFormValid() ? storeAddressInFirestore : null,
                child: Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isFormValid() {
    return roomController.text.isNotEmpty &&
        hostelController.text.isNotEmpty &&
        collegeController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  void storeAddressInFirestore() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    await users.doc(widget.currentUser.id).update({
      'address': {
        'room': roomController.text,
        'hostel': hostelController.text,
        'college': collegeController.text,
        'area': areaController.text,
        'city': cityController.text,
        'state': stateController.text,
        'phone': phoneController.text,
      },
    });

    Navigator.pop(context); // Close the current screen
    Navigator.pushReplacementNamed(context, "/page"); // Navigate to "/page"
  }
}
