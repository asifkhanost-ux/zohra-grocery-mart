class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final List<String> savedAddresses;
  final double walletBalance;
  final int loyaltyPoints;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage = '',
    this.savedAddresses = const [],
    this.walletBalance = 0.0,
    this.loyaltyPoints = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      savedAddresses: List<String>.from(json['savedAddresses'] ?? []),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'savedAddresses': savedAddresses,
      'walletBalance': walletBalance,
      'loyaltyPoints': loyaltyPoints,
    };
  }
}
