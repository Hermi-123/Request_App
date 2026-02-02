class ServiceModel {
  final String id;
  final String categoryId;
  final String name;
  final double basePrice;
  final double vatPercent;
  final double discountAmount;
  final String? imageUrl;
  final String status; // 'active', 'inactive'

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.basePrice,
    required this.vatPercent,
    required this.discountAmount,
    this.imageUrl,
    this.status = 'active',
  });

  // Computed property
  double get totalPrice {
    double vatAmount = basePrice * (vatPercent / 100);
    return (basePrice + vatAmount) - discountAmount;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'basePrice': basePrice,
      'vatPercent': vatPercent,
      'discountAmount': discountAmount,
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      vatPercent: (map['vatPercent'] ?? 0).toDouble(),
      discountAmount: (map['discountAmount'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'active',
    );
  }
}
