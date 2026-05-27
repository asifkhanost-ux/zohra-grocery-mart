class CartItem {
  final String productId;
  final String name;
  final String price;
  final String emoji;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.emoji,
    required this.quantity,
  });

  double getTotalPrice() {
    double singlePrice = double.tryParse(price.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
    return singlePrice * quantity;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      emoji: json['emoji'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'emoji': emoji,
      'quantity': quantity,
    };
  }
}
