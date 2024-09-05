// import 'package:cloud_firestore/cloud_firestore.dart';

// class Seller {
//   //final String name;
//   final String shoppinglocation;
//   final String deliveryTime;
//   //final String deliveryPersonHomeAddress;
//   final String phoneNumber;
//   final bool modifiedList;

//   Seller({
// //    required this.name,
//     required this.shoppinglocation,
//     required this.deliveryTime,
//     //  required this.deliveryPersonHomeAddress,
//     required this.phoneNumber,
//     this.modifiedList = false,
//   });

// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  // final String name;
  final String shoppinglocation;
  final String deliveryTime;
  // final String deliveryPersonHomeAddress;
  final String phoneNumber;
  final bool modifiedList;

  Seller({
    // required this.name,
    required this.shoppinglocation,
    required this.deliveryTime,
    // required this.deliveryPersonHomeAddress,
    required this.phoneNumber,
    this.modifiedList = false,
  });

  // Factory constructor to create a Seller object from Firestore snapshot
  factory Seller.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Seller(
      // name: data['name'] ?? '',
      shoppinglocation: data['shoppinglocation'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '',
      // deliveryPersonHomeAddress: data['deliveryPersonHomeAddress'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      modifiedList: data['modifiedList'] ?? false,
    );
  }

  // Method to convert Seller object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      // 'name': name,
      'shoppinglocation': shoppinglocation,
      'deliveryTime': deliveryTime,
      // 'deliveryPersonHomeAddress': deliveryPersonHomeAddress,
      'phoneNumber': phoneNumber,
      'modifiedList': modifiedList,
    };
  }
}
