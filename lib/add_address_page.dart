import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/user_provider.dart';

class AddAddressPage extends StatefulWidget {
  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _areaController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();

  final TextEditingController _collegeController = TextEditingController();

  final TextEditingController _hostelController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _roomController = TextEditingController();

  final TextEditingController _stateController = TextEditingController();

  void _addNewAddress(BuildContext context) async {
    String area = _areaController.text.trim();
    String city = _cityController.text.trim();
    String college = _collegeController.text.trim();
    String hostel = _hostelController.text.trim();
    String phone = _phoneController.text.trim();
    String room = _roomController.text.trim();
    String state = _stateController.text.trim();

    if (area.isEmpty ||
        city.isEmpty ||
        college.isEmpty ||
        hostel.isEmpty ||
        phone.isEmpty ||
        room.isEmpty ||
        state.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
      ));
      return;
    }

    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;
      await users.doc(currentUser!.id).update({
        'address': {
          'room': _roomController.text,
          'hostel': _hostelController.text,
          'college': _collegeController.text,
          'area': _areaController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'phone': _phoneController.text,
        },
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Address updated successfully.'),
      ));
      Navigator.pop(context, true); // Return true to indicate success
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding address. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _areaController,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _collegeController,
              decoration: InputDecoration(labelText: 'College'),
            ),
            TextField(
              controller: _hostelController,
              decoration: InputDecoration(labelText: 'Hostel'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _roomController,
              decoration: InputDecoration(labelText: 'Room'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addNewAddress(context),
              child: Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }
}
