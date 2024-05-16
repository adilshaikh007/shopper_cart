class RequestedItem {
  final String name;
  double price;
  double quantity;

  RequestedItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory RequestedItem.fromMap(Map<String, dynamic> map) {
    return RequestedItem(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: _parseQuantity(map['quantity']),
    );
  }

  static double _parseQuantity(dynamic quantity) {
    if (quantity is num) {
      return quantity.toDouble();
    } else if (quantity is String) {
      if (quantity.toLowerCase() == 'half') {
        return 0.5;
      } else if (quantity.toLowerCase() == 'full') {
        return 1;
      } else {
        return double.tryParse(quantity) ?? 0.0;
      }
    } else {
      return 0.0;
    }
  }

  String getDisplayQuantity() {
    if (quantity == 1 && quantity == double) {
      return 'Full';
    } else if (quantity == 0.5) {
      return 'Half';
    } else {
      return quantity.toString();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
