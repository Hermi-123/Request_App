class CategoryModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String status; // 'active', 'inactive'

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'active',
    );
  }
}
