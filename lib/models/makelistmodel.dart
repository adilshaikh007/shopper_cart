class MakeListModel {
  String name;
  double price;
  dynamic quantity;

  MakeListModel({
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Add this factory method to convert JSON to MakeListModel
  factory MakeListModel.fromJson(Map<String, dynamic> json) {
    return MakeListModel(
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? '',
    );
  }

  // Add this method to convert MakeListModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
