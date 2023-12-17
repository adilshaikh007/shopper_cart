import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopper_cart/models/requested_model.dart';

class BuyerRequest {
  final String displayName;
  final Map<String, dynamic> address;
  final double grandTotal;
  final List<RequestedItem> requestedItems;

  BuyerRequest({
    required this.displayName,
    required this.address,
    required this.grandTotal,
    required this.requestedItems,
  });

  factory BuyerRequest.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return BuyerRequest(
      displayName: data?['displayName'] ?? '',
      address: Map<String, dynamic>.from(data?['address'] ?? {}),
      grandTotal: (data?['grandTotal'] ?? 0.0).toDouble(),
      requestedItems: (data?['shoppingList'] ?? []).map<RequestedItem>((item) {
        return RequestedItem.fromMap(item);
      }).toList(),
    );
  }
}
