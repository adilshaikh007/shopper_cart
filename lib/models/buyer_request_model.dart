import 'package:shopper_cart/models/requested_model.dart';

class BuyerRequest {
  final String address;
  final List<RequestedItem> requestedItems;
  final DateTime requestTime;

  BuyerRequest({
    required this.address,
    required this.requestedItems,
    required this.requestTime,
  });

  double getGrandTotal() {
    double grandTotal = 0;
    for (var item in requestedItems) {
      grandTotal += item.price * item.quantity;
    }
    return grandTotal;
  }
}
