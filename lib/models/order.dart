class Order {
  final String id;  final String userId;  final String orderNumber;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  String status; // pending, confirmed, on_way, delivered
  final String orderDate;
  final String estimatedDelivery;
  final String deliveryAddress;
  final String paymentMethod;
  final double riderLatitude;
  final double riderLongitude;
  final String riderName;
  final String riderPhone;

  Order({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.estimatedDelivery,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.riderLatitude = 0.0,
    this.riderLongitude = 0.0,
    this.riderName = '',
    this.riderPhone = '',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      orderDate: json['orderDate'] ?? '',
      estimatedDelivery: json['estimatedDelivery'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'COD',
      riderLatitude: (json['riderLatitude'] ?? 0).toDouble(),
      riderLongitude: (json['riderLongitude'] ?? 0).toDouble(),
      riderName: json['riderName'] ?? '',
      riderPhone: json['riderPhone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderNumber': orderNumber,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate,
      'estimatedDelivery': estimatedDelivery,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'riderLatitude': riderLatitude,
      'riderLongitude': riderLongitude,
      'riderName': riderName,
      'riderPhone': riderPhone,
    };
  }

  String getStatusLabel() {
    switch (status) {
      case 'confirmed':
        return 'Order Confirmed';
      case 'on_way':
        return 'On the way';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Pending';
    }
  }
}
