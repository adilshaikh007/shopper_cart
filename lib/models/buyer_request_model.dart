import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper_cart/models/requested_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper_cart/models/requested_model.dart';

class BuyerRequest {
  final String id; // Add the id property
  final String displayName;
  final Map<String, dynamic> address;
  double grandTotal;
  late final List<RequestedItem> requestedItems;

  BuyerRequest({
    required this.id, // Update the constructor to accept id
    required this.displayName,
    required this.address,
    required this.grandTotal,
    required this.requestedItems,
  });

  factory BuyerRequest.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return BuyerRequest(
      id: snapshot.id, // Set the id from the snapshot
      displayName: data?['displayName'] ?? '',
      address: Map<String, dynamic>.from(data?['address'] ?? {}),
      grandTotal: (data?['grandTotal'] ?? 0.0).toDouble(),
      requestedItems: (data?['shoppingList'] ?? []).map<RequestedItem>((item) {
        return RequestedItem.fromMap(item);
      }).toList(),
    );
  }

  void calculateGrandTotal() {
    double total = 0.0;
    for (var item in requestedItems) {
      total += (item.price * item.quantity);
    }
    grandTotal = total;
  }
}

// class BuyerRequest {
//   final String displayName;
//   final Map<String, dynamic> address;
//   double grandTotal;
//   late final List<RequestedItem> requestedItems;

//   BuyerRequest({
//     required this.displayName,
//     required this.address,
//     required this.grandTotal,
//     required this.requestedItems,
//   });

//   factory BuyerRequest.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

//     return BuyerRequest(
//       displayName: data?['displayName'] ?? '',
//       address: Map<String, dynamic>.from(data?['address'] ?? {}),
//       grandTotal: (data?['grandTotal'] ?? 0.0).toDouble(),
//       requestedItems: (data?['shoppingList'] ?? []).map<RequestedItem>((item) {
//         return RequestedItem.fromMap(item);
//       }).toList(),
//     );
//   }
//   void calculateGrandTotal() {
//     double total = 0.0;
//     for (var item in requestedItems) {
//       total += (item.price * item.quantity);
//     }
//     grandTotal = total;
//   }
// }
