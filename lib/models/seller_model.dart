class Seller {
  final String name;
  final String shoppinglocation;
  final String deliveryTime;
  final String deliveryPersonHomeAddress;
  final String phoneNumber;
  final bool modifiedList;

  Seller({
    required this.name,
    required this.shoppinglocation,
    required this.deliveryTime,
    required this.deliveryPersonHomeAddress,
    required this.phoneNumber,
    this.modifiedList = false,
  });
}
