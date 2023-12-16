// class RequestedItem {
//   final String name;
//   double price;
//   int quantity;

//   RequestedItem({
//     required this.name,
//     required this.price,
//     required this.quantity,
//   });
// }
class RequestedItem {
  final String name;
  final double price;
  final double quantity;

  RequestedItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory RequestedItem.fromMap(Map<String, dynamic> map) {
    return RequestedItem(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: double.tryParse(map['quantity'].toString()) ?? 0.0,
    );
  }
}
